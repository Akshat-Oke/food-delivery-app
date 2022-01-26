import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserTypes { visitor, user, owner }
late SharedPreferences prefs;
int refresh = 2;

class LoginManager with ChangeNotifier {
  LoginManager() {
    _setUpMessaging();
  }
  void reset() {
    user = resOwner = _userType = null;
  }

  UserTypes? _userType;
  ResOwner? resOwner;
  Student? user;
  UserTypes get userType => _userType ?? UserTypes.visitor;
  bool get isLoggedIn => _userType != null;
  Future<void> init({User? fireUser}) async {
    prefs = await SharedPreferences.getInstance();
    String? room = prefs.getString("room");
    if (room != null) {
      user = Student(room);
      print(user);
      user!.id = prefs.getString("id");
      user!.name = prefs.getString("name");
      _userType = UserTypes.user;
      notifyListeners();
      return;
    }
    if (fireUser != null) {
      await _fetchUser(fireUser);
      setUpFireuserListener(fireUser.uid);
    }
    // checkFirebase();
    notifyListeners();
  }

  void checkFirebase(User? user) async {
    var curUser = FirebaseAuth.instance.currentUser;
    if (curUser != null) {
      if (refresh >= 0) {
        refresh--;
        await _fetchUser(curUser);
        notifyListeners();
      }
      return;
    }
    if (user != null) {
      if (refresh >= 0) {
        refresh--;
        await _fetchUser(user);
        notifyListeners();
      }
      return;
    }
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     _userType = null;
    //     notifyListeners();
    //   } else {
    //     fetchUser(user);
    //   }
    // });
  }

  void setUpFireuserListener(String uid) {
    print("setting up $uid");
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((event) {
      refresh = 1;
      checkFirebase(null);
    });
  }

  Future<void> _fetchUser(User user) async {
    final uid = user.uid;
    var doc = FirebaseFirestore.instance.collection("users").doc(uid);
    var document = await doc.get();
    var resId = document.data()?["resId"] ?? "";
    try {
      doc = FirebaseFirestore.instance.collection("restaurants").doc(resId);
      document = await doc.get();
      final data = document.data();
      _userType = UserTypes.owner;
      resOwner = ResOwner(
        uid: uid,
        resId: resId,
        name: data?["name"] ?? "Outlet",
        categories: data?["categories"] ?? [],
      );
    } on Exception catch (e) {
      resOwner = null;
    } finally {
      // setUpFireuserListener(uid);
    }
    // notifyListeners();
  }

  void logoutUser() {
    prefs.remove("room");
    _userType = null;
    user = null;
    notifyListeners();
  }

  void _setUserType(UserTypes type) {
    _userType = type;
    notifyListeners();
  }

  void loginUser({required String room, String? name, String? id}) {
    user = Student(room);
    user?.setData(name: name, id: id);
    user?.saveUserLocally();
    _setUserType(UserTypes.user);
  }
}

class ResOwner {
  final String uid;
  final String resId;
  final String name;
  final List<dynamic> categories;

  ResOwner(
      {required this.uid,
      required this.resId,
      required this.name,
      required this.categories});
}

class Student {
  Student(this.room);
  void setData({String? name, String? id}) {
    this.name = name;
    this.id = id;
  }

  void saveUserLocally() {
    prefs.setString("room", room);
    if (name != null) prefs.setString("name", name ?? "");
    if (id != null) prefs.setString("id", id ?? "");
  }

  String room;
  String? name;
  String? id;
}

void _setUpMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

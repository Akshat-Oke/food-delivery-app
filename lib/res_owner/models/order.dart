import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fooddeli/models/cart_provider.dart';
import 'package:fooddeli/models/menu_item.dart';
import 'package:fooddeli/models/restaurant_model.dart' show TimeOfTimestamp;

class Order with ChangeNotifier {
  List<dynamic> items;
  List<CartItem> cartItems = [];
  final Timestamp time;
  final String userFCM, room;
  String? resName;
  String? id;

  String timeString(BuildContext context) {
    final date = time.toDate();
    final d =
        ",  ${date.day.toString()}/${date.month.toString()}/${date.year.toString().substring(2)}";
    return time.toTimeOfDay().format(context) + d;
  }

  Order({
    required this.items,
    required this.time,
    required this.userFCM,
    required this.room,
    this.id,
  });

  Future<void> getItemDetails(String resId) async {
    // cartItems.clear();
    final CollectionReference col =
        FirebaseFirestore.instance.collection("restaurants/$resId/items");
    print("restaurants/$resId/items");
    FirebaseFirestore.instance
        .collection("restaurants")
        .doc(resId)
        .get()
        .then((val) {
      resName = val.data()?['name'];
    });
    await Future.forEach<dynamic>(items, (item) async {
      final itemId = item['id'] ?? item["itemId"];
      final String strQuantity = (item['quantity']).toString();
      final int quantity = int.parse(strQuantity);
      final doc = await col.doc(itemId).get();
      final map = (doc.data()! as Map<String, dynamic>);
      map["restaurantId"] = resId;
      // print(itemId);
      cartItems.add(CartItem(
        MenuItem.fromJSON(map, resId),
        quantity: quantity,
      ));
    });
    // print(cartItems);
    notifyListeners();
  }

  factory Order.fromJSON(Map<String, dynamic> json, String? id) {
    return Order(
      items: (json["items"] as List<dynamic>?) ?? [],
      time: json['time'],
      userFCM: json["fcm"] ?? "fcm",
      room: json["room"] ?? "room",
      id: id,
    );
  }
}

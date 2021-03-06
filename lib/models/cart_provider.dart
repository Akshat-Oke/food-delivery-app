import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fooddeli/cart/payment.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/utility/firebase_orders.dart' show serverBaseURL;
import 'package:http/http.dart' as http;

import 'menu_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> items = [];
  String restaurantId = "";
  String room = "";
  CartProvider() {
    room = "VK 312";
  }
  void setRestaurant(String r) {
    // print("setting $r");
    if (restaurantId != r) {
      items.clear();
    }
    restaurantId = r;
    notifyListeners();
  }

  /// Adds a [menuItem] to cart
  ///
  /// If the [menuItem] already exists, its
  /// quantity is increased
  void addToCart(MenuItem menuItem) {
    for (var item in items) {
      if (item.menuItem.id == menuItem.id) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    items.add(CartItem(menuItem));
    notifyListeners();
  }

  int getQuantityOf(MenuItem menuItem) {
    int q = 0;
    final i = items.indexWhere((element) => element.menuItem.id == menuItem.id);
    if (i != -1) {
      q = items[i].quantity;
    }
    return q;
  }

  /// Decrease quantity of the [menuItem] by 1.
  ///
  /// If quantity was 1 to begin with, this [menuItem]
  /// is removed from the cart.
  void decreaseQuantity(MenuItem menuItem) {
    final i = items.indexWhere((element) => element.menuItem.id == menuItem.id);

    ///items.firstWhere((element) => element.menuItem.id == menuItem.id);
    if (items[i].quantity == 1) {
      items.removeAt(i);
    } else {
      items[i].quantity--;
    }
    notifyListeners();
  }

  /// Total cost of order
  int get totalPrice {
    int t = 0;
    for (var element in items) {
      t += element.cost;
    }
    return t;
  }

  /// Places order after initiating payment
  Future<bool> placeOrder() async {
    if (!await internetIsAvailable()) {
      return false;
    }
    try {
      final fcm = await FirebaseMessaging.instance.getToken();
      final itemsAsJson = items.map((e) => e.toJSON()).toList();
      final orderId = (DateTime.now().microsecondsSinceEpoch / 100).toString();
      final orderJson = {
        "items": itemsAsJson,
        "room": room,
        "time": Timestamp.now(),
        "fcm": fcm,
        "orderId": orderId,
      };
      final response =
          await http.post(Uri.parse("$serverBaseURL/txnToken"), body: {
        "amount": totalPrice.toString(),
        "orderId": orderId,
      });
      final token =
          jsonDecode(response.body.toString()) as Map<String, dynamic>;
      await startPayment(
          amount: totalPrice, txnToken: token['txnToken'], orderID: orderId);
      // return true;
      _saveOrderLocally({
        "items": itemsAsJson,
        "time": Timestamp.now().toString(),
        "resId": restaurantId,
      });

      CollectionReference restaurantOrders = FirebaseFirestore.instance
          .collection('restaurants/$restaurantId/orders');
      // final docid =
      await restaurantOrders.add(orderJson);
      items.clear();
      notifyListeners();
      return true;
    } on Exception {
      return false;
    }
  }

  void _saveOrderLocally(obj) {
    final existing = jsonDecode(prefs.getString("orders") ?? "{}");
    final list = existing['orders'] ?? [];
    list.add(obj);
    prefs.setString("orders", jsonEncode({"orders": list}));
  }
}

/// This kind of extends a [MenuItem], with quantity.
class CartItem {
  CartItem(this.menuItem, {this.quantity = 1});
  final MenuItem menuItem;
  int quantity; // = 1;
  int get cost => quantity * menuItem.price;
  Map<String, dynamic> toJSON() {
    return {
      "itemId": menuItem.id,
      "quantity": quantity,
    };
  }
}

Future<bool> internetIsAvailable() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return Future.value(true);
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}

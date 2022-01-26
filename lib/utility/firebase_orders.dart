import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/models/menu_item.dart';
import 'package:fooddeli/res_owner/models/order.dart';
import 'package:http/http.dart' as http;

FirebaseFirestore _firestore = FirebaseFirestore.instance;
const serverBaseURL = "https://food-deli.herokuapp.com";

/// Adds or updates outlet, depending on resId
Future<void> addOutlet(
    {required String uid,
    required String outletName,
    required TimeOfDay fromTime,
    required TimeOfDay toTime,
    String? resId}) async {
  if (resId != null) {
    _updateOutlet(
        outletName: outletName,
        fromTime: fromTime,
        toTime: toTime,
        resId: resId);
    return;
  }
  final collection = _firestore.collection("restaurants");
  DocumentReference resRef = await collection.add({
    "name": outletName,
    "fromTime": fromTime.toTimestamp(),
    "toTime": toTime.toTimestamp(),
  });
  String id = resRef.id;
  resRef = _firestore.collection("users").doc(uid);
  await resRef.set({"resId": id});
}

void _updateOutlet({
  required String outletName,
  required TimeOfDay fromTime,
  required TimeOfDay toTime,
  required String resId,
}) {
  final collection = _firestore.collection("restaurants");
  collection.doc(resId).set({
    "name": outletName,
    "fromTime": fromTime.toTimestamp(),
    "toTime": toTime.toTimestamp(),
  });
}

void addEmptyOutlet(String uid) {
  addOutlet(
      uid: uid,
      outletName: "",
      fromTime: TimeOfDay.now(),
      toTime: TimeOfDay.now(),
      resId: "test");
}

Future<void> addItem(MenuItem menuItem) async {
  CollectionReference col = _firestore.collection("restaurants");
  final doc = await col.doc(menuItem.restaurantId).get();
  final List<dynamic> list =
      (doc.data()! as Map<String, dynamic>)['categories'] ?? [];

  if (!list.contains(menuItem.category)) {
    await col.doc(menuItem.restaurantId).update({
      "categories": FieldValue.arrayUnion([menuItem.category])
    });
  }
  col = FirebaseFirestore.instance
      .collection("restaurants/${menuItem.restaurantId}/items");
  await col.add(menuItem.toJSON());
}

/// Deletes or marks an item as unavailable.
///
/// Set [delete] to `true` if item is to deleted
/// Set [delete] to `false` to mark it unavailable
Future<void> removeItem(
    {required MenuItem menuItem, required bool delete}) async {
  final doc = FirebaseFirestore.instance
      .collection("restaurants/${menuItem.restaurantId}/items")
      .doc(menuItem.id);
  if (delete) {
    await doc.delete();
  } else {
    await doc.update({'isAvailable': false});
  }
}

Future<void> restoreItem(MenuItem menuItem) async {
  final doc = FirebaseFirestore.instance
      .collection("restaurants/${menuItem.restaurantId}/items")
      .doc(menuItem.id);

  await doc.update({'isAvailable': true});
}

Future<void> closeOrder(String resId, Order order) async {
  // print(order.resName);
  await http.post(
    Uri.parse('$serverBaseURL/dispatch'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'resId': resId,
      "orderId": order.id ?? "order",
      "registrationToken": order.userFCM,
      "restaurantName": order.resName ?? "Food", // is on the way! message
    }),
  );
}

void deleteLocalOrders() {
  prefs.remove("orders");
}

extension Datestamp on TimeOfDay {
  Timestamp toTimestamp() {
    final now = DateTime.now();
    return Timestamp.fromDate(DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ));
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/res_owner/models/order.dart';
import 'package:fooddeli/res_owner/widgets/order_card.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersJson = prefs.getString("orders");
    final orders =
        jsonDecode(ordersJson ?? '{"orders": []}') as Map<String, dynamic>;
    List<dynamic> list = orders["orders"];
    print(list[0]['items']);
    list = list.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your orders"),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) {
          return OrderCard(
            Order(
              items: list[i]['items'],
              room: "room",
              time: Timestamp.now(),
              userFCM: "a",
            ),
            forUser: true,
            resId: list[i]["resId"],
          );
        },
      ),
    );
  }
}

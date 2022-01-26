import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/menu_items_page/widgets/item.dart';
import 'package:fooddeli/models/menu_item.dart';
import 'package:fooddeli/res_owner/widgets/order_card.dart';
import 'package:collection/collection.dart';

class ResItemsPage extends StatelessWidget {
  const ResItemsPage(this.resId, {Key? key}) : super(key: key);
  final String resId;
  @override
  Widget build(BuildContext context) {
    ItemCard.animate = true;
    ItemCard.delay = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("restaurants/$resId/items")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const PlaceholderCards();
            }
            return ListView(
              children: snapshot.data!.docs
                  .mapIndexed((int i, DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                data['restaurantId'] = resId;
                return ItemCard(
                  MenuItem.fromJSON(data, document.id),
                  forRes: true,
                  indexInList: i,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/auth/create_account.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/res_owner/models/order.dart';
import 'package:fooddeli/res_owner/widgets/order_card.dart';
import "package:provider/provider.dart";

class ResOrderList extends StatelessWidget {
  const ResOrderList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resOwner = context.read<LoginManager>().resOwner;
    // String? id = FirebaseAuth.instance.currentUser?.uid;
    if (resOwner == null) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Restaurant not found"),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateAccountPage(),
                  ),
                );
              },
              child: const Text("Set up account"),
            ),
          ],
        ),
      );
    }

    // if (resOwner == null) {
    //   if (id == null) {
    //     return const PlaceholderCards();
    //   }
    // }
    // if (id == null) {
    //   if (resOwner != null) {
    //     id = resOwner.resId;
    //   } else {
    //     return const PlaceholderCards();
    //   }
    // }
    // // id = id ?? resOwner.resId;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("restaurants/${resOwner.resId}/orders")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PlaceholderCards();
        }
        List<Order> orders = snapshot.data!.docs.map((document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return Order.fromJSON(data, document.id);
        }).toList();

        if (orders.isEmpty) {
          return const Center(
              child: Text(
                  "No orders yet.\nClick the + icon on the bottom to add items"));
        }

        orders.sort((a, b) => b.time.compareTo(a.time));

        return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, i) =>
                OrderCard(orders[i], resId: resOwner.resId));
      },
    );
  }
}

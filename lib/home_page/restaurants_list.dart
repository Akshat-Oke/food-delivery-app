import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/home_page/restaurant_card.dart';
import 'package:fooddeli/models/restaurant_model.dart';
import 'package:fooddeli/res_owner/widgets/order_card.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({Key? key}) : super(key: key);

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  final Stream<QuerySnapshot> _restaurantStream =
      FirebaseFirestore.instance.collection("restaurants").snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _restaurantStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        List<Widget> list = [];

        if (snapshot.hasError) {
          return SliverToBoxAdapter(child: const Text("error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return SliverToBoxAdapter(child: const Text("loading"));
          return const SliverToBoxAdapter(
            child: SizedBox(height: 500, child: PlaceholderCards()),
          );
        }

        list = snapshot.data?.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              data["id"] = document.id;
              return RestaurantCard(
                restaurantModel: RestaurantModel.fromJSON(data),
              );
            }).toList() ??
            [];
        return SliverList(delegate: SliverChildListDelegate(list));
      },
    );
  }
}

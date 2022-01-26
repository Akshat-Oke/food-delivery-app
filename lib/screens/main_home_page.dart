// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, prefer_const_constructors

import "package:flutter/material.dart";
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fooddeli/home_page/app_bar.dart';
import 'package:fooddeli/home_page/restaurant_card.dart';
import 'package:fooddeli/home_page/restaurants_list.dart';
import 'package:fooddeli/models/restaurant_model.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 5),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Text(
                    "Outlets",
                    style: const TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            RestaurantList(),
          ],
        ),
      ),
    );
  }
}

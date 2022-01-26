import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fooddeli/models/login_manager.dart';
import "package:provider/provider.dart";

import 'add_item_page.dart';
import 'widgets/order_list.dart';

class ResMainHome extends StatelessWidget {
  const ResMainHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<LoginManager>().resOwner == null) {
      context.read<LoginManager>().checkFirebase(null);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            ZoomDrawer.of(context)?.open();
          },
        ),
        title: Text(context.watch<LoginManager>().resOwner?.name ?? "Orders"),
      ),
      floatingActionButton: context.watch<LoginManager>().resOwner == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddItemPage(
                            context.read<LoginManager>().resOwner)));
              },
              child: const Icon(Icons.add),
            ),
      body: const ResOrderList(),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fooddeli/models/login_manager.dart';
import "package:provider/provider.dart";

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 17.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: Theme.of(context).colorScheme.primary,
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x66000000),
              )
            ]),
        child: Text(
          "Room: ${context.watch<LoginManager>().user?.room}",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      foregroundColor: Colors.black87,
      leading: IconButton(
        icon: const Icon(
          Icons.sort,
          size: 30,
        ),
        onPressed: () {
          ZoomDrawer.of(context)!.toggle();
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

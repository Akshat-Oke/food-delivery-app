import "package:flutter/material.dart";
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fooddeli/screens/main_home_page.dart';
import 'package:fooddeli/screens/menu_page.dart';

/// Main home screen for students
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: const MenuPage(),
      mainScreen: const MainHomePage(),
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      style: DrawerStyle.Style1,
      backgroundColor: Colors.grey[300]!,
      slideWidth: MediaQuery.of(context).size.width * (0.65),
    );
  }
}

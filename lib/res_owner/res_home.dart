import "package:flutter/material.dart";
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fooddeli/res_owner/res_side_menu.dart';

import 'res_main_home.dart';

class ResHome extends StatelessWidget {
  const ResHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ZoomDrawer(
      style: DrawerStyle.Style1,
      menuScreen: ResSideMenu(),
      mainScreen: ResMainHome(),
    );
  }
}

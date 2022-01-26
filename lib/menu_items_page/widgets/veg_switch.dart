import "package:flutter/material.dart";
import 'package:fooddeli/models/menu_items_provider.dart';
import 'package:provider/provider.dart';

class VegSwitch extends StatefulWidget {
  const VegSwitch({Key? key}) : super(key: key);

  @override
  State<VegSwitch> createState() => _VegSwitchState();
}

class _VegSwitchState extends State<VegSwitch> {
  bool onlyVeg = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 15),
        const Text("Only Veg"),
        Switch(
            value: onlyVeg,
            onChanged: (val) {
              setState(() {
                onlyVeg = val;
              });
              context.read<MenuItemsProvider>().applyOnlyVegFilter(onlyVeg);
            })
      ],
    );
  }
}

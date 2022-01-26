import "package:flutter/material.dart";
import 'package:fooddeli/menu_items_page/widgets/menu_build.dart';
import 'package:fooddeli/models/menu_items_provider.dart';
import 'package:fooddeli/models/restaurant_model.dart';
import 'package:fooddeli/screens/cart_sheet.dart';
import 'package:provider/provider.dart';

class RestaurantMenuScreen extends StatelessWidget {
  RestaurantMenuScreen({Key? key, required this.rModel})
      : menuItemsProvider = MenuItemsProvider(rModel),
        super(key: key);
  final RestaurantModel rModel;
  final MenuItemsProvider menuItemsProvider; // = MenuItemsProvider(rModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const CartBottomSheet(),
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BackButton(),
              const SizedBox(width: 10),
              Text(rModel.name,
                  style: const TextStyle(color: Colors.black87, fontSize: 32)),
            ],
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: menuItemsProvider.getMenu(),
        builder: (context, snapshot) {
          return ChangeNotifierProvider<MenuItemsProvider>.value(
            value: menuItemsProvider,
            builder: (context, child) => const MenuPageBuild(),
          );
        },
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: Colors.grey.shade300,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade600, //Colors.pink.withOpacity(0.2),
        //     spreadRadius: 4,
        //     blurRadius: 10,
        //     // offset: Offset(0, 3),
        //   )
        // ],
      ),
      child: Center(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black87,
            )),
      ),
    );
  }
}

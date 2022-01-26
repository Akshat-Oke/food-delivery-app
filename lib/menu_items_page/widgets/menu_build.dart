import 'package:flutter/material.dart';
import 'package:fooddeli/menu_items_page/widgets/filter_buttons.dart';
import 'package:fooddeli/menu_items_page/widgets/menu_list.dart';
import 'package:fooddeli/menu_items_page/widgets/veg_switch.dart';
import 'package:fooddeli/models/menu_items_provider.dart';
import 'package:provider/provider.dart';

class MenuPageBuild extends StatefulWidget {
  const MenuPageBuild({Key? key}) : super(key: key);

  @override
  State<MenuPageBuild> createState() => _MenuPageBuildState();
}

class _MenuPageBuildState extends State<MenuPageBuild> {
  MenuItemsProvider? menuitemsprovider;
  bool loaded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // menuitemsprovider = context.read<MenuItemsProvider>();
    // if (!loaded) {
    //   menuitemsprovider?.getMenu();
    //   loaded = true;
    // }
    final isLoading = context.watch<MenuItemsProvider>().isLoading;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : const CustomScrollView(
            slivers: [
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 16.0, top: 3, bottom: 8),
              //     child: Text(
              //       "Categories",
              //       style: TextStyle(
              //         fontSize: 22,
              //         fontWeight: FontWeight.w300,
              //       ),
              //     ),
              //   ),
              // ),
              FilterButtons(),
              SliverToBoxAdapter(
                child: VegSwitch(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16, bottom: 18),
                  child: Text(
                    "Items",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              MenuList(),
              SliverToBoxAdapter(
                child: SizedBox(height: 50),
              ),
            ],
          );
  }
}

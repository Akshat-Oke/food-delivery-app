import "package:flutter/material.dart";
import 'package:fooddeli/models/menu_items_provider.dart';
import "package:provider/provider.dart";
import 'package:collection/collection.dart';

import 'item.dart';

class MenuList extends StatelessWidget {
  const MenuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemList = context
        .watch<MenuItemsProvider>()
        .filteredMenu
        .mapIndexed((i, item) => ItemCard(
              item,
              indexInList: i,
            ))
        .toList();
    return SliverList(
      delegate: SliverChildListDelegate(itemList
          //itemList.map((item) => ItemCard(item)).toList(),
          ),
    );
  }
}

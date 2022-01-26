import "package:flutter/material.dart";
import 'package:fooddeli/menu_items_page/widgets/item.dart';
import 'package:fooddeli/models/cart_provider.dart';
import "package:provider/provider.dart";

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = context.watch<CartProvider>().items;
    if (items.isEmpty) {
      return const Text("Nothing in your cart");
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ItemCard(
        items[index].menuItem,
        indexInList: 0,
      ),
    );
  }
}

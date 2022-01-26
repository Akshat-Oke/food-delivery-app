import "package:flutter/material.dart";
import 'package:fooddeli/models/cart_provider.dart';
import 'package:provider/provider.dart';

import 'cart_item_list.dart';
import 'order_button.dart';

class CartViewScreen extends StatelessWidget {
  const CartViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int itemCount = context.watch<CartProvider>().items.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: Column(
        children: const [
          SizedBox(height: 25),
          Expanded(child: CartList()),
          OrderButton(),
        ],
      ),
    );
  }
}

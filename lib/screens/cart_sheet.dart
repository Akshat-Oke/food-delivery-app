import 'package:animated_widgets/animated_widgets.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/cart/cart_screen.dart';
import 'package:fooddeli/models/cart_provider.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartLength = context.watch<CartProvider>().items.length;
    final totalPrice = context.watch<CartProvider>().totalPrice;
    // if (cartLength == 0) {
    //   return const SizedBox();
    // }
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white, fontSize: 15),
      child: TranslationAnimatedWidget(
        enabled: cartLength != 0,
        duration: const Duration(milliseconds: 120),
        values: const [
          Offset(0, 50),
          Offset(0, 0),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$cartLength items | ₹$totalPrice"),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => CartViewScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.local_dining_outlined,
                        color: Colors.white70),
                    label: const Text("View Cart",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

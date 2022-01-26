import "package:flutter/material.dart";
import 'package:fooddeli/models/cart_provider.dart';
import 'package:fooddeli/screens/orders_page.dart';
import "package:provider/provider.dart";
import "package:fooddeli/utility/firebase_orders.dart";

class OrderButton extends StatelessWidget {
  const OrderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasItemsInCart = context.watch<CartProvider>().items.isNotEmpty;
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white, fontSize: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primary,
          gradient: const LinearGradient(
            stops: [
              0.20,
              0.65,
              0.85,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf46d34),
              Color(0xFFf79743),
              Color(0xFFf5b342),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!hasItemsInCart)
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Add an item!"),
              ),
            if (hasItemsInCart)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9.0, vertical: 9),
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  child: Row(
                    children: [
                      const Text("Total"),
                      const Spacer(),
                      Text("₹ ${context.watch<CartProvider>().totalPrice}")
                    ],
                  ),
                ),
              ),
            if (hasItemsInCart)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 14)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  onPressed: () async {
                    await context.read<CartProvider>().placeOrder();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const OrdersPage()));
                  },
                  child: Text(
                    "Place Order",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

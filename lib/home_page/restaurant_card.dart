import "package:flutter/material.dart";
import 'package:fooddeli/menu_items_page/menu_items_screen.dart';
import 'package:fooddeli/menu_items_page/widgets/item.dart';
import 'package:fooddeli/models/cart_provider.dart';
import 'package:fooddeli/models/restaurant_model.dart';
import 'package:provider/provider.dart';

class RestaurantCard extends StatelessWidget {
  static String? currentCartRes;
  const RestaurantCard({Key? key, required this.restaurantModel})
      : super(key: key);
  final RestaurantModel restaurantModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          enabled: restaurantModel.isOpen,
          contentPadding: const EdgeInsets.only(left: 14, top: 8),
          onTap: () {
            final currentResId = context.read<CartProvider>().restaurantId;
            final oldCartRes = currentCartRes;
            currentCartRes = restaurantModel.name;

            if (currentResId.isNotEmpty &&
                currentResId != restaurantModel.docId) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline6,
                        text: oldCartRes == null || oldCartRes == currentCartRes
                            ? "Warning"
                            : "Your cart is from ",
                        children: [
                          if (oldCartRes != null)
                            TextSpan(
                              text: oldCartRes,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                        ]),
                  ),
                  content: Text(oldCartRes == null
                      ? "Viewing this menu will clear your current cart. Continue?"
                      : "You'll have to pick up a new cart and leave the old one behind. Continue?"),
                  actions: [
                    TextButton(
                      child: const Text("Continue"),
                      onPressed: () {
                        ItemCard.animate = true;
                        ItemCard.delay = 0;
                        Navigator.pop(context);
                        Provider.of<CartProvider>(context, listen: false)
                            .setRestaurant(restaurantModel.docId);
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                RestaurantMenuScreen(rModel: restaurantModel),
                          ),
                        );
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          currentCartRes = oldCartRes;
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"))
                  ],
                ),
              );
            } else {
              context.read<CartProvider>().setRestaurant(restaurantModel.docId);
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      RestaurantMenuScreen(rModel: restaurantModel),
                ),
              );
            }
          },
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(restaurantModel.name,
                style: const TextStyle(fontSize: 22)),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (!restaurantModel.isOpen)
                Text("Closed",
                    style: TextStyle(
                      color: Colors.red.withAlpha(150),
                      fontStyle: FontStyle.italic,
                    )),
              if (restaurantModel.isOpen)
                const Text("Open",
                    style: TextStyle(
                      color: Colors.green, //.withAlpha(50),
                      fontStyle: FontStyle.italic,
                    )),
              const SizedBox(width: 8),
              Text(restaurantModel.times(context)),
              // if (!restaurantModel.isOpen)
              //   Container(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8),
              //       color: Colors.red,
              //     ),
              //     child: const Text("Closed",
              //         style: TextStyle(
              //           fontSize: 16,
              //           color: Colors.white,
              //         )),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

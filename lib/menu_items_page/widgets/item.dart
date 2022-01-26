import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fooddeli/menu_items_page/widgets/quantity_button.dart';
import 'package:fooddeli/models/cart_provider.dart';
import 'package:fooddeli/models/menu_item.dart';
import 'package:fooddeli/utility/firebase_orders.dart';
import 'package:fooddeli/utility/theme_data.dart';
import "package:provider/provider.dart";

class ItemCard extends StatelessWidget {
  static int delay = 0;
  static bool animate = true;
  const ItemCard(this.menuItem,
      {Key? key, this.forRes = false, this.indexInList})
      : super(key: key);
  final bool forRes;
  final int? indexInList;
  final MenuItem menuItem;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: menuItem,
      child: TranslationAnimatedWidget(
        duration: const Duration(milliseconds: 150),
        delay: Duration(milliseconds: 100 + ((indexInList ?? delay) * 80)),
        enabled: true,
        values: animate
            ? const [Offset(-50, 0), Offset(0, 0)]
            : const [Offset(0, 0), Offset(0, 0)],
        child: OpacityAnimatedWidget(
          values: animate ? const [0, 1] : const [1.0, 1.0],
          duration: const Duration(milliseconds: 250),
          delay: Duration(milliseconds: 100 + ((indexInList ?? delay++) * 80)),
          enabled: true,
          child: Container(
            margin:
                const EdgeInsets.only(left: 10, right: 15, top: 9, bottom: 15),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.grey.shade300,
                  )
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  menuItem.isNonVeg
                      ? Icons.change_history_rounded
                      : Icons.radio_button_checked,
                  color: !menuItem.isAvailable
                      ? Colors.grey
                      : menuItem.isNonVeg
                          ? Colors.brown
                          : Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menuItem.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 5),
                    if (menuItem.category != null)
                      Text(
                        menuItem.category!,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Text(
                      "₹ ${menuItem.price}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: !menuItem.isAvailable
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (!menuItem.isAvailable)
                      TranslationAnimatedWidget(
                        enabled: true,
                        duration: const Duration(milliseconds: 150),
                        delay: Duration(
                            milliseconds: 200 + ((indexInList ?? delay) * 80)),
                        values: const [
                          Offset(-10, 0),
                          Offset(0, 0),
                        ],
                        child: OpacityAnimatedWidget(
                          delay: Duration(
                              milliseconds:
                                  200 + ((indexInList ?? delay) * 80)),
                          duration: const Duration(milliseconds: 120),
                          enabled: true,
                          child: const Text(
                            "Currently unavailable",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                if (!forRes) AddButton(menuItem),
                if (forRes && menuItem.isAvailable)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      animate = false;
                      _showDialogForDisableItem(context);
                    },
                  ),
                if (forRes && !menuItem.isAvailable)
                  IconButton(
                    icon:
                        const Icon(Icons.restore_rounded, color: Colors.green),
                    onPressed: () async {
                      animate = false;
                      restoreItem(menuItem);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialogForDisableItem(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Remove item"),
              content: const Text(
                  "You can choose to either delete the item or mark it as currently unavailable (disable for order)."),
              actions: [
                TextButton(
                  onPressed: () {
                    removeItem(menuItem: menuItem, delete: true);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete item",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    removeItem(menuItem: menuItem, delete: false);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Disable for order",
                  ),
                ),
              ],
            ));
  }
}

class AddButton extends StatefulWidget {
  const AddButton(this.menuItem, {Key? key}) : super(key: key);
  final MenuItem menuItem;
  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    if (!widget.menuItem.isAvailable) {
      return const SizedBox();
    }
    final cart = context.watch<CartProvider>();
    quantity = cart.getQuantityOf(widget.menuItem);
    if (quantity == 0) {
      return InkWell(
        onTap: () {
          setState(() {
            quantity = 1;
            cart.addToCart(widget.menuItem);
          });
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              // border: Border.all(
              //   color:
              //       Theme.of(context).colorScheme.primary.withOpacity(0.78),
              //   width: 2,
              // )
              color: Colors.grey.shade200,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 4),
                const Text("Add", style: TextStyle(fontSize: 15)),
                const SizedBox(width: 2),
                Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            )),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QuanButton(
            onTap: () {
              setState(() {
                quantity--;
                cart.decreaseQuantity(widget.menuItem);
              });
            },
            icon: Icons.remove),
        const SizedBox(width: 4),
        Text("$quantity",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade800)),
        const SizedBox(width: 4),
        QuanButton(
          onTap: () {
            setState(() {
              quantity++;
              cart.addToCart(widget.menuItem);
            });
          },
          icon: Icons.add,
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(100),
        ),
      ],
    );
  }
}

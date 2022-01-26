import "package:flutter/material.dart";
import 'package:fooddeli/models/cart_provider.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/res_owner/models/order.dart';
import 'package:fooddeli/utility/firebase_orders.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrderCard extends StatelessWidget {
  const OrderCard(this.order,
      {this.forUser = false, required this.resId, Key? key})
      : super(key: key);
  final Order order;
  final String resId;

  /// Whether this card is shown for a user (true) or res owner
  final bool forUser;
  @override
  Widget build(BuildContext context) {
    final resId = this.resId.isNotEmpty
        ? this.resId
        : context.watch<LoginManager>().resOwner?.resId;
    if (resId == null) return Text("loading");

    return FutureBuilder(
      future: order.getItemDetails(resId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        return Container(
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
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (forUser && order.resName != null)
                      Text(
                        order.resName!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    if (!forUser)
                      Text(
                        order.room,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    const SizedBox(height: 8),
                    ...order.cartItems
                        .map((cartItem) => Row(
                              children: [
                                Text(
                                  cartItem.quantity.toString(),
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  cartItem.menuItem.name,
                                  style: const TextStyle(
                                    fontSize: 21,
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                    const SizedBox(height: 6),
                    if (!forUser) Text(order.timeString(context)),
                  ],
                ),
              ),
              // const SizedBox(width: 10),
              // Column(
              //   children: order.cartItems
              //       .map((cartItem) => Text(cartItem.menuItem.name))
              //       .toList(),
              // ),
              // const Spacer(),
              if (!forUser)
                IconButton(
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 26,
                  ),
                  onPressed: () {
                    _confirmClose(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _confirmClose(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Close order?"),
        content: const Text(
            "This signifies that this order will be dispatched now."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await closeOrder(resId, order);
              Navigator.pop(context);
            },
            child: const Text("Close order"),
          )
        ],
      ),
    );
  }
}

class PlaceholderCards extends StatelessWidget {
  const PlaceholderCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 8, right: 12, bottom: 20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF444444), width: 1)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   width: 48.0,
                //   height: 48.0,
                //   color: Colors.white,
                // ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(right: 50),
                        height: 20.0,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerCardHolder extends StatelessWidget {
  const ShimmerCardHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 48.0,
          height: 48.0,
          color: Colors.white,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 8.0,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: double.infinity,
                height: 8.0,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 40.0,
                height: 8.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

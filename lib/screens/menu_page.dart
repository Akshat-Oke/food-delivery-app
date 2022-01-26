import "package:flutter/material.dart";
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/screens/orders_page.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<LoginManager>().user;
    // if(user == null)
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 250),
                Text(
                  user?.room ?? "Unknown room",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceBetween(),
                Container(
                  width: 150,
                  height: 1,
                  color: Colors.white,
                ),
                const SpaceBetween(),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const OrdersPage()));
                    },
                    child: const Text("Orders")),
                const SpaceBetween(),
                GestureDetector(
                  onTap: () {
                    context.read<LoginManager>().logoutUser();
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          ),
        )));
  }
}

class SpaceBetween extends StatelessWidget {
  const SpaceBetween({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20);
  }
}

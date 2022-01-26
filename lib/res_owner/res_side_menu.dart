import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/auth/create_account.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/res_owner/res_items.dart';
import 'package:provider/provider.dart';

class ResSideMenu extends StatelessWidget {
  const ResSideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resOwner = context.watch<LoginManager>().resOwner;
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
                  resOwner?.name ?? "Outlet owner",
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
                          builder: (_) =>
                              ResItemsPage(resOwner?.resId ?? "res")));
                    },
                    child: const Text("Your Items")),
                const SpaceBetween(),
                GestureDetector(
                  onTap: () async {
                    final name = await Navigator.of(context)
                        .push<String>(MaterialPageRoute(
                            builder: (_) => CreateAccountPage(
                                  resOwner:
                                      context.read<LoginManager>().resOwner,
                                )));
                    context.read<LoginManager>().setResName(name);
                    // context.read<LoginManager>().init();
                  },
                  child: const Text("Update details"),
                ),
                const SpaceBetween(),
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
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

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/auth/welcome_screen.dart';
import 'package:fooddeli/home_page/home.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/res_owner/res_home.dart';
import 'package:provider/provider.dart';

class AuthManager extends StatelessWidget {
  const AuthManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: SizedBox());
          }
          User? user = snapshot.data;
          if (snapshot.connectionState == ConnectionState.active) {
            return FutureBuilder(
              future: Provider.of<LoginManager>(context, listen: false)
                  .init(fireUser: user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user?.email ?? "Outlet Owner"),
                        const SizedBox(height: 10),
                        const CircularProgressIndicator(),
                      ],
                    ),
                  ));
                }
                if (user == null) {
                  if (context.watch<LoginManager>().userType ==
                      UserTypes.user) {
                    return const HomePage();
                  }
                  return const WelcomePage();
                }
                // return const AuthWrapper();
                return const ResHome();
                // if (context.watch<LoginManager>().isLoggedIn) {
                //   return const HomePage();
                // } else {
                //   return const AuthWrapper();
                // }
              },
            );
          }
          return const Scaffold(body: Text("Loading"));
        });
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        User? user = snapshot.data as User?;
        // return HomePage();
        if (user == null) {
          if (context.watch<LoginManager>().userType == UserTypes.user) {
            return const HomePage();
          } else {
            return const WelcomePage();
          }
        } else {
          context.read<LoginManager>().checkFirebase(user);
          return const ResHome();
        }
      },
    );
  }
}

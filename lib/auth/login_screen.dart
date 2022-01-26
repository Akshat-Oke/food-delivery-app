import 'dart:async';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/auth/create_account.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/utility/dialog.dart';
import 'package:fooddeli/utility/firebase_orders.dart';
import 'package:fooddeli/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(this.onCancel, {Key? key}) : super(key: key);

  final void Function() onCancel;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // bool _enabled = true;
  bool _createAccount = false;
  String email = "", password = "", outlet = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              onChanged: (value) {
                email = value;
              },
              hint: "Email",
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              hint: "Password",
              // type: TextInputT
              obscureText: true,
              onChanged: (val) {
                password = val;
              },
            ),
            if (_createAccount)
              CustomTextField(
                hint: "Outlet name",
                onChanged: (val) {
                  outlet = val;
                },
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    showInfoDialog(context, 'No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    showInfoDialog(
                        context, 'Wrong password provided for that user.');
                  }
                }
              },
              child: const Text("Log in"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // if (!_createAccount) {
                //   setState(() {
                //     _createAccount = true;
                //   });
                //   return;
                // }
                // if (outlet.isEmpty) {
                //   showInfoDialog(context, "Outlet name is required");
                //   return;
                // }
                try {
                  context.read<LoginManager>().reset();
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  if (userCredential.user == null) {
                    FirebaseAuth.instance.signOut();
                    return;
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          CreateAccountPage(uid: userCredential.user!.uid)));
                  // await addOutlet(userCredential.user!.uid, outlet);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    showInfoDialog(
                        context, 'The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    showInfoDialog(
                        context, 'The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Create account"),
            ),
            ElevatedButton(
                onPressed: () {
                  widget.onCancel();
                },
                child: const Text("Go back"))
          ],
        ),
      ),
    );
  }
}

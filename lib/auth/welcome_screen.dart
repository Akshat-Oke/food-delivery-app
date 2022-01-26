import 'dart:async';

import 'package:animated_widgets/animated_widgets.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/auth/login_screen.dart';
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/utility/dialog.dart';
import 'package:fooddeli/utility/ocr.dart';
import 'package:fooddeli/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool asOwner = false;
  bool welcome = true;

  /// ID frmo scanned ID card
  String? id;
  final roomController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Pattern.jpg"),
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          TranslationAnimatedWidget(
            duration: const Duration(milliseconds: 200),
            values: const [
              Offset(500, 0),
              Offset(0, 0),
            ],
            enabled: !welcome,
            child: LoginPage(() {
              setState(() {
                welcome = !welcome;
              });
            }),
          ),
          Center(
              child: TranslationAnimatedWidget(
            enabled: welcome,
            duration: const Duration(milliseconds: 200),
            values: const [
              Offset(-500, 0),
              Offset(0, 0),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OpacityAnimatedWidget(
                  values: const [1.0, 0.0],
                  enabled: false,
                  duration: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: 300,
                    child: CustomTextField(
                      hint: "Room, Ex. VK 112",
                      controller: roomController,
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text("Continue as User"),
                  onPressed: () {
                    if (id == null) {
                      showInfoDialog(context, "Scan ID first!");
                      return;
                    }
                    if (roomController.text.isEmpty) {
                      showInfoDialog(context, "Room number is required.");
                    } else {
                      final room = roomController.text;
                      if (RegExp(r".+ \d{2,}").hasMatch(room)) {
                        Provider.of<LoginManager>(context, listen: false)
                            .loginUser(room: roomController.text);
                      } else {
                        showInfoDialog(context, "Invalid room number");
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      welcome = false;
                    });
                    Timer(const Duration(milliseconds: 200), () {
                      setState(() {
                        asOwner = true;
                      });
                    });
                  },
                  child: const Text("Continue as owner"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    String? id = await OCR.startOcr();
                    if (id != null) {
                      setState(() {
                        this.id = id;
                      });
                    } else {
                      showInfoDialog(context, "Could not scan ID");
                    }
                  },
                  child: const Text("Scan ID card"),
                ),
                const SizedBox(height: 15),
                if (id != null)
                  TranslationAnimatedWidget(
                    enabled: true,
                    values: const [
                      Offset(0, -50),
                      Offset(0, 0),
                    ],
                    duration: const Duration(milliseconds: 150),
                    child: Text(id!),
                  ),
              ],
            ),
          )),
          // if (!asOwner)
          //   Align(
          //     alignment: Alignment.topCenter,
          //     child: Container(
          //       // constraints: const BoxConstraints.expand(),
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           begin: FractionalOffset.topCenter,
          //           end: FractionalOffset.bottomCenter,
          //           stops: const [0.5, 1.0],
          //           colors: [
          //             Colors.white.withOpacity(0),
          //             Colors.white.withOpacity(0.87),
          //           ],
          //         ),
          //       ),
          //       height: 350,
          //     ),
          //   ),
        ],
      ),
    );
  }
}

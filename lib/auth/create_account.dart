import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/utility/dialog.dart';
import 'package:fooddeli/utility/firebase_orders.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key, this.uid, this.resOwner})
      : super(key: key);
  final String? uid;
  final ResOwner? resOwner;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController nameController = TextEditingController();

  TimeOfDay? fromTime;

  TimeOfDay? toTime;
  bool isLoading = false;
  late final String uid;
  @override
  void initState() {
    if (widget.uid == null) {
      uid = FirebaseAuth.instance.currentUser!.uid;
    } else {
      uid = widget.uid!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (nameController.text.isEmpty) {
      nameController.text = widget.resOwner?.name ?? "";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.resOwner == null ? "Register outlet" : "Update details"),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("Outlet Name"),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  enabled: !isLoading,
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Outlet name",
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      fromTime = await showTimePicker(
                          context: context,
                          initialTime: fromTime ?? TimeOfDay.now());
                      setState(() {});
                    },
                    child: Text(fromTime == null
                        ? "From Time"
                        : "${fromTime?.hour}:${fromTime?.minute}"),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: () async {
                      toTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      setState(() {});
                    },
                    child: Text(toTime == null
                        ? "To Time"
                        : "${toTime?.hour}:${toTime?.minute}"),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    if (isLoading) {
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    if (fromTime == null || toTime == null) {
                      showInfoDialog(context, "Times are required");
                      setState(() {
                        isLoading = false;
                      });
                      return;
                    }
                    await addOutlet(
                        uid: uid,
                        outletName: nameController.text,
                        fromTime: fromTime!,
                        toTime: toTime!,
                        resId: widget.resOwner?.resId);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(isLoading ? "Loading..." : "Update account")),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  const CustomFormField({Key? key, this.controller}) : super(key: key);
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}

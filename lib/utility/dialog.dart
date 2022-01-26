import 'package:flutter/material.dart';

void showInfoDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(message),
    ),
  );
}

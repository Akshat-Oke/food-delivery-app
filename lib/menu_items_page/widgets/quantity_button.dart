import 'package:flutter/material.dart';

class QuanButton extends StatelessWidget {
  const QuanButton(
      {required this.onTap, required this.icon, this.backgroundColor, Key? key})
      : super(key: key);
  final IconData icon;
  final Color? backgroundColor;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: backgroundColor ?? Colors.grey.shade100,
        ),
        child: Icon(icon, size: 15),
      ),
    );
  }
}

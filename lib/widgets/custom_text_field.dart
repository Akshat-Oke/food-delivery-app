import "package:flutter/material.dart";

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.type,
    required this.hint,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);
  final bool obscureText;
  final TextInputType? type;
  final String hint;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 30,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: TextField(
          obscureText: obscureText,
          keyboardType: type,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 22, horizontal: 15),
          ),
        ),
      ),
    );
  }
}

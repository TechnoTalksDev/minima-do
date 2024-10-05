import 'package:flutter/material.dart';

class MinimaField extends StatelessWidget {
  const MinimaField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller
  });

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: hintText
      ),
      obscureText: obscureText,
    );
  }
}
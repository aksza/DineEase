import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.shortestSide < 600;

    return Container(
      width: isPhone ? null : MediaQuery.of(context).size.width * 0.3,
      constraints: const BoxConstraints(
        maxHeight: 50, 
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          labelText: hintText,
          labelStyle: TextStyle(
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }

}
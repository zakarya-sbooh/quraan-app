// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quraanapp/constants/color.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
    this.controller,
    required this.validator,
  });

  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final Function(String)? onChanged;
  final FormFieldValidator<String> validator;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            labelText: labelText,
            errorStyle: TextStyle(
              color: green,
            ),
            labelStyle: TextStyle(
              color: green,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: green,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: green, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quraanapp/constants/color.dart';

void snackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    action: SnackBarAction(
      label: '',
      textColor: green,
      onPressed: () {},
    ),
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ));
}

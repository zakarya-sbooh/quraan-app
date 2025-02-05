import 'package:flutter/material.dart';
import 'package:quraanapp/constants/color.dart';

// ignore: must_be_immutable
class CustomBottun extends StatelessWidget {
  CustomBottun({this.onPressed, required this.text, super.key});
  String text;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 390,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.visible,
            softWrap: false,
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

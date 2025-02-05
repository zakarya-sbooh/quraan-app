import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomIconBottun extends StatelessWidget {
  CustomIconBottun({super.key, required this.image, this.onPressed});
  String image;

  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: IconButton(
          icon: Image.asset(
            image,
            width: 90,
            height: 40,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quraanapp/constants/color.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: offWhite,
          ),
        ),
        Positioned(
          top: -200,
          left: 270,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              border: Border.all(
                color: green,
                width: 2,
              ),
            ),
          ),
        ),
        Positioned(
          top: -180,
          left: 290,
          child: Transform.rotate(
            angle: 0.5,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: green,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 655,
          left: -200,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              border: Border.all(
                color: green,
                width: 2,
              ),
            ),
          ),
        ),
        Positioned(
          top: 680,
          left: -200,
          child: Transform.rotate(
            angle: 0.5,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: green,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quraanapp/constants/color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static String id = "SplashScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: lightGreen,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/quran.png',
                  height: 200,
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 20),
                CircularProgressIndicator(
                  color: green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

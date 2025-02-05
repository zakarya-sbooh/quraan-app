// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:quraanapp/components/background.dart';
import 'package:quraanapp/constants/color.dart';
import 'package:quraanapp/screens/signin_view.dart';
import 'package:quraanapp/screens/signup_view.dart';

class WelcomeView extends StatelessWidget {
  static String id = "WelcomeView";

  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -0.5),
                      child: Image.asset(
                        'assets/images/quran.png',
                        height: 200,
                      ),
                    ),
                  ),
                  Text(
                    "تعلم قراءة القران الكريم",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 130),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignInView.id);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor: green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: SizedBox(
                          height: 22,
                          width: 90,
                          child: Center(
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpView.id);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          side: BorderSide.none,
                        ),
                        child: SizedBox(
                          height: 22,
                          width: 90,
                          child: Center(
                            child: Text(
                              "اٍنشاء حساب",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

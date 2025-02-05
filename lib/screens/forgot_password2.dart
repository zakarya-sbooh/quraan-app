import 'package:flutter/material.dart';
import 'package:quraanapp/components/background.dart';
import 'package:quraanapp/components/custom_bottun_forgot_password.dart';
import 'package:quraanapp/constants/color.dart';

class ForgotPassword2 extends StatelessWidget {
  const ForgotPassword2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ListView(
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "تحقق من بريدك الإلكتروني",
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 100),
                  Text(
                    "تم إرسال تعليمات إعادة تعيين كلمة المرور إلى بريدك الإلكتروني",
                    style: TextStyle(
                      fontSize: 18,
                      color: black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  CustomBottunForgotPassword(
                    text: "العودة إلى تسجيل الدخول",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
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

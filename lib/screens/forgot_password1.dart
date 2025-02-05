// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quraanapp/components/background.dart';
import 'package:quraanapp/components/costum_text_form_field.dart';
import 'package:quraanapp/components/custom_bottun_forgot_password.dart';
import 'package:quraanapp/constants/color.dart';
import 'package:quraanapp/helpers/all_validation.dart';
import 'package:quraanapp/helpers/show_snack_bar.dart';
import 'package:quraanapp/screens/forgot_password2.dart';

class ForgotPassword1 extends StatefulWidget {
  const ForgotPassword1({super.key});

  @override
  State<ForgotPassword1> createState() => _ForgotPassword1State();
}

class _ForgotPassword1State extends State<ForgotPassword1> {
  String? email;
  bool isLoading = false;
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();

  Future<void> sendResetEmail() async {
    if (email == null || email!.isEmpty) {
      snackBarMessage(context, "الرجاء إدخال البريد الإلكتروني");
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      snackBarMessage(context, "تم إرسال رابط إعادة تعيين كلمة المرور");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ForgotPassword2()));
    } catch (e) {
      snackBarMessage(
          context, "حدث خطأ أثناء إرسال رابط إعادة تعيين كلمة المرور");
    }

    setState(() => isLoading = false);
  }

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
              child: Form(
                key: forgotPasswordFormKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      "إعادة تعيين كلمة المرور",
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 100),
                    CustomTextFormField(
                      labelText: "البريد الإلكتروني",
                      onChanged: (value) => email = value,
                      validator: (value) {
                        return emailValidation(value);
                      },
                    ),
                    const SizedBox(height: 14),
                    CustomBottunForgotPassword(
                        text: isLoading
                            ? "جاري الإرسال"
                            : "إرسال رابط إعادة التعيين",
                        onPressed: () {
                          if (forgotPasswordFormKey.currentState!.validate()) {
                            sendResetEmail();
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

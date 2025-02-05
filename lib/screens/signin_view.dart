// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quraanapp/components/background.dart';
import 'package:quraanapp/components/bottom_nav_bar.dart';
import 'package:quraanapp/components/costum_text_form_field.dart';
import 'package:quraanapp/components/custom_bottun.dart';
import 'package:quraanapp/components/custom_icon_bottun.dart';
import 'package:quraanapp/constants/color.dart';
import 'package:quraanapp/helpers/all_validation.dart';
import 'package:quraanapp/helpers/show_snack_bar.dart';
import 'package:quraanapp/screens/forgot_password1.dart';
import 'package:quraanapp/screens/signup_view.dart';
import 'package:quraanapp/services/firebase_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});
  static String id = "SignInView";
  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        color: green,
      ),
      color: green,
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Stack(
          children: [
            const Background(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: loginFormKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 80),
                      CustomTextFormField(
                        validator: (data) {
                          return emailValidation(data);
                        },
                        onChanged: (data) {
                          email = data;
                        },
                        labelText: "البريد الإلكتروني",
                        obscureText: false,
                      ),
                      const SizedBox(height: 22),
                      CustomTextFormField(
                        validator: (data) {
                          return passwordValidation(data);
                        },
                        onChanged: (data) {
                          password = data;
                        },
                        labelText: "كلمة المرور",
                        obscureText: !isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: green,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword1()),
                            );
                          },
                          child: Text(
                            "نسيت كلمة المرور؟",
                            style: TextStyle(
                              color: green,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomBottun(
                        text: "تسجيل الدخول",
                        onPressed: () async {
                          if (loginFormKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            try {
                              await loginUser();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', true);
                              Navigator.pushNamed(
                                  context, BottomNavigatorBar.id);
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == 'invalid-credential') {
                                snackBarMessage(context,
                                    "البريد الإلكتروني أو كلمة المرور غير صحيحة");
                              } else {
                                snackBarMessage(context,
                                    "خطأ في المصادقة" + '${ex.message}');
                              }
                            } catch (ex) {
                              snackBarMessage(
                                  context, "حدث خطأ. حاول مرة أخرى");
                            }
                            isLoading = false;
                            setState(() {});
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpView.id);
                        },
                        child: Text(
                          "إنشاء حساب جديد",
                          style: TextStyle(
                            color: black,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 35),
                      Text(
                        "أو أكمل باستخدام",
                        style: TextStyle(color: green),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconBottun(
                              image: 'assets/images/google.png',
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  final User? user = await signInWithGoogle();

                                  if (user == null) {
                                    snackBarMessage(context, "فشل المصادقة");
                                    return;
                                  }

                                  final userExists =
                                      await checkIfUserExists(user.email!);
                                  if (!userExists) {
                                    snackBarMessage(
                                        context, "المستخدم غير موجود");
                                    return;
                                  }

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isLoggedIn', true);

                                  Navigator.pushNamed(
                                      context, BottomNavigatorBar.id);
                                } catch (e) {
                                  print('Error during Google Sign-In: $e');
                                  snackBarMessage(context, "فشل تسجيل الدخول");
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

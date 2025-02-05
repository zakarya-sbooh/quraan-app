// ignore_for_file: must_be_immutable, use_build_context_synchronously, unused_local_variable, unused_catch_clause

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:quraanapp/services/firebase_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpView extends StatefulWidget {
  static String id = "SignUpView";

  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                  key: registerFormKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        "اٍنشاء حساب لأول مرة",
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      CustomTextFormField(
                        validator: (data) {
                          return emailValidation(data);
                        },
                        onChanged: (data) {
                          email = data;
                        },
                        labelText: "البريد الألكتروني",
                      ),
                      const SizedBox(height: 22),
                      CustomTextFormField(
                        validator: (data) {
                          return passwordValidation(data);
                        },
                        onChanged: (data) {
                          password = data;
                        },
                        labelText: "كلمة السر",
                        obscureText: !isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: black,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                      CustomTextFormField(
                        onChanged: (data) {
                          confirmPassword = data;
                        },
                        validator: (data) {
                          return confirmPasswordValidation(
                              password, confirmPassword);
                        },
                        labelText: "تأكيد كلمة السر",
                        obscureText: !isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: black,
                          ),
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomBottun(
                        text: "التسجيل",
                        onPressed: () async {
                          if (registerFormKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});

                            try {
                              UserCredential userCredential =
                                  await regisretUser();
                              User? user = userCredential.user;

                              if (user != null) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.email)
                                    .set({
                                  'uid': user.uid,
                                  'email': user.email,
                                  'name': user.displayName ?? '',
                                  'createdAt': Timestamp.now(),
                                });

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('isLoggedIn', true);
                                Navigator.pushNamed(
                                    context, BottomNavigatorBar.id);
                              }
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == 'weak-password') {
                                snackBarMessage(context, "كلمة السر ضعيفة");
                              } else if (ex.code == 'email-already-in-use') {
                                snackBarMessage(context, "الحساب موجود بالفعل");
                              } else {
                                snackBarMessage(
                                  context,
                                  "يوجد خطأ في عملية المصادقة ${ex.message}",
                                );
                              }
                            } catch (ex) {
                              snackBarMessage(
                                  context, "فشل التسجيل حاول مرة اخرى");
                            } finally {
                              isLoading = false;
                              setState(() {});
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "هل لديك حساب بالفعل",
                          style: TextStyle(
                            color: black,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "أو يمكنك الأستمرار عن طريق",
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
                              isLoading = true;
                              setState(() {});

                              try {
                                final User? user = await signInWithGoogle();

                                if (user == null) {
                                  snackBarMessage(context, "فشل التسجيل");
                                  isLoading = false;
                                  setState(() {});
                                  return;
                                }

                                final userExists =
                                    await checkIfUserExists(user.email!);
                                if (userExists) {
                                  snackBarMessage(
                                      context, "الحساب موجود بالفعل");
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isLoggedIn', true);

                                  Navigator.pushNamed(
                                      context, BottomNavigatorBar.id);
                                  isLoading = false;
                                  setState(() {});
                                  return;
                                }

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.email)
                                    .set({
                                  'uid': user.uid,
                                  'email': user.email,
                                  'name': user.displayName ?? '',
                                  'createdAt': Timestamp.now(),
                                });

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('isLoggedIn', true);

                                Navigator.pushNamed(
                                    context, BottomNavigatorBar.id);
                              } catch (e) {
                                print('خطأ أثناء التسجيل باستخدام Google: $e');
                                snackBarMessage(context, "فشل التسجيل");
                              }

                              isLoading = false;
                              setState(() {});
                            },
                          ),
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

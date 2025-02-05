//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quraanapp/components/bottom_nav_bar.dart';
import 'package:quraanapp/components/splash_screen.dart';
import 'package:quraanapp/screens/home_view.dart';
import 'package:quraanapp/screens/signin_view.dart';
import 'package:quraanapp/screens/signup_view.dart';
import 'package:quraanapp/screens/welcome_view.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    SignInView.id: (context) => const SignInView(),
    SignUpView.id: (context) => const SignUpView(),
    WelcomeView.id: (context) => const WelcomeView(),
    HomeView.id: (context) => const HomeView(),
    SplashScreen.id: (context) => const SplashScreen(),
    BottomNavigatorBar.id: (context) => const BottomNavigatorBar(),
  };
}

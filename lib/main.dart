import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quraanapp/components/bottom_nav_bar.dart';
import 'package:quraanapp/components/splash_screen.dart';
import 'package:quraanapp/firebase_options.dart';
import 'package:quraanapp/helpers/app_routes.dart';
import 'package:quraanapp/screens/welcome_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();

  final isLoggedIn = await getLoginState();
  runApp(
    QuraanApp(isLoggedIn: isLoggedIn),
  );
}

Future<void> initializeApp() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<bool> getLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

class QuraanApp extends StatelessWidget {
  final bool isLoggedIn;

  const QuraanApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: Future.delayed(const Duration(seconds: 3), () => isLoggedIn),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return snapshot.data == true
              ? const BottomNavigatorBar()
              : const WelcomeView();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quraanapp/constants/color.dart';
import 'package:quraanapp/screens/welcome_view.dart';
import 'package:quraanapp/services/firebase_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: offWhite,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: lightGreen,
                      size: 28,
                    ),
                    title: Text(
                      'الرئيسية',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: lightGreen,
                      size: 28,
                    ),
                    title: Text(
                      'الإعدادات',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 28,
                    ),
                    title: Text(
                      'تسجيل الخروج',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      await auth.signOut();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isLoggedIn', false);
                      Navigator.pushNamedAndRemoveUntil(
                          context, WelcomeView.id, (route) => false);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                '© 2025 QuraanApp',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

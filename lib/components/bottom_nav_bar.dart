import 'package:flutter/material.dart';
import 'package:quraanapp/constants/color.dart';
import 'package:quraanapp/screens/Quraan.dart';
import 'package:quraanapp/screens/home_view.dart';

class BottomNavigatorBar extends StatefulWidget {
  const BottomNavigatorBar({super.key});
  static String id = "BottomNavigatorBar";

  @override
  State<BottomNavigatorBar> createState() => _BottomNavigatorBarState();
}

class _BottomNavigatorBarState extends State<BottomNavigatorBar> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeView(),
    const Quraan(),
  ];

  void onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: offWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: lightGreen,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: "الرئيسية",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.book),
                label: "القران",
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: black,
            unselectedItemColor: offWhite,
            onTap: onItemTapped,
            iconSize: 32,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

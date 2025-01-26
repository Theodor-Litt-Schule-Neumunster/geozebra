import 'package:flutter/material.dart';

import "../screens/home_screen.dart";
import "../screens/profile_screen.dart";

class BottomBarWidget extends StatefulWidget {
  final int currentIndex;

  const BottomBarWidget({
    super.key,
    required this.currentIndex,
  });

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

// Not sure if it should be a Stateful Widget, improvements are welcome
class _BottomBarWidgetState extends State<BottomBarWidget> {
  void _onItemTapped(int index) {
    if (index == widget.currentIndex) return;

    Widget destinationScreen;

    switch (index) {
      case 0:
        destinationScreen = const HomeScreen();
        break;
      case 1:
        destinationScreen = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destinationScreen,
        transitionDuration: const Duration(milliseconds: 150),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(
          size: 24,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 20,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),
        ],
      ),
    );
  }
}

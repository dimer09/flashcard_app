import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MybottomNavigationBar extends StatefulWidget {
  final Function(int)? onTabChange;

  const MybottomNavigationBar({super.key, this.onTabChange});

  @override
  State<MybottomNavigationBar> createState() => _MybottomNavigationBarState();
}

class _MybottomNavigationBarState extends State<MybottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return GNav(
        onTabChange: (value) => widget.onTabChange!(value),
        mainAxisAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.blueAccent,
        gap: 9,
        tabs: [
          GButton(
            margin: EdgeInsets.all(5),
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            margin: EdgeInsets.all(5),
            icon: Icons.public,
            text: 'communauty',
          ),
        ]);
  }
}

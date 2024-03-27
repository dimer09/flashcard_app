import 'package:flutter/material.dart';
import '../components/navbar.dart';
import '../pages/communauty.dart';
import '../pages/home_page.dart';
import '../pages/signup_page.dart';

class MyHomePage extends StatefulWidget {
  static const routename = '/homepage';
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)?.settings.arguments;
    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(SignUpScreen.routename);
      });

      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String UserId = userId as String;
    final List<Widget> pages = [
      HomePage(userId: UserId),
      Communauty_page(userId: UserId),
    ];

    return Scaffold(
      bottomNavigationBar: MybottomNavigationBar(
        onTabChange: navigateBottomBar,
      ),
      backgroundColor: Colors.blue[800],
      body: pages[selectedIndex],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/Network.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/addPost.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/notfication.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/userAccount.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/HomePage.dart';
import '../constans/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        // Define your app's theme
      ),
      home: BottomBar(),
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomePage(),
    UserNetwork(),
    CreatePost(),
    NotficationPage(),
    UserAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.transparent,
        color: primary,
        height: 60,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <Widget>[
          Image.asset(
            'asset/home.png',
            color: _currentIndex == 0 ? Colors.white : Colors.white,
            height: 24,
            width: 24,
          ),
          Image.asset(
            'asset/connection.png',
            color: _currentIndex == 1 ? Colors.white : Colors.white,
            height: 24,
            width: 24,
          ),
          Image.asset(
            'asset/addition.png',
            color: _currentIndex == 2 ? Colors.white : Colors.white,
            height: 24,
            width: 24,
          ),
          Image.asset(
            'asset/bell.png',
            color: _currentIndex == 3 ? Colors.white : Colors.white,
            height: 24,
            width: 24,
          ),
          Image.asset(
            'asset/user.png',
            color: _currentIndex == 4 ? Colors.white : Colors.white,
            height: 24,
            width: 24,
          ),
        ],
      ),
    );
  }
}

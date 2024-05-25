import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/homepage.dart';
import 'package:researchproject/auth/auth_page.dart';

import '../Bottom Bar Pages/bottomNavigationBar.dart';
import '../screens/setting.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return BottomBar();
        } else {
          return AuthPage();
        }
      },
    );
  }
}

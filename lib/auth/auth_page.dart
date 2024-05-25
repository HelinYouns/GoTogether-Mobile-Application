import 'package:flutter/material.dart';
import 'package:researchproject/sign%20In%20&%20Out/login.dart';
import 'package:researchproject/sign%20In%20&%20Out/sign_up.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //intially , show the login page
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(showSignUpPage: toggleScreens);
    } else {
      return SignUp(showLoginPage: toggleScreens);
    }
  }
}

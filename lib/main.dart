import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:researchproject/auth/main_page.dart';
import 'package:flutter/services.dart';

//global object to accessing device screen size.
late Size mq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Platform.isAndroid
      ? await Firebase.initializeApp(
          name: "Research Project",
          options: const FirebaseOptions(
            apiKey: "AIzaSyAQs3dv9jEqw_daTZ51A0_ly1p7O7I3WtI",
            appId: "1:355241701297:android:fe8a1766719d3c49dad790",
            messagingSenderId: "355241701297",
            projectId: "research-project-25ec0",
          ),
        )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoTogether',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      //home: const SplashScreen(),
      home: MainPage(),
    );
  }
}

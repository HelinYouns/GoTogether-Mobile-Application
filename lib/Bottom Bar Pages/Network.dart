import 'package:flutter/material.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/bottomNavigationBar.dart';

class UserNetwork extends StatefulWidget {
  const UserNetwork({super.key});

  @override
  State<UserNetwork> createState() => _UserNetworkState();
}

class _UserNetworkState extends State<UserNetwork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Future Work'),
      ),
     // bottomNavigationBar: BottomBar(),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/main_page.dart';
import '../constans/colors.dart';
import '../widgets/edite_profile.dart';
import 'account_info.dart';
import 'change_password.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Sitting',style: TextStyle(color:Colors.white),),
          centerTitle: true,
        ),
        body: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: Text('Account Info',style:TextStyle(fontSize:17)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountInfoPage()),
                  );

                },
                // Add trailing arrow icon
                trailing: Icon(Icons.arrow_forward_ios, color: primary),
              ),
              ListTile(
                title: Text('Edit Profile',style:TextStyle(fontSize:17)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                },
                trailing: Icon(Icons.arrow_forward_ios, color: primary),
              ),
              ListTile(
                title: Text('Change password',style:TextStyle(fontSize:17)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );
                },
                // Add trailing arrow icon
                trailing: Icon(Icons.arrow_forward_ios, color: primary),
              ),
              SizedBox(
                height: 10, // Add height to create space
                child: Container(color: Colors.grey[200]), // Customize color here
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Language', style: TextStyle(fontSize: 17)),
                    Row(
                      children: [
                        Text('Future work', style: TextStyle(fontSize: 17,color: Colors.grey)),
                        Icon(Icons.arrow_forward_ios, color: SecondaryText),
                      ],
                    ), // Change arrow color here
                  ],
                ),
                onTap: null, // Disable onTap
              ),

              SizedBox(
                height: 10, // Add height to create space
                child: Container(color: Colors.grey[200]), // Customize color here
              ),

        ListTile(
          title: Text('Log out', style: TextStyle(fontSize: 17)),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirmation"),
                  content: Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MainPage()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Text("Yes"),
                    ),
                  ],
                );
              },
            );
          },

        // Add trailing arrow icon
                trailing: Icon(Icons.arrow_forward_ios, color: primary),
              ),

            ],
          ).toList(),
        )
    );
  }
}

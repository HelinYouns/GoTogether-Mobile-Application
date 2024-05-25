import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/addPost.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/bottomNavigationBar.dart';
import 'package:researchproject/auth/main_page.dart';

import 'package:researchproject/widgets/edite_profile.dart';
import 'package:researchproject/widgets/posts.dart';

import '../screens/setting.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  final user = FirebaseAuth.instance.currentUser!;
  String? uid = FirebaseAuth.instance.currentUser!.uid;

  //hold users data
  Map<String, dynamic>? userData;

  Future<void> getUserData() async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        userData = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {}); // Update the UI
      } else {
        print('Document does not exist on the database');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _loadUserData() async {
    await getUserData();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Helin Youns", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Container(
                width: 25, height: 25, child: Image.asset("asset/add.png")),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CreatePost()));
            },
          ),
          //log out
          IconButton(
            icon: Container(
                width: 30, height: 30, child: Image.asset("asset/menu.png")),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
          ),
          SizedBox(width: 8)
        ],
        //toolbarHeight: 20,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream:
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            //get user data
            if (snapshot.hasData) {
              final userData =
                  (snapshot.data!.data() as Map<String, dynamic>?) ?? {};
              final coverImageURL = userData['cover image'] as String? ?? '';
              final profileImageURL =
                  userData['profile image'] as String? ?? '';
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Cover Photo with Profile Picture
                    Stack(
                      children: [
                        // Cover image
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                              image: coverImageURL.isNotEmpty
                                  ? NetworkImage(coverImageURL)
                                  : AssetImage('asset/cover.jpg')
                                      as ImageProvider<Object>,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // User profile photo
                        Positioned(
                          bottom: 0,
                          left: MediaQuery.of(context).size.width / 2 -
                              80, // Centered
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: profileImageURL.isNotEmpty
                                ? NetworkImage(profileImageURL)
                                    as ImageProvider<Object>?
                                : AssetImage('asset/user_.png'),
                          ),
                        ),
                      ],
                    ),

                    // User account Name

                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0, top: 4),
                      child: Text(
                        userData.containsKey('full name') &&
                                userData['full name'] != null
                            ? userData['full name'] as String
                            : user.email!.split('@')[0],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Bio
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      child: Text(
                        userData?['bio'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    // post, followers and likes
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                userData?['posts']?.toString() ?? '0',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text("posts")
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                userData?['followers']?.toString() ?? '0',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text("followers")
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                userData?['likes']?.toString() ?? '0',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text("likes")
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Posts
                    if (userData['posts'] != null)
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('id', isEqualTo: user.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            return CircularProgressIndicator();
                          }
                          final postDocs = snapshot.data!.docs;
                          if (userData == null || postDocs == null) {
                            // Check if userData and postDocs are null
                            return SizedBox();
                          }
                          return Column(
                            children: postDocs.map<Widget>((postDoc) {
                              final postId = postDoc.id;
                              final tripType = userData['tripe type'];
                              final userId = user.uid;
                              final userImage = userData['profile image'];
                              final description =
                                  postDoc['description'] as String?;
                              final imageUrls =
                                  List<String>.from(postDoc['image']);
                              final userName = userData?['full name']
                                  as String?; // Handle potential null value
                              final likes = postDoc['likes'];
                              final location = postDoc['location'] as String?;
                              final DateTime? dateTime =
                                  postDoc['date & time']?.toDate();
                              final formattedDateTime = dateTime != null
                                  ? DateFormat('yyyy-MM-dd HH:mm')
                                      .format(dateTime)
                                  : '';

                              return PostWidget(
                                  userImage: userImage,
                                  postId: postId,
                                  userId: userId,
                                  imageUrls:
                                      imageUrls, // Corrected variable name
                                  userName: userName ?? '',
                                  descreption: description ?? '',
                                  // likes:likes ?? '',
                                  location: location ?? '',
                                  date_time: formattedDateTime ?? '',
                                  tripType: tripType ?? '');
                            }).toList(),
                          );
                        },
                      ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }
            return CircularProgressIndicator();
          }),
      //bottomNavigationBar: BottomBar(),
    );
  }
}

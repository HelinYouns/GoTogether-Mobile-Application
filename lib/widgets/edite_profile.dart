import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _profileImage;
  File? _coverImage;

  String? _profileImageUrl;
  String? _coverImageUrl;
  String? _bio;

  final picker = ImagePicker();
  TextEditingController _textEditingController = TextEditingController();

  bool _isEditing = false;
  bool _isEditingBio = false;
  @override
  void initState() {
    super.initState();
    fetchUserProfileImageUrl();
  }

  Future<void> fetchUserProfileImageUrl() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: uid)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userSnapshot = querySnapshot.docs.first;
          String? storagePath = userSnapshot.get('profile image');
          String? coverPath = userSnapshot.get('cover image');
          String? bio = userSnapshot.get('bio');
          setState(() {
            _profileImageUrl = storagePath;
            _coverImageUrl = coverPath;
            _bio = bio ?? '';
          });
        } else {
          print('No user found with email: $uid');
        }
      } else {
        print('Current user is null or email is null');
      }
    } catch (e) {
      print('Error fetching user profile image URL: $e');
    }
  }

  Future<void> getImage(bool isProfileImage) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isProfileImage) {
          _profileImage = File(pickedFile.path);
        } else {
          _coverImage =
              File(pickedFile.path); // Update _coverImage for cover photo
        }
      });
    }
  }

  Future<void> saveBioToFirebase(String newBio) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid!;
      await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: uid)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.update({'bio': newBio});
      });
    } catch (e) {
      print('Error saving bio to Firebase Firestore: $e');
    }
  }

  Future<void> uploadDataToFirebaseStorage(
      String fieldName, File imageFile, bool isProfileImage) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid!;
      String data;
      if (isProfileImage) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('user_profile_pictures/$uid.jpg');
        await ref.putFile(imageFile);
        data = await ref.getDownloadURL();
      } else {
        data = _bio ?? '';
      }

      await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: uid)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.update({'$fieldName': data});
      });
    } catch (e) {
      print('Error uploading data to Firebase Firestore: $e');
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _profileImage = null;
    _coverImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffA4CE95),
        title: Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Profile picture",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => getImage(true),
                        child: Column(
                          children: [
                            Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff95d57b),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                                as ImageProvider<Object>?
                            : AssetImage('asset/default_user.png'),
                  ),
                ),
                Visibility(
                  visible: _profileImage != null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (_profileImage != null) {
                          await uploadDataToFirebaseStorage(
                              'profile image', _profileImage!, true);
                        } else {
                          print("No image picked");
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
            Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Cover photo",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => getImage(false),
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff95d57b),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5)
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: (_coverImage != null
                            ? FileImage(_coverImage!)
                            : _coverImageUrl != null
                                ? NetworkImage(_coverImageUrl!)
                                    as ImageProvider<Object>
                                : AssetImage('asset/cover.jpg')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _coverImage != null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (_coverImage != null) {
                          await uploadDataToFirebaseStorage(
                              'cover image', _coverImage!, true);
                        } else {
                          print("No image picked");
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Bio',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () async {
                              if (_isEditingBio) {
                                // Save bio to Firebase
                                await saveBioToFirebase(
                                    _textEditingController.text);
                                // Disable editing mode
                                setState(() {
                                  _isEditingBio = false;
                                });
                              } else {
                                setState(() {
                                  _isEditingBio = true;
                                  // Set text field value to bio when entering edit mode
                                  _textEditingController.text = _bio ?? '';
                                });
                              }
                            },
                            child: Text(
                              _isEditingBio ? "Save" : "Edit",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff95d57b),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isEditingBio
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _textEditingController,
                        onChanged: (value) {
                          setState(() {
                            _bio = value;
                          });
                        },
                        maxLength: 50, // Maximum character limit
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),

                          counterText:
                          '${_textEditingController.text.length}/50', // Display character count
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_textEditingController.text.length > 50)
                        Text(
                          'Maximum character limit reached!',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  )
                      : Text(
                    _bio ?? '',
                    style: TextStyle(fontSize: 17),
                  ),
                ),

              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}

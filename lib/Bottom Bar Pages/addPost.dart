import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/bottomNavigationBar.dart';
import 'package:researchproject/widgets/location_search_screen.dart';
import '../constans/colors.dart';
import '../widgets/search_info.dart';
import 'HomePage.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _postController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _imageFiles = [];
  String? _selectedLocation;
  DateTime? _selectedDateTime;
  String? userEmail;
  bool _isButtonDisabled = true;
  bool _isTripTypeSelectorVisible = false;
  String? _selectedTripType;
  final List<String> tripTypes = [
    'Picnic',
    'Climbing trip',
    'Hiking',
    'Sightseeing tour',
    'Movie outing',
    'Bowling',
    'Game',
    'Road trip',
    'Museum visit',
    'Food truck advertor'
  ];
  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  void getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    }
  }

  Future<void> navigateToLocationSelectionScreen() async {
    final selectedLocation = await Navigator.push<Feature>(
      context,
      MaterialPageRoute(
        builder: (context) => SearchLocationScreen(),
      ),
    );
    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation.properties!.name!;
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(pickedFile);
        _checkButtonState();
      });
    }
  }

  void _checkButtonState() {
    setState(() {
      _isButtonDisabled = _imageFiles.isEmpty && _postController.text.isEmpty;
    });
  }

  Future<void> _savePostToFirestore() async {
    List<String> imageUrls = [];

    for (XFile imageFile in _imageFiles) {
      final imageStorageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      await imageStorageRef.putFile(File(imageFile.path));
      final imageUrl = await imageStorageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    await FirebaseFirestore.instance.collection('posts').add({
      'comments': '',
      'likes': 0,
      'email': userEmail,
      'description': _postController.text,
      'location': _selectedLocation,
      'tripe type': _selectedTripType,
      'date & time': _selectedDateTime != null
          ? Timestamp.fromDate(_selectedDateTime!)
          : null,
      'image': imageUrls,
    });
// Increment the post count in the user's document
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final userData = await userDoc.get();
    if (userData.exists) {
      final currentPostCount = userData['posts'] ?? 0;
      await userDoc.update({'posts': currentPostCount + 1});
    }
    setState(() {
      _postController.clear();
      _selectedLocation = null;
      _selectedDateTime = null;
      _selectedTripType = null;
      _imageFiles.clear();
      _isButtonDisabled = true;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => BottomBar()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Content Posted successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _isButtonDisabled ? null : _savePostToFirestore,
              child: Text(
                "Post",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffA4CE95),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                if (_selectedTripType != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTripType = null;
                        });
                      },
                      child: Text(
                        _selectedTripType!,
                        style: TextStyle(
                          fontSize: 18,color:Colors.grey,
                          //fontWeight: FontWeight.bold,

                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _postController,
                onChanged: (value) {
                  _checkButtonState();
                },
                decoration: InputDecoration(
                  hintText: 'Write your post here...',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            if (_imageFiles.isNotEmpty)
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: _imageFiles.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(File(_imageFiles[index].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imageFiles.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_selectedLocation != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLocation = null;
                        });
                      },
                      child: Text(
                        _selectedLocation!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                if (_selectedDateTime != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDateTime = null;
                        });
                      },
                      child: Text(
                        DateFormat.yMd().add_jm().format(_selectedDateTime!),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      width: 28,
                      height: 28,
                      child: Image.asset("asset/image.png"),
                    ),
                    onPressed: _getImageFromGallery,
                  ),
                  GestureDetector(
                    onTap: _getImageFromGallery,
                    child: Text(
                      "Image",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      width: 28,
                      height: 28,
                      child: Image.asset("asset/location.png"),
                    ),
                    onPressed: navigateToLocationSelectionScreen,
                  ),
                  GestureDetector(
                    onTap: navigateToLocationSelectionScreen,
                    child: Text("Location", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      width: 28,
                      height: 28,
                      child: Image.asset("asset/brochure.png"),
                    ),
                    onPressed: () {
                      setState(() {
                        _isTripTypeSelectorVisible =
                            !_isTripTypeSelectorVisible;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isTripTypeSelectorVisible =
                            !_isTripTypeSelectorVisible;
                      });
                    },
                    child: Text(
                      "Tripe type",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
                  if (_isTripTypeSelectorVisible)
                  Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: 0),
                  itemExtent: 25,
                  onSelectedItemChanged: (int index) {
                  setState(() {
                  _selectedTripType = tripTypes[index];
                  _isTripTypeSelectorVisible = false;
                  });
                  },
                  children: tripTypes.map((tripType) => Text(tripType)).toList(),
                  ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      width: 28,
                      height: 28,
                      child: Image.asset("asset/calendar.png"),
                    ),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: Text(
                      "Date & Time",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomBar(),
    );
  }
}

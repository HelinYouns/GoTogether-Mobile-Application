import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../screens/search.dart';
import '../widgets/chatlist.dart';
import '../widgets/posts.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imageUrls = [];
  int currentIndexContainer = 0;
  Timer? timer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      startImageSlider();
    });
  }
  void startImageSlider() {
    fetchImages(); // Fetch images
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (mounted) {
        currentIndexContainer = (currentIndexContainer + 1) % imageUrls.length;
        _pageController.animateToPage(
          currentIndexContainer,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        t.cancel();
      }
    });
  }

  void fetchImages() async {
    if (imageUrls.isEmpty) {
      imageUrls = await getAllImagesFromFolder();
      setState(() {});
    }
  }

  Future<List<String>> getAllImagesFromFolder() async {
    final List<String> imageUrls = [];
    final Reference ref = FirebaseStorage.instance.ref().child('/advertizment_banner_image');

    try {
      final result = await ref.listAll();
      for (final item in result.items) {
        final imageUrl = await item.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    } catch (e) {
      print('Error fetching images: $e');
    }

    return imageUrls;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "GoTogether",
          style: TextStyle(fontSize: 20.0),
        ),
        actions: [
          _buildAction("asset/search.png", () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPage()))),
          _buildAction("asset/messenger.png", () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatListPage()))),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: Container(
          //     height: 120.0,
          //     margin: EdgeInsets.symmetric(vertical: 5.0),
          //     child: PageView.builder(
          //       itemCount: imageUrls.length,
          //       controller: _pageController,
          //       onPageChanged: (index) {
          //         setState(() {
          //           currentIndexContainer = index;
          //         });
          //       },
          //       itemBuilder: (context, index) {
          //         final currentIndex = _pageController.hasClients ? _pageController.page ?? 0 : 0;
          //         final difference = index - currentIndex;
          //         final opacity = 1 - (difference.abs() * 0.5);
          //
          //         return Container(
          //           margin: EdgeInsets.symmetric(horizontal: 10.0),
          //           alignment: Alignment.center,
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(15.0),
          //             child: Image.network(
          //               imageUrls[index],
          //               fit: BoxFit.cover,
          //               width: MediaQuery.of(context).size.width * 0.9,
          //               height: MediaQuery.of(context).size.height * 0.5,
          //             ),
          //           ),
          //           decoration: BoxDecoration(
          //             color: Colors.white.withOpacity(opacity),
          //             borderRadius: BorderRadius.circular(15.0),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              }
              if (snapshot.hasData) {
                final posts = snapshot.data!.docs;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final postData = posts[index].data() as Map<String, dynamic>;
                      final DateTime? dateTime = postData['date & time']?.toDate();
                      final formattedDateTime = dateTime != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(dateTime)
                          : '';
                      return PostWidget(
                        userImage: postData['userImage'] ?? '',
                        imageUrls: List<String>.from(postData['image'] ?? []),
                        userName: postData['userName'] ?? '',
                        descreption: postData['description'] ?? '',
                        location: postData['location'] ?? '',
                        date_time: formattedDateTime ?? '',
                        userId: postData['email'] ?? '',
                        postId: postData['postId'] ?? '',
                        tripType: postData['tripe type'] ?? '',
                      );
                    },
                    childCount: posts.length,
                  ),
                );
              }
              return SliverFillRemaining(
                child: SizedBox(), // Return an empty SizedBox if no data
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildAction(String asset, void Function() onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 25,
          height: 25,
          child: Image.asset(asset),
        ),
      ),
    );
  }
}

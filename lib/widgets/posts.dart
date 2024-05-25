import 'package:flutter/material.dart';
import 'package:researchproject/widgets/commetBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostWidget extends StatefulWidget {
  final List<String> imageUrls;
  final String userName;
  final String descreption;
  final String location;
  final String date_time;
  final String userId;
  final String postId;
  final String userImage;
  final String tripType;

  const PostWidget({
    required this.userImage,
    required this.imageUrls,
    required this.userName,
    required this.descreption,
    required this.location,
    required this.date_time,
    required this.userId,
    required this.postId,
    required this.tripType,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isExpanded = false;
  bool isLiked = false;
  String _getFirstFiveWords(String description) {
    List<String> words = description.split(' ');
    if (words.length <= 5) {
      return description;
    } else {
      return words.sublist(0, 20).join(' ');
    }
  }

  void likePost(String postId, String userId, String userName) {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(userId);

    likeRef.get().then((likeDoc) {
      if (likeDoc.exists) {
        // User has already liked the post
        print('User already liked the post');
      } else {
        // User is liking the post for the first time
        likeRef.set({
          'userId': userId,
          'userName': userName,
          'timestamp': Timestamp.now(),
          'isLiked': true,
        }).then((_) {
          // Update the likes count in the post document
          postRef.update({'likes': FieldValue.increment(1)});
        });
      }
    });
  }

  void deletePost() {
    // Implement delete post functionality
    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    postRef.delete().then((value) {
      print('Post deleted successfully');
    }).catchError((error) {
      print('Failed to delete post: $error');
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: widget.userImage.isNotEmpty
                        ? NetworkImage(widget.userImage)
                        : AssetImage('asset/user_.png')
                            as ImageProvider<Object>,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.tripType,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    // Show confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Deletion"),
                          content: Text(
                              "Are you sure you want to delete this post?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                // Handle delete option
                                deletePost();
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (value == 'edit') {
                    // Handle edit option
                    // Navigate to edit screen or perform edit action
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCrossFade(
                  firstChild: Text(
                    widget.descreption,
                    style: TextStyle(fontSize: 17),
                  ),
                  secondChild: Text(
                    _getFirstFiveWords(widget.descreption),
                    style: TextStyle(fontSize: 16),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 300),
                ),
                if (widget.descreption.split(' ').length > 10)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'Read Less' : 'Read More',
                      style: TextStyle(
                        color: Color(0xffA4CE95),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Image Post Section
        if (widget.imageUrls.isNotEmpty) // Only display if there are images
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                widget.imageUrls.length,
                (index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: index == widget.imageUrls.length - 1 ? 375 : 360,
                        height: 300,
                        child: Image.network(
                          widget.imageUrls[index], // Construct full URL
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
            children: [
              if (widget.location != null && widget.location.isNotEmpty)
                Row(
                  children: [
                    Text(
                      'Location : ${widget.location}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              if (widget.date_time != null && widget.date_time.isNotEmpty)
                Row(
                  children: [
                    Text(
                      'Time at ${widget.date_time}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                )
            ],
          ),

        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isLiked = !isLiked;
                });
                likePost(widget.postId, widget.userId, widget.userName);
              },
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : null,
                size: 25,
              ),
            ),
            IconButton(
              icon: Container(
                  width: 21,
                  height: 21,
                  child: Image.asset("asset/comment.png")),
              onPressed: () {
                CommentSheet.show(
                    context, widget.postId, widget.userImage, widget.userName,
                    () {
                  print('Comment submitted');
                });
              },
            ),
            IconButton(
              icon: Container(
                width: 21,
                height: 21,
                child: Image.asset("asset/send.png"),
              ),
              onPressed: () {},
            ),
            Spacer(),
          ],
        ),
        Divider(thickness: 1),
      ],
    );
  }
}

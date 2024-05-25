import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentSheet {
  static void show(BuildContext context, String postId,
      String userProfilePhotoUrl, String userName, VoidCallback onSubmit) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Hide the keyboard when tapping outside the text field
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: CommentBox(
              userImage: CommentBox.commentImageParser(
                imageURLorPath: userProfilePhotoUrl,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .collection('comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> comments = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment =
                            comments[index].data() as Map<String, dynamic>;
                        final String name = comment['name'] ?? '';
                        final String pictureUrl = comment['pic'] ?? '';
                        final String message = comment['message'] ?? '';
                        final String time = comment['date'] ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(pictureUrl),
                          ),
                          title: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message),
                              Text(
                                time,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return Container(); // Return an empty container by default
                },
              ),
              labelText: 'Write a comment...',
              errorText: 'Comment cannot be blank',
              withBorder: false,
              sendButtonMethod: () => _sendComment(
                  postId,
                  userName,
                  userProfilePhotoUrl,
                  formKey,
                  commentController,
                  onSubmit,
                  context),
              formKey: formKey,
              commentController: commentController,
              backgroundColor: Color(0xffA4CE95),
              textColor: Colors.white,
              sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  static void _sendComment(
      String postId,
      String userName,
      String userProfilePhotoUrl,
      GlobalKey<FormState> formKey,
      TextEditingController commentController,
      VoidCallback onSubmit,
      BuildContext context) {
    if (formKey.currentState!.validate()) {
      Map<String, String> newComment = {
        'name': userName,
        'pic': userProfilePhotoUrl,
        'message': commentController.text,
        'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      };

      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(newComment)
          .then((value) {
        onSubmit();
        Navigator.pop(context); // Close the bottom sheet
      }).catchError((error) {
        print('Error adding comment to Firestore: $error');
      });
    }
  }
}

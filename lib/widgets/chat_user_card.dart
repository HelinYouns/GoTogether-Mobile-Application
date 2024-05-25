import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:researchproject/constans/colors.dart';
import 'package:researchproject/main.dart';
import 'package:researchproject/models/chatpage.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.03, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          //for navigate to chat screen
          Navigator.push(context, MaterialPageRoute(
              builder: (_)=>ChatScreen(user:widget.user)));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height*.03),
            child: CachedNetworkImage(
              width: mq.height*.055,
              height: mq.height*.055,
              fit:BoxFit.fill,
              imageUrl: widget.user
              .image,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>const CircleAvatar(child:Icon(CupertinoIcons.person)),
            ),
          ),
          //user name
          title: Text(
            widget.user.name,
            style: TextStyle(),
          ),
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          trailing: Container(width:13,height:13,decoration:BoxDecoration(color:primary,borderRadius: BorderRadius.circular(10)))
          // trailing: Text(
          //   '12:00 PM',
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ),
    );
  }
}

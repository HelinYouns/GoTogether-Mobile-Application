import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:researchproject/widgets/message_card.dart';

import '../api/api.dart';
import '../main.dart';
import '../models/chatpage.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all messages
  List<Message> _list = [];

  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return SizedBox();
                      //if some data or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;

                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (!_list.isEmpty) {
                          return ListView.builder(
                            padding: EdgeInsets.only(top: mq.height * 0.01),
                            physics: BouncingScrollPhysics(),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index]);
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('Say Hi..👋🏻',
                                  style: TextStyle(fontSize: 20)));
                        }
                    }
                  },
                ),
              ),
              _chatInput()
            ],
          )),
    );
  }

  //appBar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            color: Colors.black54),
        ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .03),
            child: CachedNetworkImage(
              width: mq.height * .055,
              height: mq.height * .055,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            )),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 2,
            ),
            Text('Last seen not available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ))
          ],
        )
      ]),
    );
  }

  //button chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.height * .025),
      child: Row(children: [
        //input field & buttons
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                //emoji button
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions),
                    color: Colors.blueAccent),
                Expanded(
                  child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none)),
                ),
                //pick image from gallary button
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.image),
                  color: Colors.blueAccent,
                  iconSize: 26,
                ),
                //take image from camera button
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera),
                  color: Colors.blueAccent,
                  iconSize: 26,
                ),
                SizedBox(
                  width: mq.width * .02,
                )
              ],
            ),
          ),
        ),
        //send message button
        MaterialButton(
            shape: const CircleBorder(),
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            color: Colors.green,
            onPressed: () {
              if(_textController.text.isNotEmpty){
                APIs.sendMessage(widget.user,_textController.text);
                _textController.clear();
              }
            },
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ))
      ]),
    );
  }
}

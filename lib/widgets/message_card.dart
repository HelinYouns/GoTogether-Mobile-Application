import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../main.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  //sender or another user message
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            padding: EdgeInsets.all(mq.width * .04),
            child: Text(widget.message.msg,
                style: TextStyle(fontSize: 15, color: Colors.black87)),
          ),
        ),

        //
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(widget.message.sent,
              style: TextStyle(fontSize: 13, color: Colors.black54)),
        )
      ],
    );
  }

//our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width*.04,),
            //double tick  blue icon for message read
            Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),
            SizedBox(width:2,),
            //message time
            Text('${widget.message.read} 12:00',
                style: TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ),
        //the message
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            padding: EdgeInsets.all(mq.width * .04),
            child: Text(widget.message.msg,
                style: TextStyle(fontSize: 15, color: Colors.black87)),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:researchproject/api/api.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/homepage.dart';
import 'package:researchproject/main.dart';
import 'package:researchproject/models/chatpage.dart';
import 'package:researchproject/widgets/chat_user_card.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<ChatUser> list = [];
  //for searching
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  Map<String, String> reminderData = {
    'Reminder 1': 'asset/hiking.png',
    'Reminder 2': 'asset/camping.png',
    'Reminder 3': 'asset/picnic.png',
  };

  TextEditingController _searchController = TextEditingController();

  void _navigateToChatPage(String user) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ChatPage(userName: user)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Container(
                width: 30,
                height: 30,
                child: Image.asset("asset/left-arrow.png"),
              ),
            ),
            title: Text("helin youns",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _isSearching = val.isNotEmpty;
                      _searchList.clear();
                      if (_isSearching) {
                        for (var user in list) {
                          if (user.name
                              .toLowerCase()
                              .contains(val.toLowerCase())) {
                            _searchList.add(user);
                          }
                        }
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(8),
                    filled: true,
                    fillColor: Colors.grey[120],
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Text(
                  "Reminder",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      for (var entry in reminderData.entries)
                        Row(
                          children: [
                            Container(
                              width: 300,
                              height: 50,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xffA4CE95),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        entry.key,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage(entry.value), // Set image
                                  ),
                                ],
                              ),
                            ),
                            if (entry != reminderData.entries.last)
                              SizedBox(width: 8),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllUsers(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      //if some data or all data is loaded then show it
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .toList() ??
                            [];

                        return ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              _isSearching ? _searchList.length : list.length,
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                                user: _isSearching
                                    ? _searchList[index]
                                    : list[index]);
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

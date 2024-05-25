import 'package:flutter/material.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/bottomNavigationBar.dart';
import 'package:researchproject/widgets/custom_follw_notfication.dart';
import 'package:researchproject/widgets/custom_linked_notfication.dart';

class NotficationPage extends StatelessWidget {
  NotficationPage({super.key});

  List newItem = ["liked", "follow"];
  List todayItem = ["follow", "liked", "liked"];
  List oldesItem = ["follow", "follow", "liked", "liked"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newItem.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0.5,
                      color: Colors.white,
                      child: newItem[index] == "follow"
                          ? CustomFollowNotfication()
                          : CustomLikedNotifcation(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Today",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: todayItem.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: todayItem[index] == "follow"
                          ? CustomFollowNotfication()
                          : CustomLikedNotifcation(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Oldest",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: oldesItem.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: oldesItem[index] == "follow"
                          ? CustomFollowNotfication()
                          : CustomLikedNotifcation(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        //bottomNavigationBar: BottomBar(),
      ),
    );
  }
}

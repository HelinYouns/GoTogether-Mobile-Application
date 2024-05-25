import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:researchproject/Bottom%20Bar%20Pages/homepage.dart';

class User {
  final String userName;
  final String email;

  User({
    required this.userName,
    required this.email,
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return User(
      userName: data['user name'] ?? '',
      email: data['email'] ?? '',
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  String centerr = "Search";
  late QuerySnapshot<Map<String, dynamic>>? snapshot;

  void _showFilterOptions(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double halfScreenHeight = screenHeight / 2;

    // Define your filter options as a list
    List<String> cityFilterOptions = [
      'Erbil',
      'Sulaymaniyah',
      'Dhok',
      'Kirkuk',
      'Zaxo',
      'Halabja',
    ];
    List<String> travelFilterOptions = [
      'Picnic',
      'Communication',
      'Hiking',
      'Camp',
      'Football',
      'Scince',
    ];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: halfScreenHeight,
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select type of travel",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Center(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    // Use a loop to create ElevatedButton for each filter option
                    for (String option in cityFilterOptions)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffA4CE95),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          _handleCityFilterOption(option);
                          Navigator.pop(context);
                        },
                        child: Text(
                          option,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select type of travel",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Center(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    // Use a loop to create ElevatedButton for each filter option
                    for (String option in travelFilterOptions)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffA4CE95),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _handleTravelFilterOption(option);
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        child: Text(
                          option,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleCityFilterOption(String option) {
    if (option == 'Sulaymaniyah') {
      //this just for test
      centerr = 'Sulaymaniyah button pressed';
    } else if (option == 'Erbil') {
      centerr = '$option button pressed';
    } else if (option == 'Dhok') {
      centerr = '$option button pressed';
    } else if (option == 'Kirkuk') {
      centerr = '$option button pressed';
    } else if (option == 'Zaxo') {
      centerr = '$option button pressed';
    } else if (option == 'Halabja') {
      centerr = '$option button pressed';
    } else {
      centerr = 'Search button pressed';
    }
  }

  void _handleTravelFilterOption(String option) {
    if (option == 'Picnic') {
      //this just for test
      centerr = 'Sulaymaniyah button pressed';
    } else if (option == 'Hiking') {
      centerr = '$option button pressed';
    } else if (option == 'Camp') {
      centerr = '$option button pressed';
    } else if (option == 'Football') {
      centerr = '$option button pressed';
    } else if (option == 'Scince') {
      centerr = '$option button pressed';
    } else if (option == 'Communication') {
      centerr = '$option button pressed';
    } else {
      centerr = 'Search button pressed';
    }
  }

  Future<void> _searchUsers(String searchText) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('user_name', isEqualTo: searchText) // Search by user_name field
          .get();

      final users = snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();

      setState(() {
        centerr = 'Search results: ${users.length}'; // Update UI with search results count
        // Store the search results as needed...
      });
    } catch (error) {
      print('Error searching users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffA4CE95),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          icon: Container(
            width: 30,
            height: 30,
            child: Image.asset("asset/left-arrow.png"),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (String value) {
                      _searchUsers(value); // Call search function on submit
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 2),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      hintText: 'Search..',
                      suffixIcon: IconButton(
                        padding: const EdgeInsets.only(bottom: 2),
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _showFilterOptions(context);
              },
              icon: Container(
                width: 30,
                height: 30,
                child: Image.asset("asset/setting.png"),
              ),
            ),
          ],
        ),
      ),
      body: _buildSearchResults(), // Call method to build search results
    );
  }

  // Function to build search results
  Widget _buildSearchResults() {
    if (snapshot == null || snapshot!.docs.isEmpty) {
      return Center(
        child: Text(centerr),
      );
    } else {
      return ListView.builder(
        itemCount: snapshot!.docs.length,
        itemBuilder: (context, index) {
          final user = User.fromFirestore(snapshot!.docs[index]);
          // Build UI for each search result item
          return ListTile(
            title: Text(user.userName),
            subtitle: Text(user.email),
            // Add more fields as needed...
          );
        },
      );
    }
  }

}

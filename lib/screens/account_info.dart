import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:researchproject/constans/colors.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  bool _isEditing = false;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _fullName;
  DateTime? _birthday;
  String? _address;
  String? _email;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    setState(() {
      _email = userSnapshot['email'];
      _emailController.text = _email ?? '';

      _fullName = userSnapshot['full name'];
      _fullNameController.text = _fullName ?? '';

      // Parse birthday date into a DateTime object
      Timestamp? timestamp = userSnapshot['birthday'];
      _birthday = timestamp?.toDate();
      _birthdayController.text = _birthday != null
          ? DateFormat('yyyy-MM-dd').format(_birthday!)
          : '';
      _address = userSnapshot['address'];
      _addressController.text = _address ?? '';

      _isLoading = false; // Set loading state to false after data is loaded
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'full name': _fullNameController.text,
    });

    _toggleEdit();
  }
  void _deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.delete();

    } catch (e) {
      // An error occurred while deleting the account
      print("Failed to delete account: $e");

    }
  }
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel",style:TextStyle(color:Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _deleteAccount();
              },
              child: Text("Delete",style:TextStyle(color:Colors.red,)),

            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Account Info',style:TextStyle(color:Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primary,
        actions: [
          _isEditing
              ? TextButton(
            onPressed: _saveChanges,
            child: Text('Save',style:TextStyle(color:Colors.white)), // Add a child parameter to TextButton
          )
              : TextButton(
            onPressed: _toggleEdit,
            child: Text('Edit',style:TextStyle(color:Colors.white)), // Add a child parameter to TextButton
          ),
        ],

      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            ListTile(
              title: Text(
                'Email',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                _email ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Full name',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: _isEditing
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: _fullNameController,
                  onChanged: (value) {
                    setState(() {
                      _fullName = value;
                    });
                  },
                  style: TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                ),
              )
                  : Text(
                _fullName ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Birthday',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: _isEditing
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: _birthdayController,
                  onChanged: (value) {
                    setState(() {
                      // Parse string into DateTime object
                      _birthday = DateFormat('yyyy-MM-dd').parse(value);
                    });
                  },
                  style: TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    hintText: 'Enter your Birthday (yyyy-MM-dd)',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                ),
              )
                  : Text(
                _birthday != null
                    ? DateFormat('yyyy-MM-dd').format(_birthday!)
                    : '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Address',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: _isEditing
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: _addressController,
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  style: TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    hintText: 'Enter your address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                ),
              )
                  : Text(
                _address ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Divider(),
            SizedBox(height:20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(330, 50),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (){ _showConfirmationDialog();},
                child: Text(
                  "Delete account",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                )),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(), // Show loading indicator
              ),
          ],
        ),

      ),
    );
  }
}

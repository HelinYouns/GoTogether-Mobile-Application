import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class SignUp extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUp({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isObscure = true;
  bool haveAccount = false;
  DateTime? _selectedDate;
  bool _isDatePickerVisible = false;

  // Text controllers
  final _usernameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Error messages for each field
  String? fullNameError;
  String? birthdayError;
  String? addressError;
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Check password strength
      String password = _passwordController.text.trim();
      if (password.length < 6 ||
          !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()])')
              .hasMatch(password)) {
        setState(() {
          passwordError = 'Password must be at least 6 characters long and include Uppercase(A-Z), Lowercase(a-z), Number(0-9) and signs(#%^&) ';
        });
        return;
      }

      try {
        // Create user
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: password,
        );

        // Add user details
        addUserDetails(
          _usernameController.text.trim(),
          _selectedDate ?? DateTime.now(),
          _addressController.text.trim(),
          _emailController.text.trim(),
        );
      } catch (e) {
        setState(() {
          // Set haveAccount flag to true when sign-up fails
          haveAccount = true;
        });
      }
    }
  }

  Future<void> addUserDetails(
      String fullName,
      DateTime birthday,
      String address,
      String email,
      ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'full name': fullName,
        'birthday': Timestamp.fromDate(birthday),
        'address': address,
        'email': email,
        'cover image': null,
        'followers': 0,
        'likes': 0,
        'post': 0,
        'posts': null,
        'profile image': null,
        'bio': null
      });
      haveAccount = false;
      print("User details added");
    } catch (e) {
      print("Failed to add user details: $e");
      // Handle error, e.g., show an error message to the user
    }
  }
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate ?? DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedDate = newDateTime;
                _birthdayController.text =
                    DateFormat('yyyy-MM-dd').format(newDateTime);
              });
            },
          ),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              //banner image
              Container(
                height: 170,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Image(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  image: AssetImage("asset/Banner_1.png"),
                ),
              ),
              //sizedbox
              SizedBox(
                height: 8,
              ),
              //sign up text
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: "BebasNeue",
                ),
              ),
              //sizedbox
              SizedBox(
                height: 8,
              ),
              buildTextField(
                controller: _usernameController,
                labelText: "Full name",
                keyboardType: TextInputType.name,
                errorText: fullNameError,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              //sizedbox
              SizedBox(
                height: 8,
              ),

              buildTextField(
                controller: _birthdayController,
                labelText: "Birthday",
                keyboardType: TextInputType.datetime,
                errorText: birthdayError,
                validator:   (value) {
        if (value == null || value.isEmpty) {
        return 'Please enter your Birthday';
        }
        return null;
        },
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    setState(() {
                      _isDatePickerVisible = !_isDatePickerVisible;
                    });
                  },
                ),
                onTap: () {
                  if (_isDatePickerVisible) {
                    _showDatePicker(context);
                  }
                },
              ),

              if (_isDatePickerVisible)
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _selectedDate = newDateTime;
                        _birthdayController.text =
                            DateFormat('yyyy-MM-dd')
                                .format(newDateTime);
                      });
                    },
                  ),
                ),

              //sizedbox
              SizedBox(
                height: 8,
              ),
              buildTextField(
                controller: _addressController,
                labelText: "Address",
                keyboardType: TextInputType.streetAddress,
                errorText: addressError,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              //sizedbox
              SizedBox(
                height: 8,
              ),
              buildTextField(
                controller: _emailController,
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
                errorText: emailError,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email format validation if needed
                  return null;
                },
              ),
              //sizedbox
              SizedBox(
                height: 8,
              ),
              buildTextField(
                controller: _passwordController,
                labelText: "Password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: _isObscure,
                errorText: passwordError,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  // Add password strength validation if needed
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(haveAccount ?
                'This email already exist':'',style:TextStyle(color:Colors.red)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffA4CE95),
                  minimumSize: Size(330, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _signUp,
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.blue, fontSize: 17),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
    bool enabled = true,
    FormFieldValidator<String>? validator,
    GestureTapCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: Color.fromARGB(255, 129, 129, 129),
                fontSize: 14.0,
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 238, 237, 237),
              contentPadding:
              EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color(0xffA4CE95),
                ),
              ),
              suffixIcon: suffixIcon,
              errorText: errorText,
              errorMaxLines: 3,
              errorStyle: TextStyle(fontSize: 12.0),

            ),
            validator: validator,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

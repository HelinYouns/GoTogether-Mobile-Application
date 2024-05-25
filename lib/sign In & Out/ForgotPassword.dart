import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _passwordReset() async {
    final email = _emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showResetSuccessDialog();
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e);
    } finally {
      _emailController.clear();
    }
  }

  void _showResetSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Password reset link sent! Check your email"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Navigate back to login page
                },
                child: Text(
                  'Back to Login',
                  style: TextStyle(fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xffA4CE95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showErrorSnackBar(FirebaseAuthException e) {
    String errorMessage = e.message ?? "An error occurred";

    if (e.code == 'user-not-found') {
      errorMessage = "Email not found.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xffA4CE95),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Warning !",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Please, input your email !',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                child: Image.asset(
                  "asset/world.png",
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        duration: Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
        title: Text(
          "Reset Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xffA4CE95),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter your Email and we will send you a password reset link :',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Color.fromARGB(255, 238, 237, 237),
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xffA4CE95)),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffA4CE95),
              minimumSize: Size(250, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _passwordReset,
            child: Text(
              "Reset password",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

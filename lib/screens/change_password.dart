import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:researchproject/constans/colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController _currentPasswordController =
  TextEditingController();
  late TextEditingController _newPasswordController = TextEditingController();
  late TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  String _errorText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  bool _validatePassword(String password) {
    // Define regex patterns for each validation criteria
    RegExp uppercaseRegex = RegExp(r'[A-Z]');
    RegExp lowercaseRegex = RegExp(r'[a-z]');
    RegExp digitRegex = RegExp(r'\d');
    RegExp specialCharRegex = RegExp(r'[~@#%^&*_+-/?]');

    // Check if the password meets all the criteria
    bool hasUppercase = uppercaseRegex.hasMatch(password);
    bool hasLowercase = lowercaseRegex.hasMatch(password);
    bool hasDigit = digitRegex.hasMatch(password);
    bool hasSpecialChar = specialCharRegex.hasMatch(password);

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  Future<void> _changePassword() async {
    try {
      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmPasswordController.text;

      if (newPassword != confirmPassword) {
        setState(() {
          _errorText = 'Passwords do not match';
        });
        return;
      } // Validate the new password
      bool isValidPassword = _validatePassword(newPassword);

      if (!isValidPassword) {
        setState(() {
          _errorText =
          'Password must be at least 8 characters and should include this characters';
        });
        return;
      }


      // Re-authenticate the user
      String? email = FirebaseAuth.instance.currentUser?.email;
      AuthCredential credential = EmailAuthProvider.credential(
        email: email!,
        password: currentPassword,
      );
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential);

      // Change password
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);

      // Navigate back or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
        ),
      );
      Navigator.pop(context); // Navigate back after successful password change
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.message!;
      });
    }
  }


  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required Function() toggleVisibility,
    required bool showPassword,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: IconButton(
            onPressed: toggleVisibility,
            icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Change password',style:TextStyle(color:Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPasswordField(
              controller: _currentPasswordController,
              labelText: 'Current Password',
              obscureText: !_showCurrentPassword,
              toggleVisibility: () {
                setState(() {
                  _showCurrentPassword = !_showCurrentPassword;
                });
              },
              showPassword: _showCurrentPassword,
            ),
            _buildPasswordField(
              controller: _newPasswordController,
              labelText: 'New Password',
              obscureText: !_showNewPassword,
              toggleVisibility: () {
                setState(() {
                  _showNewPassword = !_showNewPassword;
                });
              },
              showPassword: _showNewPassword,
            ),
            _buildPasswordField(
              controller: _confirmPasswordController,
              labelText: 'Confirm New Password',
              obscureText: !_showConfirmPassword,
              toggleVisibility: () {
                setState(() {
                  _showConfirmPassword = !_showConfirmPassword;
                });
              },
              showPassword: _showConfirmPassword,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                'Password must be at least 8 characters and should include:',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('* 1 uppercase letter (A-Z)'),
                      Text('* 1 lowercase letter (a-z)'),
                      Text('* 1 number (0-9)'),
                      Text("* 1 special character (~@#%^&*_+-/?)"),
                    ],
                  ),
                ],
              ),
            ),
            if (_errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffA4CE95),
                  minimumSize: const Size(330, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _changePassword,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

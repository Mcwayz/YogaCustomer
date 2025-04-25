import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Auth/Login.dart'; // Import FirebaseAuth for logout functionality

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final Color titleColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
  });
Future<void> _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut(); // Sign out the user
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false, // Remove all previous routes
    );
  } catch (e) {
    print("Error logging out: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 20,
         // fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.logout, color: Colors.black), // Logout icon
        onPressed: () => _logout(context), // Call the logout function
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
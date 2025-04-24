import 'package:flutter/material.dart';
import '../Auth/Login.dart'; // Replace with the screen you want to navigate to after the splash screen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()), // Replace with your target screen
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/logo.png", // Replace with your logo path
          height: 150,
        ),
      ),
    );
  }
}
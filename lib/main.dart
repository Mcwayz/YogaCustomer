import 'package:flutter/material.dart';
import 'Pages/splash.dart';
import 'Auth/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yoga Customer',
      initialRoute: "/",
      routes: {
        '/': (context) => const SplashScreen(), // Splash screen as the initial route
        '/login': (context) => const SignInScreen(), // Login screen route
      },
    );
  }
}
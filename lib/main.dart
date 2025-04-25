import 'package:flutter/material.dart';
import 'Pages/MainNavigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/splash.dart';
import 'Auth/Login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(); // Ensure Firebase is initialized
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
        '/': (context) => const SplashScreen(), 
        '/login': (context) => const SignInScreen(), 
        '/Navigation': (context) => const MainNavigation(),
      },
    );
  }
}
import 'package:customer_app/component/customAppBar.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'ForgotPasswordScreen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        backgroundColor: Colors.white,
        title: "Sign In",
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Logo
              Image.asset(
                "assets/images/logo.png", // Replace with your logo path
                height: 100,
              ),
              const SizedBox(height: 16),
              // Welcome Text
              const Text(
                "Welcome Back",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in with your email and password  \nor continue with social media",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF757575)),
              ),
              const SizedBox(height: 32),
              // Email Input
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Enter your email",
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Color(0xFF757575)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  // Handle email input change
                },
              ),
              const SizedBox(height: 24),
              // Password Input
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter your password",
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF757575)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  // Handle password input change
                },
              ),
              const SizedBox(height: 16),
              // Continue Button
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFFFF7643),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                child: const Text("Continue"),
              ),
              const SizedBox(height: 16),
              // Forgot Password
              GestureDetector(
                onTap: () {
                  // Navigate to Forgot Password screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Color(0xFFFF7643),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Social Media Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.red),
                    onPressed: () {
                      // Handle Google login
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.facebook, size: 32, color: Colors.blue),
                    onPressed: () {
                      // Handle Facebook login
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.alternate_email, size: 32, color: Colors.lightBlue),
                    onPressed: () {
                      // Handle Email login
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Sign Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Sign Up screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFFFF7643),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
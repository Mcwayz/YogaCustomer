import 'package:flutter/material.dart';
import '../component/CustomTextInput.dart';

class ChangePasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Inline logo
              Image.asset(
                "assets/logo.png", 
                height: 100,
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                "Change Password",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextInput(
                      hintText: "Enter your new password",
                      labelText: "New Password",
                      obscureText: true,
                      suffixIcon: const Icon(Icons.lock, color: Color(0xFF757575)),
                      onChanged: (password) {
                        // Handle password input change
                      },
                      onSaved: (password) {
                        // Save password
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextInput(
                      hintText: "Confirm your new password",
                      labelText: "Confirm Password",
                      obscureText: true,
                      suffixIcon: const Icon(Icons.lock_outline, color: Color(0xFF757575)),
                      onChanged: (password) {
                        // Handle confirm password input change
                      },
                      onSaved: (password) {
                        // Save confirm password
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Change Password Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFFFF7643),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
                child: const Text("Change Password"),
              ),
              const SizedBox(height: 16),
              // Already have an account? Sign in
              TextButton(
                onPressed: () {
                  // Handle navigation to Sign In screen
                  Navigator.pop(context);
                },
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    children: [
                      TextSpan(
                        text: "Sign in",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
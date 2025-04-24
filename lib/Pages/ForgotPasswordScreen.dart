import 'package:flutter/material.dart';
import '../component/CustomTextInput.dart';

class ChangePasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ChangePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LogoWithTitle(
        title: "Change Password",
        children: [
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
    );
  }
}

class LogoWithTitle extends StatelessWidget {
  final String title, subText;
  final List<Widget> children;

  const LogoWithTitle({
    Key? key,
    required this.title,
    this.subText = '',
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.1,
                width: double.infinity,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  subText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.64),
                  ),
                ),
              ),
              ...children,
            ],
          ),
        );
      }),
    );
  }
}
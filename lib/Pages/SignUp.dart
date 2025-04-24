import 'package:flutter/material.dart';
import '../component/CustomTextInput.dart'; // Import the CustomTextInput component

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(""),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Register Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Complete your details or continue \nwith social media",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const SignUpForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.red),
                        press: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SocalCard(
                          icon: const Icon(Icons.facebook, size: 32, color: Colors.blue),
                          press: () {},
                        ),
                      ),
                      SocalCard(
                        icon: const Icon(Icons.alternate_email, size: 32, color: Colors.lightBlue),
                        press: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "By continuing your confirm that you agree \nwith our Term and Condition",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF757575),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          CustomTextInput(
            hintText: "Enter your email",
            labelText: "Email",
            suffixIcon: const Icon(Icons.email, color: Color(0xFF757575)),
            textInputAction: TextInputAction.next,
            onChanged: (email) {
              // Handle email input change
            },
            onSaved: (email) {
              // Handle email save
            },
          ),
          const SizedBox(height: 24),
          CustomTextInput(
            hintText: "Enter your password",
            labelText: "Password",
            suffixIcon: const Icon(Icons.lock, color: Color(0xFF757575)),
            obscureText: true,
            textInputAction: TextInputAction.next,
            onChanged: (password) {
              // Handle password input change
            },
            onSaved: (password) {
              // Handle password save
            },
          ),
          const SizedBox(height: 24),
          CustomTextInput(
            hintText: "Re-enter your password",
            labelText: "Re-enter Password",
            suffixIcon: const Icon(Icons.lock, color: Color(0xFF757575)),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onChanged: (password) {
              // Handle password input change
            },
            onSaved: (password) {
              // Handle password save
            },
          ),
          const SizedBox(height: 32),
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
          )
        ],
      ),
    );
  }
}

class SocalCard extends StatelessWidget {
  const SocalCard({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 56,
        width: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: Center(child: icon),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../Components/CustomTextInput.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

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
            onChanged: (email) {},
            onSaved: (email) {},
          ),
          const SizedBox(height: 24),
          CustomTextInput(
            hintText: "Enter your password",
            labelText: "Password",
            suffixIcon: const Icon(Icons.lock, color: Color(0xFF757575)),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onChanged: (password) {},
            onSaved: (password) {},
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
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
        ],
      ),
    );
  }
}
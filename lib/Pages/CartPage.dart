import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/customAppBar.dart';

class CartPage extends StatefulWidget {
  final dynamic yogaClass;

  const CartPage({super.key, this.yogaClass});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cart = [];
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.yogaClass != null) {
      cart.add(widget.yogaClass);
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> submitCart() async {
    final email = emailController.text;

    // Validate email
    if (email.isEmpty || !isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    // Check if cart is empty
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your cart is empty")),
      );
      return;
    }

    try {
      // Send data to Firebase
      final response = await http.post(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/bookings.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'classes': cart.map((c) => {
                'classId': c['id'],
                'type': c['type'],
                'day': c['day'],
                'time': c['time'],
                'price': c['price'],
              }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking submitted successfully")),
        );
        setState(() {
          cart.clear();
          emailController.clear(); // Clear email field
        });
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit booking: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      // Handle network or other errors
      print("Error submitting cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Shopping Cart",
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text("Your cart is empty")) // Empty cart message
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final yogaClass = cart[index];
                      return ListTile(
                        title: Text(yogaClass['type']), // Use 'type' instead of 'name'
                        subtitle: Text("${yogaClass['day']} at ${yogaClass['time']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              cart.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: submitCart,
            child: const Text("Submit Booking"),
          ),
        ],
      ),
    );
  }
}
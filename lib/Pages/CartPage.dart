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
  List<dynamic> bookings = []; // List to store all bookings
  final TextEditingController emailController = TextEditingController();
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    if (widget.yogaClass != null) {
      cart.add(widget.yogaClass);
    }
    fetchBookings(); // Fetch all bookings from Firebase
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> fetchBookings() async {
    try {
      final response = await http.get(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/bookings.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          // Convert the Firebase response into a list
          final List<dynamic> fetchedBookings = data.entries.map((entry) {
            return {
              'id': entry.key, // Firebase unique key
              ...entry.value, // Booking details
            };
          }).toList();

          setState(() {
            bookings = fetchedBookings;
            isLoading = false;
          });
        } else {
          setState(() {
            bookings = [];
            isLoading = false;
          });
        }
      } else {
        print("Failed to fetch bookings: ${response.reasonPhrase}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
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
      for (var yogaClass in cart) {
        final response = await http.post(
          Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/bookings.json'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'classId': yogaClass['id'],
            'type': yogaClass['type'],
            'day': yogaClass['day'],
            'time': yogaClass['time'],
            'price': yogaClass['price'],
          }),
        );

        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to submit booking: ${response.reasonPhrase}")),
          );
          return;
        }
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking submitted successfully")),
      );
      setState(() {
        cart.clear();
        emailController.clear(); // Clear email field
      });

      // Refresh bookings after submission
      fetchBookings();
    } catch (e) {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                Expanded(
                  child: bookings.isEmpty
                      ? const Center(child: Text("No bookings found")) // Empty bookings message
                      : ListView.builder(
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            return ListTile(
                              title: Text(booking['type']),
                              subtitle: Text("${booking['day']} at ${booking['time']}"),
                              trailing: Text("£${booking['price']}"),
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
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/customAppBar.dart';
import '../component/BookingCard.dart'; // Import the BookingCard component

class CartPage extends StatefulWidget {
  final Map<String, dynamic>? yogaClass; // Add yogaClass as an optional parameter

  const CartPage({super.key, this.yogaClass}); // Add yogaClass to the constructor

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> bookings = []; // Ensure bookings is a list of Map<String, dynamic>
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchBookings(); // Fetch all bookings from Firebase
  }

  Future<void> fetchBookings() async {
    try {
      final response = await http.get(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/bookings.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          // Convert the Firebase response into a list of Map<String, dynamic>
          final List<Map<String, dynamic>> fetchedBookings = data.entries.map((entry) {
            return {
              'id': entry.key, // Firebase unique key
              ...Map<String, dynamic>.from(entry.value), // Ensure the value is cast to Map<String, dynamic>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Bookings",
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : bookings.isEmpty
              ? const Center(child: Text("No bookings found")) // Empty bookings message
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return BookingCard(
                      booking: booking,
                      onSlideToBook: () {
                        // Handle slide to book functionality here
                      },
                    );
                  },
                ),
    );
  }
}
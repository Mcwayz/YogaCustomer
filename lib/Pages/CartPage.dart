import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/customAppBar.dart';
import '../component/BookingCard.dart'; // Import the BookingCard component

class CartPage extends StatefulWidget {
  
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> bookings = []; // List to store bookings
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchBookings(); // Fetch bookings from Firebase
  }

  Future<void> fetchBookings() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.get(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/bookings.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          // Convert Firebase response into a list of Map<String, dynamic>
          final List<Map<String, dynamic>> fetchedBookings = data.entries.map((entry) {
            return {
              'id': entry.key, // Firebase unique key
              ...Map<String, dynamic>.from(entry.value), // Ensure proper typing
            };
          }).toList();

          setState(() {
            bookings = fetchedBookings;
          });
        } else {
          setState(() {
            bookings = [];
          });
        }
      } else {
        print("Failed to fetch bookings: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> moveToBooked(String bookingId, Map<String, dynamic> booking) async {
    try {
      // Send the booking to the "Booked" node
      final response = await http.post(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/Booked.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(booking),
      );

      if (response.statusCode == 200) {
        // Remove the booking from the "bookings" node
        await http.delete(
          Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/bookings/$bookingId.json'),
        );

        // Refresh the bookings list
        fetchBookings();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking moved to Booked successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to move booking: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      print("Error moving booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
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
                      onSlideToBook: () => moveToBooked(booking['id'], booking),
                    );
                  },
                ),
    );
  }
}
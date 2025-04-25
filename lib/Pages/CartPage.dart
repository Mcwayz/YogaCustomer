import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/customAppBar.dart';
import '../component/BookingCard.dart'; // Import the new BookingCard component

class CartPage extends StatefulWidget {
   final dynamic yogaClass; 
  const CartPage({super.key, this.yogaClass});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> bookings = []; // List to store all bookings
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
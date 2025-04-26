import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/customAppBar.dart';
import '../component/BookingCard.dart';

class CartPage extends StatefulWidget {
  final Map<String, dynamic>? yogaClass;

  const CartPage({super.key, this.yogaClass});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.yogaClass != null) {
      addToCart(widget.yogaClass!);
    }
    fetchBookings();
  }
    // Reauthenticate the user
  Future<void> reauthenticateUser(String email, String password) async {
    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
      print("Reauthentication successful");
    } catch (e) {
      print("Error reauthenticating user: $e");
    }
  }
  // Fetch bookings from Firebase
  Future<void> fetchBookings() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/cart.json'),
      );
      print("Fetched bookings response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data is Map) {
          final List<Map<String, dynamic>> fetchedBookings = data.entries.map((entry) {
            final bookingData = Map<String, dynamic>.from(entry.value);
            return {
              'id': entry.key.toString(), // Force id as String
              ...bookingData,
              'classId': bookingData['id'], // Keep original id if needed
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
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Add a class to the cart
  Future<void> addToCart(Map<String, dynamic> yogaClass) async {
    try {
      final yogaClassCopy = Map<String, dynamic>.from(yogaClass);
      yogaClassCopy.remove('id'); // Remove id before posting

      final response = await http.post(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/cart.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(yogaClassCopy),
      );

      if (response.statusCode == 200) {
        fetchBookings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Class added to cart successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add to cart: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      print("Error adding to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  // Move booking to "Booked" and remove from cart
  Future<void> moveToBooked(String bookingId, Map<String, dynamic> booking) async {
    try {
      final response = await http.post(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/Booked.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(booking),
      );

      if (response.statusCode == 200) {
        await http.delete(
          Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/cart/$bookingId.json'),
        );
        fetchBookings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booked successfully!")),
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

  Future<void> deleteFromCart(String firebaseKey) async {
  print("Deleting booking with key: $firebaseKey");

  try {
    final response = await http.delete(
      Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/cart/$firebaseKey.json'),
    );

    if (response.statusCode == 200) {
      fetchBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deleted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete: ${response.reasonPhrase}")),
      );
    }
  } catch (e) {
    print("Error deleting booking: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("An error occurred while deleting.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Cart",
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(child: Text("Your cart is empty"))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    print("Booking ID: ${booking['id']}, Type: ${booking['id'].runtimeType}");

                    return BookingCard(
                      booking: booking,
                      onSlideToBook: () => moveToBooked(booking['id'], booking),
                      onDelete: () => deleteFromCart(booking['id']),
                    );
                  },
                ),
    );
  }
}

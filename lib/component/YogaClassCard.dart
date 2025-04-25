import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YogaClassCard extends StatelessWidget {
  final Map<String, dynamic> yogaClass;
  final VoidCallback onAddToCart;

  const YogaClassCard({
    super.key,
    required this.yogaClass,
    required this.onAddToCart,
  });

  Future<void> addToCart(BuildContext context) async {
    try {
      // Make a POST request to add the yoga class to the bookings node
      final response = await http.post(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/bookings.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'classId': yogaClass['id'], // Add the class ID
          'type': yogaClass['type'], // Add the class type
          'day': yogaClass['day'], // Add the class day
          'time': yogaClass['time'], // Add the class time
          'price': yogaClass['price'], // Add the class price
        }),
      );

      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Class added to cart successfully!")),
        );
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add class to cart: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      // Handle network or other errors
      print("Error adding to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safely access all class instances if available
    final classInstances = (yogaClass['class_instances'] != null)
        ? (yogaClass['class_instances'] is Map
            ? yogaClass['class_instances'].values.toList()
            : yogaClass['class_instances'] is List
                ? yogaClass['class_instances']
                    .where((instance) => instance != null) // Filter out null entries
                    .toList()
                : [])
        : [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Reduced margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Slightly smaller border radius
      ),
      elevation: 2, // Reduced elevation for a flatter look
      child: SingleChildScrollView( // Added ScrollView
        child: Padding(
          padding: const EdgeInsets.all(18.0), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Class Type
              Text(
                yogaClass['type'] ?? "Unknown Type",
                style: const TextStyle(
                  fontSize: 16, // Slightly smaller font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6), // Reduced spacing
              // Class Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Day: ${yogaClass['day'] ?? "Unknown"}",
                    style: const TextStyle(
                      fontSize: 13,
                      //color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Time: ${yogaClass['time'] ?? "Unknown"}",
                    style: const TextStyle(
                      fontSize: 13,
                      //color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4), // Reduced spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Capacity: ${yogaClass['capacity'] ?? "Unknown"}",
                    style: const TextStyle(
                      fontSize: 13,
                      //color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Price: £${yogaClass['price'] ?? "Unknown"}",
                    style: const TextStyle(
                      fontSize: 13,
                      //color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Reduced spacing
              // Display all class instances
              if (classInstances.isNotEmpty)
                ...classInstances.map((instance) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Teacher: ${instance['teacher'] ?? "Unknown"}",
                        style: const TextStyle(
                          fontSize: 13,
                          //color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Comments: ${instance['comments'] ?? "None"}",
                        style: const TextStyle(
                          fontSize: 13,
                          //color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Date: ${instance['date'] ?? "Unknown Date"}",
                        style: const TextStyle(
                          fontSize: 13,
                         // color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4), // Spacing between instances
                    ],
                  );
                }).toList()
              else
                Text(
                  "No class instances available for ${yogaClass['type'] ?? "this class"}",
                  style: const TextStyle(
                    fontSize: 13,
                    //color: Colors.grey,
                  ),
                ),
              //const SizedBox(height: 4), // Reduced spacing
              // Add to Cart Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => addToCart(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7643),
                    minimumSize: const Size(100, 36), // Compact button size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 12), // Smaller font size for the button
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
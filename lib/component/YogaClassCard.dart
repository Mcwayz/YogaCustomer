import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YogaClassCard extends StatelessWidget {
  final Map<String, dynamic> yogaClass;
  final VoidCallback onAddToCart;
  final VoidCallback? onDelete; // Optional callback for delete functionality

  const YogaClassCard({
    super.key,
    required this.yogaClass,
    required this.onAddToCart,
    this.onDelete,
  });

  Future<void> addToCart(BuildContext context) async {
    try {
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

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Class added to cart successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add class to cart: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      print("Error adding to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  Future<void> deleteFromCart(BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/cart/${yogaClass['id']}.json'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Class removed from cart successfully!")),
        );

        // Trigger the optional onDelete callback if provided
        if (onDelete != null) {
          onDelete!();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete class: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      print("Error deleting from cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final classInstances = (yogaClass['class_instances'] != null)
        ? (yogaClass['class_instances'] is Map
            ? yogaClass['class_instances'].values.toList()
            : yogaClass['class_instances'] is List
                ? yogaClass['class_instances']
                    .where((instance) => instance != null)
                    .toList()
                : [])
        : [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                yogaClass['type'] ?? "Unknown Type",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Day: ${yogaClass['day'] ?? "Unknown"}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    "Time: ${yogaClass['time'] ?? "Unknown"}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Capacity: ${yogaClass['capacity'] ?? "Unknown"}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    "Price: £${yogaClass['price'] ?? "Unknown"}",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (classInstances.isNotEmpty)
                ...classInstances.map((instance) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Teacher: ${instance['teacher'] ?? "Unknown"}",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        "Comments: ${instance['comments'] ?? "None"}",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        "Date: ${instance['date'] ?? "Unknown Date"}",
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                    ],
                  );
                }).toList()
              else
                Text(
                  "No class instances available for ${yogaClass['type'] ?? "this class"}",
                  style: const TextStyle(fontSize: 13),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => addToCart(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7643),
                      minimumSize: const Size(100, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => deleteFromCart(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(100, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
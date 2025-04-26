import 'package:flutter/material.dart';

class BookedClassCard extends StatelessWidget {
  final Map<String, dynamic> yogaClass; // Data for the booked class
  final VoidCallback? onDelete; // <-- Add onDelete callback

  const BookedClassCard({
    super.key,
    required this.yogaClass,
    this.onDelete, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  yogaClass['type'] ?? "Unknown Type",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete, // <-- Call the delete function
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Day: ${yogaClass['day'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Time: ${yogaClass['time'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Price: £${yogaClass['price'] ?? "Unknown"}",
              style: const TextStyle(fontSize: 14, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

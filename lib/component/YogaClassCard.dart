import 'package:flutter/material.dart';

class YogaClassCard extends StatelessWidget {
  final Map<String, dynamic> yogaClass;
  final VoidCallback onAddToCart;

  const YogaClassCard({
    super.key,
    required this.yogaClass,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Safely access the first class instance if available
    final classInstance = (yogaClass['class_instances'] != null &&
            yogaClass['class_instances'] is List &&
            yogaClass['class_instances'].isNotEmpty)
        ? yogaClass['class_instances'][0]
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Reduced margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Slightly smaller border radius
      ),
      elevation: 2, // Reduced elevation for a flatter look
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding
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
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Time: ${yogaClass['time'] ?? "Unknown"}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4), // Reduced spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Teacher: ${classInstance?['teacher'] ?? "Unknown"}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Capacity: ${yogaClass['capacity'] ?? "Unknown"}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4), // Reduced spacing
            Text(
              "Comments: ${classInstance?['comments'] ?? "None"}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4), // Reduced spacing
            Text(
              "Date: ${classInstance?['date'] ?? "Unknown Date"}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8), // Reduced spacing
            // Add to Cart Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onAddToCart,
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
    );
  }
}
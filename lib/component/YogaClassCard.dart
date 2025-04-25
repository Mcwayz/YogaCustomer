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
                  "Day: ${yogaClass['day']}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Time: ${yogaClass['time']}",
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
                  "Teacher: ${yogaClass['class_instances']?.values.first['teacher'] ?? "Unknown"}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Capacity: ${yogaClass['capacity']}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4), // Reduced spacing
            Text(
              "Comments: ${yogaClass['class_instances']?.values.first['comments'] ?? "None"}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4), // Reduced spacing
            Text(
              "Date: ${yogaClass['class_instances']?.values.first['date'] ?? "Unknown Date"}",
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
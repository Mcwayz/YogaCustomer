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
    // Safely access all class instances if available
    final classInstances = (yogaClass['class_instances'] != null && yogaClass['class_instances'] is List)
        ? yogaClass['class_instances']
            .where((instance) => instance != null) // Filter out null entries
            .toList()
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
                yogaClass['infoSummary'] ?? "Unknown Type",
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
              // Display all class instances dynamically or fallback to description
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description: ${yogaClass['description'] ?? "No description available"}",
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Details: ${yogaClass['detailsSummary'] ?? "No details available"}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: onAddToCart,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
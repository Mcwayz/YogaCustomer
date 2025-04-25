import 'package:flutter/material.dart';

class YogaClassTable extends StatelessWidget {
  final Map<String, dynamic> yogaClass;
  final VoidCallback onAddToCart;

  const YogaClassTable({
    super.key,
    required this.yogaClass,
    required this.onAddToCart,
  });

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class Type as a Header
          Text(
            yogaClass['type'] ?? "Unknown Type",
            style: const TextStyle(
              fontSize: 16, // Slightly larger font size for the header
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8), // Spacing before the table
          // Table Design
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1), // First column takes 1 part of the space
              1: FlexColumnWidth(2), // Second column takes 2 parts of the space
            },
            border: TableBorder.all(color: Colors.grey, width: 0.5), // Add borders to the table
            children: [
              // Table Header
              const TableRow(
                decoration: BoxDecoration(color: Color(0xFFF5F5F5)), // Light grey background
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Field",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Value",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              // Table Rows for Class Details
              _buildTableRow("Day", yogaClass['day'] ?? "Unknown"),
              _buildTableRow("Time", yogaClass['time'] ?? "Unknown"),
              _buildTableRow("Capacity", yogaClass['capacity']?.toString() ?? "Unknown"),
              _buildTableRow("Price", "£${yogaClass['price'] ?? "Unknown"}"),
              // Display the first class instance if available
              if (classInstances.isNotEmpty) ...[
                _buildTableRow("Teacher", classInstances.first['teacher'] ?? "Unknown"),
                _buildTableRow("Date", classInstances.first['date'] ?? "Unknown Date"),
                _buildTableRow("Comments", classInstances.first['comments'] ?? "None"),
              ] else
                _buildTableRow("Class Instances", "No class instances available"),
            ],
          ),
          const SizedBox(height: 8), // Spacing before the button
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
    );
  }

  // Helper method to build a table row
  TableRow _buildTableRow(String field, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            field,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
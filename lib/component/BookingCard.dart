import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking; // Booking details
  final VoidCallback onSlideToBook; // Callback for booking
  final VoidCallback onDelete; // Callback for deleting

  const BookingCard({
    super.key,
    required this.booking,
    required this.onSlideToBook,
    required this.onDelete, // Add onDelete parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking['type'] ?? "Unknown Type",
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
                  "Day: ${booking['day'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  "Time: ${booking['time'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Price: £${booking['price'] ?? "Unknown"}",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onSlideToBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7643),
                  ),
                  child: const Text("Book"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
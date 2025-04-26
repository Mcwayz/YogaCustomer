import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking; // Booking details
  final VoidCallback onSlideToBook; // Callback for booking
  final VoidCallback onDelete; // Callback for deleting

  const BookingCard({
    super.key,
    required this.booking,
    required this.onSlideToBook,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Reduced margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Slightly rounded corners
      ),
      elevation: 2, // Subtle shadow for a clean look
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Compact padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display booking type and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking['type'] ?? "Unknown Type",
                  style: const TextStyle(
                    fontSize: 16, // Slightly larger font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "£${booking['price'] ?? "Unknown"}",
                  style: const TextStyle(
                    fontSize: 16, // Slightly larger font size
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Display booking day and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Day: ${booking['day'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Time: ${booking['time'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Action buttons for booking and deleting
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onSlideToBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Green color for "Book"
                    minimumSize: const Size(90, 36), // Adjusted button size
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Book",
                    style: TextStyle(fontSize: 14), // Adjusted font size
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for "Delete"
                    minimumSize: const Size(90, 36), // Adjusted button size
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Delete",
                    style: TextStyle(fontSize: 14), // Adjusted font size
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
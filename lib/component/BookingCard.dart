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
      elevation: 1, // Subtle shadow for a clean look
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Compact padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking['type'] ?? "Unknown Type",
                  style: const TextStyle(
                    fontSize: 14, // Smaller font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "£${booking['price'] ?? "Unknown"}",
                  style: const TextStyle(
                    fontSize: 14, // Smaller font size
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Day: ${booking['day'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "Time: ${booking['time'] ?? "Unknown"}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onSlideToBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 156, 219, 162),
                    minimumSize: const Size(80, 30), // Smaller button size
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Book",
                    style: TextStyle(fontSize: 12), // Smaller font size
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(80, 30), // Smaller button size
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Delete",
                    style: TextStyle(fontSize: 12), // Smaller font size
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
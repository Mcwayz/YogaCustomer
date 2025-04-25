import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/customAppBar.dart';

class BookedClassesPage extends StatefulWidget {
  const BookedClassesPage({super.key});

  @override
  State<BookedClassesPage> createState() => _BookedClassesPageState();
}

class _BookedClassesPageState extends State<BookedClassesPage> {
  List<Map<String, dynamic>> bookedClasses = []; // List to store booked classes
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchBookedClasses();
  }
Future<void> fetchBookedClasses() async {
  setState(() {
    isLoading = true; // Show loading indicator
  });

  try {
    final response = await http.get(
      Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/Booked.json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched data: $data"); // Debug log

      if (data != null) {
        if (data is Map) {
          // Handle Map structure
          final List<Map<String, dynamic>> fetchedClasses = data.entries.map((entry) {
            return {
              'id': entry.key,
              ...Map<String, dynamic>.from(entry.value),
            };
          }).toList();

          setState(() {
            bookedClasses = fetchedClasses;
          });
        } else if (data is List) {
          // Handle List structure
          final List<Map<String, dynamic>> fetchedClasses = data.map((item) {
            return Map<String, dynamic>.from(item);
          }).toList();

          setState(() {
            bookedClasses = fetchedClasses;
          });
        } else {
          setState(() {
            bookedClasses = [];
          });
        }
      } else {
        setState(() {
          bookedClasses = [];
        });
      }
    } else {
      print("Failed to fetch booked classes: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("Error fetching booked classes: $e");
  } finally {
    setState(() {
      isLoading = false; // Hide loading indicator
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Booked Classes",
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : bookedClasses.isEmpty
              ? const Center(child: Text("No booked classes found")) // Empty state message
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true, // Ensures the ListView takes only the necessary space
                        physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling
                        itemCount: bookedClasses.length,
                        itemBuilder: (context, index) {
                          final yogaClass = bookedClasses[index];
                          return ListTile(
                            title: Text(yogaClass['type'] ?? "Unknown Type"),
                            subtitle: Text("${yogaClass['day']} at ${yogaClass['time']}"),
                            trailing: Text("£${yogaClass['price']}"),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
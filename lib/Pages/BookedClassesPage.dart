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
        if (data != null) {
          // Convert Firebase response into a list of Map<String, dynamic>
          final List<Map<String, dynamic>> fetchedClasses = data.entries.map((entry) {
            return {
              'id': entry.key, // Firebase unique key
              ...Map<String, dynamic>.from(entry.value), // Ensure proper typing
            };
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
              : ListView.builder(
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
    );
  }
}
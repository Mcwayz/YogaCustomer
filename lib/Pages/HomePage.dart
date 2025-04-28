import 'package:flutter/material.dart';
import '../component/customAppBar.dart';
import '../component/YogaClassCard.dart'; // Import the new component
import 'CartPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> yogaClasses = [];
  List<dynamic> filteredClasses = [];
  String searchQuery = "";
  bool isLoading = true; // Added for loading indicator

  @override
  void initState() {
    super.initState();
    fetchYogaClasses();
  }

    Future<void> fetchYogaClasses() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    try {
      final response = await http.get(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/courses.json'),
      );
  
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
  
          if (data != null && data is Map<String, dynamic>) {
            // Convert the Map to a List and ensure proper typing
            final List<Map<String, dynamic>> validClasses = data.entries.map((entry) {
              return {
                'id': entry.key, // Add the key as an ID
                ...Map<String, dynamic>.from(entry.value), // Ensure proper typing
              };
            }).toList();
  
            if (!mounted) return; // Check if the widget is still mounted
            setState(() {
              yogaClasses = validClasses;
              filteredClasses = validClasses;
            });
            print("Fetched classes: $validClasses"); // Debug log
          } else {
            if (!mounted) return; // Check if the widget is still mounted
            setState(() {
              yogaClasses = [];
              filteredClasses = [];
            });
            print("No classes found in the database.");
          }
        } catch (e) {
          print("Error parsing JSON: $e");
        }
      } else {
        throw Exception("Failed to fetch classes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching classes: $e");
    } finally {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }
  void filterClasses(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredClasses = yogaClasses.where((classItem) {
        final day = classItem['day'].toLowerCase();
        final time = classItem['time'].toLowerCase();
        return day.contains(searchQuery) || time.contains(searchQuery);
      }).toList();
    });
  }

  void addToCart(dynamic yogaClass) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(yogaClass: yogaClass)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Yoga Classes",
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Search by day or time",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: filterClasses,
                  ),
                ),
                Expanded(
                  child: filteredClasses.isEmpty
                      ? const Center(child: Text("No classes found")) // Empty state message
                      : ListView.builder(
                          itemCount: filteredClasses.length,
                          itemBuilder: (context, index) {
                            final yogaClass = filteredClasses[index];
                            return YogaClassCard(
                              yogaClass: yogaClass,
                              onAddToCart: () => addToCart(yogaClass),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
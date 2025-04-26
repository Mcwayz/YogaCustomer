import 'package:flutter/material.dart';
import '../component/customAppBar.dart';
import '../component/YogaClassCard.dart'; // Import the new component
import 'MainNavigation.dart'; // Import MainNavigation
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
        final List<dynamic> classes = json.decode(response.body);
        // Filter out null entries
        final List<dynamic> validClasses = classes.where((classItem) => classItem != null).toList();
        setState(() {
          yogaClasses = validClasses;
          filteredClasses = validClasses;
        });
        print("Fetched classes: $validClasses"); // Debug log
      } else {
        throw Exception("Failed to fetch classes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching classes: $e"); // Log error to the terminal
    } finally {
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigation(initialIndex: 1), // Navigate to Cart tab
      ),
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
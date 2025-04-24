import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    fetchYogaClasses();
  }

  Future<void> fetchYogaClasses() async {
    final response = await http.get(Uri.parse('https://your-cloud-service/api/classes'));
    if (response.statusCode == 200) {
      setState(() {
        yogaClasses = json.decode(response.body);
        filteredClasses = yogaClasses;
      });
    } else {
      print("Failed to fetch classes");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yoga Classes"),
      ),
      body: Column(
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
            child: ListView.builder(
              itemCount: filteredClasses.length,
              itemBuilder: (context, index) {
                final yogaClass = filteredClasses[index];
                return ListTile(
                  title: Text(yogaClass['name']),
                  subtitle: Text("${yogaClass['day']} at ${yogaClass['time']}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Add to cart logic
                    },
                    child: const Text("Add to Cart"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'CartPage.dart';
import 'BookedClassesPage.dart';
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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchYogaClasses();
  }

  Future<void> fetchYogaClasses() async {
    final response = await http.get(Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/courses'));
    if (response.statusCode == 200) {
      setState(() {
        yogaClasses = json.decode(response.body);
        filteredClasses = yogaClasses;
      });
    } else {
      // Handle error
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

  void addToCart(dynamic yogaClass) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(yogaClass: yogaClass)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Stay on HomePage
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookedClassesPage()),
      );
    }
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
                    onPressed: () => addToCart(yogaClass),
                    child: const Text("Add to Cart"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
<<<<<<< HEAD
=======

>>>>>>> ed40b4bf01d70cac366a4c649bf1cb407e9b8f5f
    );
  }
}
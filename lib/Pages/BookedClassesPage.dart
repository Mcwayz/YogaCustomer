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
  List<dynamic> bookedClasses = [];

  @override
  void initState() {
    super.initState();
    fetchBookedClasses();
  }

  Future<void> fetchBookedClasses() async {
    final response = await http.get(Uri.parse('https://your-cloud-service/api/booked-classes'));
    if (response.statusCode == 200) {
      setState(() {
        bookedClasses = json.decode(response.body);
      });
    } else {
      print("Failed to fetch booked classes");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Booked Classes",
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: bookedClasses.length,
        itemBuilder: (context, index) {
          final yogaClass = bookedClasses[index];
          return ListTile(
            title: Text(yogaClass['name']),
            subtitle: Text("${yogaClass['day']} at ${yogaClass['time']}"),
          );
        },
      ),
    );
  }
}
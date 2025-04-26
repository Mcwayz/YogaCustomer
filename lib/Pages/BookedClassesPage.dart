import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../component/customAppBar.dart';
import '../component/BookedClassCard.dart';

class BookedClassesPage extends StatefulWidget {
  const BookedClassesPage({super.key});

  @override
  State<BookedClassesPage> createState() => _BookedClassesPageState();
}

class _BookedClassesPageState extends State<BookedClassesPage> {
  List<Map<String, dynamic>> bookedClasses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookedClasses();
  }

  Future<void> fetchBookedClasses() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/Booked.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data is Map) {
          final List<Map<String, dynamic>> fetchedClasses = data.entries.map((entry) {
            final classData = Map<String, dynamic>.from(entry.value);
            return {
              'firebaseKey': entry.key, // Save firebase key here too
              ...classData,
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
        isLoading = false;
      });
    }
  }

  Future<void> deleteBookedClass(String firebaseKey) async {
    print("Deleting booked class with key: $firebaseKey");

    try {
      final response = await http.delete(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/Booked/$firebaseKey.json'),
      );

      if (response.statusCode == 200) {
        fetchBookedClasses();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booked class deleted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      print("Error deleting booked class: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
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
          ? const Center(child: CircularProgressIndicator())
          : bookedClasses.isEmpty
              ? const Center(child: Text("No booked classes found"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bookedClasses.length,
                        itemBuilder: (context, index) {
                          final yogaClass = bookedClasses[index];
                          return BookedClassCard(
                            yogaClass: yogaClass,
                            onDelete: () => deleteBookedClass(yogaClass['firebaseKey']),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}

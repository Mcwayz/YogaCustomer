import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

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
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      final response = await http.get(
        Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/users/$uid/booked.json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data is Map) {
          final List<Map<String, dynamic>> fetchedClasses = data.entries.map((entry) {
            return {
              'id': entry.key,
              ...Map<String, dynamic>.from(entry.value),
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

  Future<void> deleteClass(String classId, int index) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      final deleteUrl = Uri.parse('https://universal-yoga-8f236-default-rtdb.firebaseio.com/users/$uid/booked/$classId.json');
      final response = await http.delete(deleteUrl);

      if (response.statusCode == 200) {
        setState(() {
          bookedClasses.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Class deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print('Error deleting class: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while deleting')),
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
                            onDelete: () async {
                              final classId = yogaClass['id'];
                              if (classId != null) {
                                await deleteClass(classId, index);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
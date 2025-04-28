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
            return {
              'firebaseKey': entry.key, // Important! Save Firebase Key separately
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

  Future<void> deleteClass(String firebaseKey) async {
    try {
      final deleteUrl = Uri.parse(
        'https://universal-yoga-8f236-default-rtdb.firebaseio.com/Booked/$firebaseKey.json',
      );
      final response = await http.delete(deleteUrl);

      if (response.statusCode == 200) {
        setState(() {
          bookedClasses.removeWhere((element) => element['firebaseKey'] == firebaseKey);
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

  Future<void> confirmDelete(String firebaseKey) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this class?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await deleteClass(firebaseKey);
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
              : ListView.builder(
                  itemCount: bookedClasses.length,
                  itemBuilder: (context, index) {
                    final yogaClass = bookedClasses[index];
                    return BookedClassCard(
                      yogaClass: yogaClass,
                      onDelete: () async {
                        final firebaseKey = yogaClass['firebaseKey'];
                        if (firebaseKey != null) {
                          await confirmDelete(firebaseKey);
                        }
                      },
                    );
                  },
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'CartPage.dart';
import 'BookedClassesPage.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex; // Add an initial index parameter

  const MainNavigation({super.key, this.initialIndex = 0}); // Default to HomePage

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set the initial index
  }

  // List of pages for navigation
  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const BookedClassesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Booked",
          ),
        ],
      ),
    );
  }
}
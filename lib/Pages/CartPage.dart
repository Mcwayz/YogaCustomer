import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  final dynamic yogaClass;

  const CartPage({super.key, this.yogaClass});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cart = [];
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.yogaClass != null) {
      cart.add(widget.yogaClass);
    }
  }

  Future<void> submitCart() async {
    final email = emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://your-cloud-service/api/bookings'),
      body: {
        'email': email,
        'classes': cart.map((c) => c['id']).toList(),
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking submitted successfully")),
      );
      setState(() {
        cart.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit booking")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Shopping Cart",
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final yogaClass = cart[index];
                return ListTile(
                  title: Text(yogaClass['name']),
                  subtitle: Text("${yogaClass['day']} at ${yogaClass['time']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        cart.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: submitCart,
            child: const Text("Submit Booking"),
          ),
        ],
      ),
    );
  }
}
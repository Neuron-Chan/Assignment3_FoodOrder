import 'package:flutter/material.dart';
import 'db_helper.dart';

class QueryOrderScreen extends StatefulWidget {
  const QueryOrderScreen({Key? key}) : super(key: key);

  @override
  _QueryOrderScreenState createState() => _QueryOrderScreenState();
}

class _QueryOrderScreenState extends State<QueryOrderScreen> {
  final TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> orderItems = [];

  // Query order by date
  queryOrderByDate(String date) async {
    final items = await DBHelper.getOrderItemsForDate(date);
    setState(() {
      orderItems = items;
    });
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No orders found for this date.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Query Orders')),
      body: Column(
        children: [
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Enter Date (YYYY-MM-DD)'),
          ),
          ElevatedButton(
            onPressed: () {
              queryOrderByDate(_dateController.text);
            },
            child: const Text('Query Orders'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final order = orderItems[index];
                return ListTile(
                  title: Text('Order ID: ${order['id']}'),
                  subtitle: Text('Date: ${order['date']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'db_helper.dart'; // Make sure to import DBHelper

class QueryOrderScreen extends StatefulWidget {
  @override
  _QueryOrderScreenState createState() => _QueryOrderScreenState();
}

class _QueryOrderScreenState extends State<QueryOrderScreen> {
  TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> orderItems = [];

  // Load the orders based on date
  Future<void> _loadOrders() async {
    final date = _dateController.text;
    if (date.isNotEmpty) {
      final orderList = await DBHelper.getOrderItemsForDate(date);
      setState(() {
        orders = orderList;
      });
    }
  }

  // Load the order items for a selected order
  Future<void> _loadOrderItems(int orderId) async {
    final items = await DBHelper.getOrderItems(orderId);
    setState(() {
      orderItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Query Orders")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Enter Order Date (yyyy-mm-dd)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrders,
              child: Text("Query Orders"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    child: ListTile(
                      title: Text('Order ID: ${order['id']}'),
                      subtitle: Text('Date: ${order['date']}'),
                      onTap: () => _loadOrderItems(order['id']),
                    ),
                  );
                },
              ),
            ),
            if (orderItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Items in this Order:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        final item = orderItems[index];
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text("\$${item['cost']} x ${item['quantity']}"),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

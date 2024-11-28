import 'package:flutter/material.dart';
import 'db_helper.dart';

class UpdateOrderScreen extends StatefulWidget {
  final int orderId;

  const UpdateOrderScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _UpdateOrderScreenState createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  Map<String, dynamic>? order;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  // Load the order to update
  _loadOrder() async {
    final orderData = await DBHelper.getOrderById(widget.orderId);
    setState(() {
      order = orderData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Update Order')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Update Order')),
      body: Column(
        children: [
          Text('Order ID: ${order!['id']}'),
          Text('Date: ${order!['date']}'),
          // Add update logic here
        ],
      ),
    );
  }
}

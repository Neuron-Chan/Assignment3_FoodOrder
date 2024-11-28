import 'package:flutter/material.dart';
import 'db_helper.dart'; // Import DBHelper

class MakeOrderScreen extends StatefulWidget {
  @override
  _MakeOrderScreenState createState() => _MakeOrderScreenState();
}

class _MakeOrderScreenState extends State<MakeOrderScreen> {
  TextEditingController _dateController = TextEditingController();
  List<Map<String, dynamic>> _selectedFoodItems = [];

  // Load food items to display
  Future<List<Map<String, dynamic>>> _loadFoodItems() async {
    return await DBHelper.getFoodItems();
  }

  // Insert the new order plan and associated food items
  Future<void> _submitOrder() async {
    final date = _dateController.text;
    if (date.isNotEmpty && _selectedFoodItems.isNotEmpty) {
      // Insert the order plan
      final orderPlan = {'date': date};
      final orderId = await DBHelper.insertOrderPlan(orderPlan);

      // Insert order items
      for (var item in _selectedFoodItems) {
        final orderItem = {
          'order_id': orderId,
          'food_id': item['id'],
          'quantity': item['quantity']
        };
        await DBHelper.insertOrderItem(orderItem);
      }

      // Display success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order saved successfully!')),
      );

      // Clear the fields after submitting the order
      _dateController.clear();
      setState(() {
        _selectedFoodItems.clear();
      });
    } else {
      // Show error if date or items are missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a date and select food items.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Make Order')),
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadFoodItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No food items available.');
                }

                final foodItems = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final foodItem = foodItems[index];
                      return CheckboxListTile(
                        title: Text(foodItem['name']),
                        subtitle: Text("\$${foodItem['cost']}"),
                        value: _selectedFoodItems
                            .any((item) => item['id'] == foodItem['id']),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedFoodItems.add({
                                'id': foodItem['id'],
                                'quantity': 1, // Default quantity is 1
                              });
                            } else {
                              _selectedFoodItems.removeWhere(
                                      (item) => item['id'] == foodItem['id']);
                            }
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitOrder,
              child: Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}

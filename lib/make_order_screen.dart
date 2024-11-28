import 'package:flutter/material.dart';
import 'db_helper.dart'; // Import your DBHelper file

class MakeOrderScreen extends StatefulWidget {
  @override
  _MakeOrderScreenState createState() => _MakeOrderScreenState();
}

class _MakeOrderScreenState extends State<MakeOrderScreen> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> foodItems = [];
  List<int> selectedFoodIds = [];

  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
    _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Set the initial date to today's date
  }

  Future<void> _loadFoodItems() async {
    final items = await DBHelper.getFoodItems();
    setState(() {
      foodItems = items;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? selectedDate;
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format the date for display
      });
  }

  Future<void> _submitOrder() async {
    if (selectedFoodIds.isEmpty) {
      // Show a message if no food item is selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select at least one food item.")));
      return;
    }

    // Prepare the order data to insert into the database
    final orderId = await DBHelper.insertOrderPlan({
      'date': selectedDate.toIso8601String(),
    });

    for (var foodId in selectedFoodIds) {
      // Insert the food items in the 'order_items' table
      await DBHelper.insertOrderItem({
        'order_id': orderId,
        'food_id': foodId,
      });
    }

    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order saved successfully.")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Make Order")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: "Select Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 20),
            Text("Select Food Items:"),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(foodItems[index]['name']),
                    subtitle: Text("\$${foodItems[index]['cost']}"),
                    value: selectedFoodIds.contains(foodItems[index]['id']),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          selectedFoodIds.add(foodItems[index]['id']);
                        } else {
                          selectedFoodIds.remove(foodItems[index]['id']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitOrder,
              child: Text("Submit Order"),
            ),
          ],
        ),
      ),
    );
  }
}

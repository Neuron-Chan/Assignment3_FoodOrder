import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'food_item.dart';

class MakeOrderScreen extends StatefulWidget {
  @override
  _MakeOrderScreenState createState() => _MakeOrderScreenState();
}

class _MakeOrderScreenState extends State<MakeOrderScreen> {
  List<FoodItem> foodItems = [];
  List<FoodItem> selectedFoodItems = [];
  double targetCost = 0.0;
  String date = '';

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  // Load food items from the database
  _loadFoodItems() async {
    final items = await DBHelper.getFoodItems();
    setState(() {
      foodItems = items;
    });
  }

  // Calculate the total cost of selected food items
  double _calculateTotalCost() {
    double total = 0.0;
    for (var food in selectedFoodItems) {
      total += food.cost;
    }
    return total;
  }

  // Save the selected order plan
  _saveOrderPlan() async {
    if (_calculateTotalCost() > targetCost) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Total cost exceeds target!')));
      return;
    }

    for (var food in selectedFoodItems) {
      await DBHelper.insertOrderPlan({
        'date': date,
        'food_id': food.id,
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Plan Saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Make an Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  targetCost = double.tryParse(value) ?? 0.0;
                });
              },
              decoration: InputDecoration(labelText: 'Target Cost'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  date = value;
                });
              },
              decoration: InputDecoration(labelText: 'Date (yyyy-mm-dd)'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(foodItems[index].name),
                    subtitle: Text('\$${foodItems[index].cost}'),
                    value: selectedFoodItems.contains(foodItems[index]),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected!) {
                          selectedFoodItems.add(foodItems[index]);
                        } else {
                          selectedFoodItems.remove(foodItems[index]);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Cost: \$${_calculateTotalCost()}'),
                ElevatedButton(
                  onPressed: _saveOrderPlan,
                  child: Text('Save Order Plan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

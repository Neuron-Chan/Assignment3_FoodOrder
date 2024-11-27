import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'food_item.dart';

class QueryOrderScreen extends StatefulWidget {
  @override
  _QueryOrderScreenState createState() => _QueryOrderScreenState();
}

class _QueryOrderScreenState extends State<QueryOrderScreen> {
  List<FoodItem> foodItems = [];
  String date = '';
  List<FoodItem> queriedOrderItems = [];

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

  // Query order plan by date
  _loadOrderPlanForDate() async {
    final orderPlans = await DBHelper.getOrderPlanByDate(date);
    setState(() {
      queriedOrderItems.clear();
    });

    for (var order in orderPlans) {
      final foodItem = foodItems.firstWhere((food) => food.id == order['food_id']);
      setState(() {
        queriedOrderItems.add(foodItem);
      });
    }
  }

  // Display the queried order plan for a specific date
  _displayQueriedOrderPlan() {
    if (queriedOrderItems.isEmpty) {
      return Center(child: Text('No orders found for this date.'));
    }
    return ListView.builder(
      itemCount: queriedOrderItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(queriedOrderItems[index].name),
          subtitle: Text('\$${queriedOrderItems[index].cost}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query an Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  date = value;
                });
              },
              decoration: InputDecoration(labelText: 'Date (yyyy-mm-dd)'),
            ),
            ElevatedButton(
              onPressed: _loadOrderPlanForDate,
              child: Text('Query Order Plan for Date'),
            ),
            Expanded(
              child: _displayQueriedOrderPlan(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'food_item.dart';

class DBHelper {
  static Database? _database;

  // Singleton pattern to get the database instance
  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    // Create the database if it doesn't exist
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'food_ordering.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        // Create food_items table
        await db.execute('''
          CREATE TABLE food_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            cost REAL
          );
        ''');

        // Create order_plans table
        await db.execute('''
          CREATE TABLE order_plans(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            food_id INTEGER,
            FOREIGN KEY(food_id) REFERENCES food_items(id)
          );
        ''');

        // Insert 20 predefined food items
        List<Map<String, dynamic>> foodData = [
          {'name': 'Pizza', 'cost': 12.5},
          {'name': 'Burger', 'cost': 8.0},
          {'name': 'Pasta', 'cost': 10.0},
          {'name': 'Salad', 'cost': 5.5},
          {'name': 'Sushi', 'cost': 15.0},
          {'name': 'Fried Rice', 'cost': 7.0},
          {'name': 'Ice Cream', 'cost': 4.0},
          {'name': 'Fries', 'cost': 3.0},
          {'name': 'Tacos', 'cost': 6.5},
          {'name': 'Sandwich', 'cost': 5.0},
          {'name': 'Steak', 'cost': 20.0},
          {'name': 'Chicken Wings', 'cost': 9.0},
          {'name': 'Noodles', 'cost': 8.5},
          {'name': 'Pancakes', 'cost': 7.5},
          {'name': 'Soup', 'cost': 4.5},
          {'name': 'Grilled Cheese', 'cost': 6.0},
          {'name': 'Hot Dog', 'cost': 3.5},
          {'name': 'Burrito', 'cost': 7.0},
          {'name': 'Smoothie', 'cost': 5.0},
          {'name': 'Curry', 'cost': 11.0},
        ];

        // Insert predefined food items into the food_items table
        for (var food in foodData) {
          await db.insert(
            'food_items',
            food,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      },
      version: 1,
    );
  }

  // Fetch all food items from the database
  static Future<List<FoodItem>> getFoodItems() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('food_items');
    return List.generate(maps.length, (i) {
      return FoodItem.fromMap(maps[i]);
    });
  }

  // Insert a new order plan into the database
  static Future<void> insertOrderPlan(Map<String, dynamic> orderPlan) async {
    final db = await getDatabase();
    await db.insert(
      'order_plans',
      orderPlan,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get order plan by date
  static Future<List<Map<String, dynamic>>> getOrderPlanByDate(String date) async {
    final db = await getDatabase();
    return await db.query(
      'order_plans',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  // Update an existing order plan entry
  static Future<void> updateOrderPlan(int id, Map<String, dynamic> updatedOrder) async {
    final db = await getDatabase();
    await db.update(
      'order_plans',
      updatedOrder,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete an existing order plan entry
  static Future<void> deleteOrderPlan(int id) async {
    final db = await getDatabase();
    await db.delete(
      'order_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

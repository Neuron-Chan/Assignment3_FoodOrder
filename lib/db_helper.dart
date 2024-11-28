import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Initialize the database
  static Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'food_order.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        cost REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        food_id INTEGER,
        quantity INTEGER,
        FOREIGN KEY (order_id) REFERENCES order_plans(id),
        FOREIGN KEY (food_id) REFERENCES food_items(id)
      )
    ''');

    // Insert sample food items into the database
    await db.insert('food_items', {'name': 'Pizza', 'cost': 10.99});
    await db.insert('food_items', {'name': 'Burger', 'cost': 5.99});
    await db.insert('food_items', {'name': 'Pasta', 'cost': 8.49});
    await db.insert('food_items', {'name': 'Sushi', 'cost': 15.99});
    await db.insert('food_items', {'name': 'Salad', 'cost': 6.49});
    await db.insert('food_items', {'name': 'Chicken Wings', 'cost': 7.99});
    await db.insert('food_items', {'name': 'Steak', 'cost': 22.99});
    await db.insert('food_items', {'name': 'Fish and Chips', 'cost': 12.49});
    await db.insert('food_items', {'name': 'Tacos', 'cost': 3.99});
    await db.insert('food_items', {'name': 'Cheeseburger', 'cost': 4.99});
    await db.insert('food_items', {'name': 'Lasagna', 'cost': 10.49});
    await db.insert('food_items', {'name': 'Fried Rice', 'cost': 7.49});
    await db.insert('food_items', {'name': 'Grilled Cheese', 'cost': 4.49});
    await db.insert('food_items', {'name': 'Hot Dog', 'cost': 3.49});
    await db.insert('food_items', {'name': 'BBQ Ribs', 'cost': 19.99});
    await db.insert('food_items', {'name': 'Pho', 'cost': 9.99});
    await db.insert('food_items', {'name': 'Burrito', 'cost': 6.99});
    await db.insert('food_items', {'name': 'Falafel', 'cost': 5.49});
    await db.insert('food_items', {'name': 'Peking Duck', 'cost': 25.99});
    await db.insert('food_items', {'name': 'Dim Sum', 'cost': 8.99});
  }

  // Insert an order plan
  static Future<int> insertOrderPlan(Map<String, dynamic> orderPlan) async {
    final db = await getDatabase();
    return await db.insert('order_plans', orderPlan);
  }

  // Insert order items
  static Future<int> insertOrderItem(Map<String, dynamic> orderItem) async {
    final db = await getDatabase();
    return await db.insert('order_items', orderItem);
  }

  // Get food items
  static Future<List<Map<String, dynamic>>> getFoodItems() async {
    final db = await getDatabase();
    return await db.query('food_items');
  }

  // Get order items for a specific date, ensuring no duplicates
  static Future<List<Map<String, dynamic>>> getOrderItemsForDate(String date) async {
    final db = await getDatabase();
    return await db.rawQuery('''
    SELECT DISTINCT order_plans.id, order_plans.date 
    FROM order_plans
    WHERE order_plans.date = ?
  ''', [date]);
  }

  // Get an order by ID
  static Future<Map<String, dynamic>?> getOrderById(int id) async {
    final db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query('order_plans', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Get items for a specific order by its ID
  static Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    final db = await getDatabase();
    return await db.rawQuery('''
    SELECT food_items.name, food_items.cost, order_items.quantity 
    FROM order_items
    INNER JOIN food_items ON order_items.food_id = food_items.id
    WHERE order_items.order_id = ?
  ''', [orderId]);
  }
}

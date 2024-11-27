class FoodItem {
  final int id;
  final String name;
  final double cost;

  FoodItem({
    required this.id,
    required this.name,
    required this.cost,
  });

  // Method to convert a food item from database format (Map) to a FoodItem object
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      cost: map['cost'],
    );
  }

  // Method to convert a FoodItem object into a Map (for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
    };
  }
}

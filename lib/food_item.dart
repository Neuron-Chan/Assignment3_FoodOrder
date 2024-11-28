class FoodItem {
  final int id;
  final String name;
  final double cost;

  FoodItem({required this.id, required this.name, required this.cost});

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      cost: map['cost'],
    );
  }
}

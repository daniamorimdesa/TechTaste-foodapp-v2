class Dish {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imagePath;
  final String restaurantName;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.restaurantName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'restaurantName': restaurantName,
    };
  }

  factory Dish.fromMap(Map<String, dynamic> map) {
    return Dish(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imagePath: map['imagePath'],
      restaurantName: map['restaurantName'],
    );
  }

  @override
  String toString() {
    return 'Dish{id: $id, name: $name, description: $description, price: $price, imagePath: $imagePath, restaurantName: $restaurantName}';
  }
}

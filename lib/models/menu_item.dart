class MenuItem {
  final String name;
  final int price;
  final bool isNonVeg;
  final String? category;
  final String id, restaurantId;
  bool isAvailable;

  MenuItem(
      {required this.name,
      required this.price,
      required this.isNonVeg,
      required this.category,
      required this.id,
      required this.isAvailable,
      required this.restaurantId});
  factory MenuItem.fromJSON(Map<String, dynamic> json, String id) {
    return MenuItem(
        name: json["name"] ?? "Item",
        price: json["price"] ?? 30,
        isNonVeg: json["isNonVeg"] ?? false,
        category: json["category"] ?? "All",
        restaurantId: json["restaurantId"] ?? "resId",
        isAvailable: json['isAvailable'] ?? true,
        id: id);
  }
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "price": price,
      "isNonVeg": isNonVeg,
      "category": category,
      "isAvailable": isAvailable,
    };
  }

  @override
  String toString() {
    return "$name : $price";
  }
}

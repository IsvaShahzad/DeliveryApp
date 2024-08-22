class CartItem {
  late final int? id;
  String name;
  double price;
  String imageUrl;
  int quantity = 1;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  CartItem.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        name = res['name'],
        price = res['price'],
        imageUrl = res['imageUrl'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, price: $price, imageUrl: $imageUrl, quantity: $quantity)';
  }
}

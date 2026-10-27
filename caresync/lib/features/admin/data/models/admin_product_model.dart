class Product {
  String name;
  double price;
  double mrp;
  String image;

  Product({
    required this.name,
    required this.price,
    required this.mrp,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'mrp': mrp,
      'image': image,
    };
  }
}

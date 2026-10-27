class ProductData {
  final String name;
  final String productId;
  final dynamic price;
  dynamic mrp;
  final dynamic image;
  int quantity;

  ProductData({
    required this.name,
    required this.productId,
    required this.price,
    required this.mrp,
    required this.image,
    this.quantity = 1,
  
  });

  //get quantity => null;
}

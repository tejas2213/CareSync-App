class Product {
  final String name;
  final dynamic price;
   dynamic mrp;
  final dynamic image;
 dynamic rating;
  dynamic liked;
  int quantity;
  bool isInCart;

  Product({
    required this.name,
    required this.price,
     this.mrp,
    required this.image,
    this.rating,
    this.liked,
    this.quantity = 1,
    this.isInCart = false, required String id, 
  });
}




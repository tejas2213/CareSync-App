import 'dart:developer';

import 'package:caresync/features/pharmacy/data/models/product_details_model.dart';
import 'package:caresync/features/pharmacy/presentation/pages/cart_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/wishlist_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsPage extends StatefulWidget {
  final String categoryName;
  final dynamic storeId;
  final String patientId;

  const ProductsPage({
    super.key,
    required this.categoryName,
    required this.storeId,
    required this.patientId,
  });

  @override
  State createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<ProductData> productsList = [];
  Map<String, bool> likedProducts = {};
  Map<String, bool> cartProducts = {};
  Map<String, int> productQuantities = {};

  @override
  void initState() {
    super.initState();
    log("STORE ID :- ${widget.storeId}");
    log("CATEGORY NAME  ${widget.categoryName}");
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final productsSnapshot = await FirebaseFirestore.instance
          .collection(
              'Medical Stores/${widget.storeId}/categories/${widget.categoryName}/products')
          .get();

      final wishlistSnapshot = await FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/${widget.patientId}/Wishlist')
          .get();

      final cartSnapshot = await FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/${widget.patientId}/Cart')
          .get();

      // Clear existing lists/maps
      productsList.clear();
      likedProducts.clear();
      cartProducts.clear();
      productQuantities.clear();

      // Create sets and maps for easier lookups
      final wishlistIds = wishlistSnapshot.docs.map((doc) => doc.id).toSet();
      final cartData = cartSnapshot.docs;

      for (var productDoc in productsSnapshot.docs) {
        try {
          final data = productDoc.data();

          // Ensure the document exists and contains data
          if (data.isEmpty) {
            print('Skipping empty or null product data: ${productDoc.id}');
            continue;
          }

          // Safely retrieve fields with defaults
          final productId = productDoc.id;
          final name = data['name'] ?? 'Unknown Product';
          final price = (data['price'] as num?)?.toDouble() ?? 0.0;
          final imageUrl = data['imageUrl'] ?? '';
          final mrp = (data['mrp'] as num?)?.toDouble() ?? 0.0;

          // Add the product to the list
          productsList.add(
            ProductData(
              name: name,
              productId: productId,
              price: price,
              image: imageUrl,
              mrp: mrp,
            ),
          );

          // Check if the product is in the wishlist
          likedProducts[productId] = wishlistIds.contains(productId);

          // Check if the product is in the cart and retrieve quantity
          final cartProduct = cartData.firstWhere(
            (doc) => doc.id == productId,
            //orElse: () => 0,
          );

          cartProducts[productId] = true;
          productQuantities[productId] =
              cartProduct.data()['quantity'] as int? ?? 1; 
                } catch (e) {
          print('Error processing product document (${productDoc.id}): $e');
        }
      }

      // Update the UI
      setState(() {});
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> _updateQuantity(ProductData product, int change) async {
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/${widget.patientId}/Cart');

      // Ensure the product has a default quantity in the map
      productQuantities[product.productId] ??= 0;

      final newQuantity = productQuantities[product.productId]! + change;

      if (newQuantity >= 0) {
        // Update the quantity in Firebase
        await cartRef.doc(product.productId).update({'quantity': newQuantity});
        productQuantities[product.productId] = newQuantity;
      } else {
        // If quantity is less than 0, remove the product from the cart
        await cartRef.doc(product.productId).delete();
        productQuantities.remove(product.productId);
        cartProducts[product.productId] = false;
      }

      setState(() {});
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  Future<void> _toggleCart(ProductData product) async {
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/${widget.patientId}/Cart');

      final productDoc = await cartRef.doc(product.productId).get();

      if (productDoc.exists) {
        // If product exists in cart, remove it
        await cartRef.doc(product.productId).delete();
        cartProducts[product.productId] = false;
      } else {
        // If product doesn't exist, add it to cart with initial quantity
        await cartRef.doc(product.productId).set({
          'name': product.name,
          'price': product.price,
          'mrp': product.mrp,
          'image': product.image,
          'quantity': 1,
        });
        cartProducts[product.productId] = true;
      }

      setState(() {});
    } catch (e) {
      print("Error updating cart: $e");
    }
  }

  Future<void> _toggleLike(ProductData product) async {
    try {
      final wishlistRef = FirebaseFirestore.instance.collection(
          'CareSync/patients/accounts/${widget.patientId}/Wishlist');

      final productDoc = await wishlistRef.doc(product.productId).get();

      if (productDoc.exists) {
        await wishlistRef.doc(product.productId).delete();
        likedProducts[product.productId] = false;
      } else {
        await wishlistRef.doc(product.productId).set({
          'name': product.name,
          'price': product.price,
          'mrp': product.mrp,
          'image': product.image,
        });
        likedProducts[product.productId] = true;
      }

      setState(() {});
    } catch (e) {
      print("Error updating wishlist: $e");
    }
  }

  List<Map<String, String>> categoryUrl = [
    {
      "category": "Baby Care",
      "url": "assets/jpg/BabyCareProduct.jpg",
    },
    {
      "category": "Cough & Cold",
      "url": "assets/png/CoughColdProduct.png",
    },
    {
      "category": "Ayurvedic",
      "url": "assets/jpg/AyurvedicProduct.jpg",
    },
    {
      "category": "Orthopaedics",
      "url": "assets/jpg/OrthopediacsProduct.jpg",
    },
    {
      "category": "Pain Relief",
      "url": "assets/jpg/CategoryCaraiousal/C4.jpg",
    },
     
    {
      "category": "Skin Care",
      "url": "assets/jpg/SkinCareProduct.jpg",
    },
    {
      "category": "Vitamins",
      "url": "assets/jpg/VitaminsProduct.jpg",
    },
    {
      "category": "Fitness",
      "url": "assets/jpg/FitnessProduct.jpg",
    },
    {
      "category": "First Aid",
      "url": "assets/jpg/FirstaidProduct.jpg",
    },
    {
      "category": "General Discomfort",
      "url": "assets/jpg/GeneralDiscomfortProduct.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
            colors: [
              Color.fromRGBO(97, 206, 255, 1),
              Colors.white,
              Colors.white,
              Color.fromRGBO(14, 190, 126, 1),
            ],
          ),
        ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(9.0, screenHeight * 0.06, 9.0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: screenWidth * 0.1,
                          width: screenWidth * 0.1,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Colors.transparent,
                          border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 1),
                              width: 1)),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      widget.categoryName,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.058,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Wishlist(
                              patientId: widget.patientId,
                              onProductChanged: () {
                                fetchProducts();
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite_border_outlined),
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Cart(
                              patientId: widget.patientId,
                              onProductChanged: () {
                                fetchProducts();
                              },
                              storeId: widget.storeId,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  height: screenHeight * 0.13,
                  width: screenWidth * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Builder(
                    builder: (context) {
                      // Find the matching category from the categoryUrl list
                      final category = categoryUrl.firstWhere(
                        (cat) => cat['category'] == widget.categoryName,
                        orElse: () => {
                          'category': 'default',
                          'url': 'assets/jpg/defaultImage.jpg'
                        },
                      );

                      // Display the image from the categoryUrl list
                      return Image.asset(
                        category['url']!,
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(5.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600 ? 2 : 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: productsList.length,
                    itemBuilder: (context, index) {
                      final medicine = productsList[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight*0.01,),
                            Stack(
                              children: [
                                
                                Center(
                                  child: Image.network(
                                    medicine.image,
                                    height: screenWidth * 0.3,
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () => _toggleLike(medicine),
                                    child: Icon(
                                      Icons.favorite,
                                      size: 20,
                                      color:
                                          likedProducts[medicine.productId] ==
                                                  true
                                              ? Colors.red
                                              : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              medicine.name,
                              maxLines: 2,
                              style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₹${medicine.price}',
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'MRP ₹${medicine.mrp}',
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.032,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     const Text("Quantity:"),
                            //     IconButton(
                            //       onPressed: () =>
                            //           _updateQuantity(medicine, -1),
                            //       icon: const Icon(Icons.remove),
                            //     ),
                            //     Text(
                            //       '${productQuantities[medicine.productId] ?? 1}',
                            //       style: GoogleFonts.roboto(),
                            //     ),
                            //     IconButton(
                            //       onPressed: () => _updateQuantity(medicine, 1),
                            //       icon: const Icon(Icons.add),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(height: screenHeight*0.03,),
                            Center(
                              child: ElevatedButton(
                                onPressed: () => _toggleCart(medicine),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      cartProducts[medicine.productId] == true
                                          ? Colors.grey
                                          : const Color.fromRGBO(
                                              14, 190, 127, 1),
                                ),
                                child: Text(
                                  cartProducts[medicine.productId] == true
                                      ? 'Item in Cart'
                                      : 'Add to Cart',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:caresync/Tejas/Model%20Class/productdetails.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProductsPage extends StatefulWidget {
//   final String categoryName;
//   final dynamic storeId;
//   final String patientId;

//   const ProductsPage({
//     Key? key,
//     required this.categoryName,
//     required this.storeId,
//     required this.patientId,
//   }) : super(key: key);

//   @override
//   State<ProductsPage> createState() => _ProductsPageState();
// }

// class _ProductsPageState extends State<ProductsPage> {
//   Map<String, int> productQuantities = {};

//   Future<void> _updateQuantity(ProductData product, int change) async {
//     try {
//       final cartRef = FirebaseFirestore.instance.collection(
//           'CareSync/patients/accounts/${widget.patientId}/Cart');

//       productQuantities[product.productId] ??= 0;
//       final newQuantity = productQuantities[product.productId]! + change;

//       if (newQuantity > 0) {
//         await cartRef.doc(product.productId).set({
//           'name': product.name,
//           'price': product.price,
//           'mrp': product.mrp,
//           'image': product.image,
//           'quantity': newQuantity,
//         });
//         productQuantities[product.productId] = newQuantity;
//       } else {
//         await cartRef.doc(product.productId).delete();
//         productQuantities.remove(product.productId);
//       }

//       setState(() {});
//     } catch (e) {
//       log("Error updating quantity: $e");
//     }
//   }

//   Future<void> _toggleCart(ProductData product) async {
//     try {
//       final cartRef = FirebaseFirestore.instance.collection(
//           'CareSync/patients/accounts/${widget.patientId}/Cart');

//       final productDoc = await cartRef.doc(product.productId).get();

//       if (productDoc.exists) {
//         await cartRef.doc(product.productId).delete();
//       } else {
//         await cartRef.doc(product.productId).set({
//           'name': product.name,
//           'price': product.price,
//           'mrp': product.mrp,
//           'image': product.image,
//           'quantity': 1,
//         });
//       }

//       setState(() {});
//     } catch (e) {
//       log("Error toggling cart: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0.0, 0.3, 0.7, 1.0],
//                 colors: [
//                   Color.fromRGBO(97, 206, 255, 1),
//                   Colors.white,
//                   Colors.white,
//                   Color.fromRGBO(14, 190, 126, 1),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(9.0, screenHeight * 0.06, 9.0, 0),
//             child: Column(
//               children: [
//                 // Header Section
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         height: screenWidth * 0.1,
//                         width: screenWidth * 0.1,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(17),
//                           color: Colors.transparent,
//                           border: Border.all(
//                               color: const Color.fromRGBO(0, 0, 0, 1),
//                               width: 1),
//                         ),
//                         child: const Icon(
//                           size: 30,
//                           Icons.arrow_back_ios_new_rounded,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.03),
//                     Text(
//                       widget.categoryName,
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 25),
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection(
//                             'Medical Stores/${widget.storeId}/categories/${widget.categoryName}/products')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text("Error: ${snapshot.error}"),
//                         );
//                       }

//                       final productDocs = snapshot.data?.docs ?? [];
//                       final productsList = productDocs.map((doc) {
//                         final data = doc.data() as Map<String, dynamic>;
//                         return ProductData(
//                           name: data['name'] ?? 'Unknown',
//                           productId: doc.id,
//                           price: (data['price'] as num?)?.toDouble() ?? 0.0,
//                           image: data['imageUrl'] ?? '',
//                           mrp: (data['mrp'] as num?)?.toDouble() ?? 0.0,
//                         );
//                       }).toList();

//                       return GridView.builder(
//                         padding: const EdgeInsets.all(5.0),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: screenWidth < 600 ? 2 : 4,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 20,
//                           childAspectRatio: 0.6,
//                         ),
//                         itemCount: productsList.length,
//                         itemBuilder: (context, index) {
//                           final medicine = productsList[index];
//                           return Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.2),
//                                   spreadRadius: 2,
//                                   blurRadius: 5,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Stack(
//                                   children: [
//                                     Center(
//                                       child: Image.network(
//                                         medicine.image,
//                                         height: screenWidth * 0.3,
//                                         errorBuilder: (context, error,
//                                                 stackTrace) =>
//                                             const Icon(Icons.image),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   medicine.name,
//                                   maxLines: 2,
//                                   style: GoogleFonts.roboto(
//                                     fontSize: screenWidth * 0.04,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       '₹${medicine.price}',
//                                       style: GoogleFonts.roboto(
//                                         fontSize: screenWidth * 0.045,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       'MRP ₹${medicine.mrp}',
//                                       style: GoogleFonts.roboto(
//                                         fontSize: screenWidth * 0.032,
//                                         color: Colors.grey,
//                                         decoration:
//                                             TextDecoration.lineThrough,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Text("Quantity:"),
//                                     IconButton(
//                                       onPressed: () =>
//                                           _updateQuantity(medicine, -1),
//                                       icon: const Icon(Icons.remove),
//                                     ),
//                                     Text(
//                                       '${productQuantities[medicine.productId] ?? 0}',
//                                       style: GoogleFonts.roboto(),
//                                     ),
//                                     IconButton(
//                                       onPressed: () =>
//                                           _updateQuantity(medicine, 1),
//                                       icon: const Icon(Icons.add),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

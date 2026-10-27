import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:caresync/features/pharmacy/data/models/product_details_model.dart';

class Wishlist extends StatefulWidget {
  final String patientId;
  final VoidCallback onProductChanged;

  const Wishlist({
    super.key,
    required this.patientId,
    required this.onProductChanged,
  });

  @override
  State<Wishlist> createState() => _WishlistState();
}
List<ProductData> wishlistProducts = [];
class _WishlistState extends State<Wishlist> {
 // List<ProductData> wishlistProducts = [];

  @override
  void initState() {
    super.initState();
    fetchWishlistProducts();
  }

  Future<void> fetchWishlistProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/${widget.patientId}/Wishlist')
          .get();

      wishlistProducts.clear();
      for (var productDoc in querySnapshot.docs) {
        wishlistProducts.add(
          ProductData(
            name: productDoc.data()['name'] ?? 'No Name',
            productId: productDoc.id,
            price: productDoc.data()['price'] ?? 0,
            image: productDoc.data()['image'] ?? '',
            mrp: productDoc.data()['mrp'] ?? 0,
            
          ),
        );
      }

      setState(() {});
    } catch (e) {
      print("Error fetching wishlist products: $e");
    }
  }

  Future<void> deleteProductFromWishlist(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/${widget.patientId}/Wishlist')
          .doc(productId)
          .delete();
      widget.onProductChanged(); 
      fetchWishlistProducts();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double titleFontSize = screenWidth * 0.07;
    double itemFontSize = screenWidth * 0.04;

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
            padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    SizedBox(width: screenWidth * 0.23),
                    Text(
                      'Wishlist',
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: wishlistProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/json/wishList.json"),
                              Text(
                                'No items in wishlist',
                                style: GoogleFonts.roboto(
                                  fontSize: itemFontSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: wishlistProducts.length,
                          itemBuilder: (context, index) {
                            final product = wishlistProducts[index];
                            return Card(
                              margin: EdgeInsets.all(screenWidth * 0.03),
                              child: ListTile(
                                leading: Image.network(
                                  product.image,
                                  height: screenWidth * 0.15,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  product.name,
                                  style: GoogleFonts.roboto(
                                    fontSize: itemFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Price: ₹${product.price}',
                                  style: GoogleFonts.roboto(
                                    fontSize: itemFontSize * 0.9,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteProductFromWishlist(product.productId);
                                  },
                                ),
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


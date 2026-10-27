// import 'dart:developer';

// import 'package:caresync/features/pharmacy/presentation/pages/products_page.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProductCategories extends StatefulWidget {
//   final List<String> categoryImages;
//   final dynamic storeId;

//   const ProductCategories(
//       {super.key, required this.categoryImages, required this.storeId});

//   @override
//   State<ProductCategories> createState() => _ProductCategoriesState();
// }

// class _ProductCategoriesState extends State<ProductCategories> {
//   List<String> categoryName = [];
//   bool isLoading = true; // To track loading state

//   Future<void> navigateToBabyCare(
//       BuildContext context, String categoryName, dynamic storeId) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final patientId = currentUser?.uid ?? '';

//     log("categry name  : $categoryName");
//     log("store id name  : $storeId");
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductsPage(
//           categoryName: categoryName,
//           storeId: storeId,
//           patientId: patientId,
//         ),
//       ),
//     );
//   }

//   Future<void> fetchCategories() async {
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
//         .instance
//         .collection('Medical Stores/${widget.storeId}/categories')
//         .get();

//     log("----${widget.storeId}");

//     for (var doc in querySnapshot.docs) {
//       log("${doc['name']}");
//       categoryName.add(doc['name']);
//     }
//   }

//   // Future<void> fetchCategories() async {
//   //   try {
//   //     final querySnapshot = await FirebaseFirestore.instance
//   //         .collection('Medical Stores/${widget.storeId}/categories')
//   //         .get();

//   //     // Populate category names
//   //     categoryName = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
//   //   } catch (e) {
//   //     // Handle errors here
//   //     debugPrint("Error fetching categories: $e");
//   //   } finally {
//   //     setState(() {
//   //       isLoading = false; // Update loading state
//   //     });
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () async {
//       await fetchCategories();
//       setState(() {});
//     });
//   }

//   void navigateToCategory(BuildContext context, Widget categoryScreen) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => categoryScreen,
//       ),
//     );
//   }

//   List<Map<String, dynamic>> carouselImages = [
//     {
//       'image': "assets/jpg/CategoryCaraiousal/C1.jpg",
//     },
//     {
//       'image': "assets/jpg/CategoryCaraiousal/C2.jpg",
//     },
//     {
//       'image': "assets/jpg/CategoryCaraiousal/C3.jpg",
//     },
//     {
//       'image': "assets/jpg/CategoryCaraiousal/C4.jpg",
//     },
//     {
//       'image': "assets/jpg/CategoryCaraiousal/C5.jpg",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double carouselHeight = screenWidth * 0.4;
//     int crossAxisCount = screenWidth < 600 ? 2 : 3;
//     double categoryImageSize = screenWidth * 0.6;

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
//             padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
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
//                               width: 1)),
//                       child: const Icon(
//                         size: 30,
//                         Icons.arrow_back_ios_new_rounded,
//                         color: Colors.black,
//                       ),
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.05),
//                     Text(
//                       'Categories',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: screenWidth * 0.05),
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: carouselHeight,
//                     autoPlay: true,
//                     enlargeCenterPage: true,
//                   ),
//                   items: carouselImages.map((imagePath) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return GestureDetector(
//                           // onTap: () {
//                           //   navigateToCategory(context, imagePath['route']);
//                           // },
//                           child: Container(
//                             width: screenWidth,
//                             margin: const EdgeInsets.symmetric(horizontal: 1.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black26,
//                                   offset: Offset(0, 4),
//                                   blurRadius: 6.0,
//                                 ),
//                               ],
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.asset(
//                                 imagePath['image'],
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),
//                 SizedBox(height: screenWidth * 0.07),
//                 const Text(
//                   'Shop By Category',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Expanded(
//                   child: widget.categoryImages.isEmpty
//                       ? Center(
//                           child: Text(
//                           "No Categories Available",
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.04,
//                           ),
//                         ))
//                       : GridView.builder(
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: crossAxisCount,
//                             crossAxisSpacing: 10,
//                             mainAxisSpacing: 10,
//                             childAspectRatio: 0.8,
//                           ),
//                           itemCount: widget.categoryImages.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 log("length: ${widget.categoryImages.length}");
//                                 log("in category button");
//                                 log("category name : ${categoryName[index]} ");
//                                 log("store id : ${widget.storeId} ");
//                                 navigateToBabyCare(context, categoryName[index],
//                                     widget.storeId);

//                                 // // You can add specific navigation logic here based on your requirements
//                                 // // Example: navigateToCategory(context, categoryScreen);
//                                 // Navigator.of(context).push(
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => BabyCare(
//                                 //       categoryName: categoryName[index],
//                                 //       storeId: widget.storeId,
//                                 //       patientId: patientId,
//                                 //     ),
//                                 //   ),
//                                 // );
//                               },
//                               child: Container(
//                                 clipBehavior: Clip.antiAlias,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                     topRight: Radius.circular(20),
//                                     bottomLeft: Radius.circular(80),
//                                     bottomRight: Radius.circular(80),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(
//                                           0.25), // Subtle shadow color
//                                       blurRadius:
//                                           20, // Soft and diffused shadow
//                                       offset: const Offset(0,
//                                           10), // Shadow slightly below the container
//                                     ),
//                                     BoxShadow(
//                                       color: Colors.white.withOpacity(
//                                           0.1), // Light glow effect
//                                       blurRadius: 5,
//                                       offset: const Offset(
//                                           -2, -2), // Subtle top-left highlight
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: Image.network(
//                                     widget.categoryImages[index],
//                                     width: categoryImageSize,
//                                     height: categoryImageSize,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:developer';

// import 'package:caresync/features/pharmacy/presentation/pages/products_page.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProductCategories extends StatefulWidget {
//   final List<String> categoryImages;
//   final dynamic storeId;

//   const ProductCategories(
//       {super.key, required this.categoryImages, required this.storeId});

//   @override
//   State<ProductCategories> createState() => _ProductCategoriesState();
// }

// class _ProductCategoriesState extends State<ProductCategories> {
//   Future<void> navigateToBabyCare(
//       BuildContext context, String categoryName, dynamic storeId) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final patientId = currentUser?.uid ?? '';

//     log("category name: $categoryName");
//     log("store id name: $storeId");
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductsPage(
//           categoryName: categoryName,
//           storeId: storeId,
//           patientId: patientId,
//         ),
//       ),
//     );
//   }

//   List<Map<String, dynamic>> carouselImages = [
//     {'image': "assets/jpg/CategoryCaraiousal/C1.jpg"},
//     {'image': "assets/jpg/CategoryCaraiousal/C2.jpg"},
//     {'image': "assets/jpg/CategoryCaraiousal/C3.jpg"},
//     {'image': "assets/jpg/CategoryCaraiousal/C4.jpg"},
//     {'image': "assets/jpg/CategoryCaraiousal/C5.jpg"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double carouselHeight = screenWidth * 0.4;
//     int crossAxisCount = screenWidth < 600 ? 2 : 3;

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
//             padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
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
//                             color: const Color.fromRGBO(0, 0, 0, 1),
//                             width: 1,
//                           ),
//                         ),
//                         child: const Icon(
//                           size: 30,
//                           Icons.arrow_back_ios_new_rounded,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.05),
//                     Text(
//                       'Categories',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: screenWidth * 0.05),
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: carouselHeight,
//                     autoPlay: true,
//                     enlargeCenterPage: true,
//                   ),
//                   items: carouselImages.map((imagePath) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                           width: screenWidth,
//                           margin: const EdgeInsets.symmetric(horizontal: 1.0),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 offset: Offset(0, 4),
//                                 blurRadius: 6.0,
//                               ),
//                             ],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               imagePath['image'],
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),
//                 SizedBox(height: screenWidth * 0.07),
//                 const Text(
//                   'Shop By Category',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                     stream: FirebaseFirestore.instance
//                         .collection('Medical Stores/${widget.storeId}/categories')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text(
//                             "Error: ${snapshot.error}",
//                             style: TextStyle(
//                               fontSize: screenWidth * 0.04,
//                             ),
//                           ),
//                         );
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return Center(
//                           child: Text(
//                             "No Categories Available",
//                             style: TextStyle(
//                               fontSize: screenWidth * 0.04,
//                             ),
//                           ),
//                         );
//                       }

//                       final categories = snapshot.data!.docs;
//                       final categoryImages = widget.categoryImages.length >= categories.length
//                           ? widget.categoryImages.sublist(0, categories.length)
//                           : List.generate(categories.length, (index) {
//                               return widget.categoryImages.isNotEmpty
//                                   ? widget.categoryImages[index % widget.categoryImages.length]
//                                   : 'https://via.placeholder.com/150';
//                             });

//                       return GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: crossAxisCount,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 10,
//                           childAspectRatio: 0.8,
//                         ),
//                         itemCount: categories.length,
//                         itemBuilder: (context, index) {
//                           final category = categories[index].data();
//                           final imageUrl = categoryImages[index];

//                           return GestureDetector(
//                             onTap: () {
//                               navigateToBabyCare(
//                                 context,
//                                 category['name'],
//                                 widget.storeId,
//                               );
//                             },
//                             child: Container(
//                               clipBehavior: Clip.antiAlias,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: const BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                   bottomLeft: Radius.circular(80),
//                                   bottomRight: Radius.circular(80),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.25),
//                                     blurRadius: 20,
//                                     offset: const Offset(0, 10),
//                                   ),
//                                   BoxShadow(
//                                     color: Colors.white.withOpacity(0.1),
//                                     blurRadius: 5,
//                                     offset: const Offset(-2, -2),
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Image.network(
//                                   imageUrl,
//                                   width: screenWidth * 0.6,
//                                   height: screenWidth * 0.6,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
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


import 'dart:developer';

import 'package:caresync/features/pharmacy/presentation/pages/products_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCategories extends StatefulWidget {
  final List<String> categoryImages;
  final dynamic storeId;

  const ProductCategories(
      {super.key, required this.categoryImages, required this.storeId});

  @override
  State<ProductCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  Future<void> navigateToBabyCare(
      BuildContext context, String categoryName, dynamic storeId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final patientId = currentUser?.uid ?? '';

    log("category name: $categoryName");
    log("store id name: $storeId");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(
          categoryName: categoryName,
          storeId: storeId,
          patientId: patientId,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> carouselImages = [
    {'image': "assets/jpg/CategoryCaraiousal/C1.jpg"},
    {'image': "assets/jpg/CategoryCaraiousal/C2.jpg"},
    {'image': "assets/jpg/CategoryCaraiousal/C3.jpg"},
    {'image': "assets/jpg/CategoryCaraiousal/C4.jpg"},
    {'image': "assets/jpg/CategoryCaraiousal/C5.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double carouselHeight = screenWidth * 0.4;
    int crossAxisCount = screenWidth < 600 ? 2 : 3;

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
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          size: 30,
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Text(
                      'Categories',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.05),
                CarouselSlider(
                  options: CarouselOptions(
                    height: carouselHeight,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: carouselImages.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: screenWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 1.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              imagePath['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: screenWidth * 0.07),
                const Text(
                  'Shop By Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( 
                    stream: FirebaseFirestore.instance
                        .collection('Medical Stores/${widget.storeId}/categories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No Categories Available",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        );
                      }

                      final categories = snapshot.data!.docs;
                      final categoryImages = widget.categoryImages.length >= categories.length
                          ? widget.categoryImages.sublist(0, categories.length)
                          : List.generate(categories.length, (index) {
                              return widget.categoryImages.isNotEmpty
                                  ? widget.categoryImages[index % widget.categoryImages.length]
                                  : 'https://via.placeholder.com/150';
                            });

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index].data();
                          final imageUrl = categoryImages[index];

                          return GestureDetector(
                            onTap: () {
                              navigateToBabyCare(
                                context,
                                category['name'],
                                widget.storeId,
                              );
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(80),
                                  bottomRight: Radius.circular(80),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(-2, -2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.network(
                                  imageUrl,
                                  width: screenWidth * 0.6,
                                  height: screenWidth * 0.6,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; 
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
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

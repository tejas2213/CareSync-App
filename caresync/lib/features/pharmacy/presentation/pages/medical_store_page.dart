
// import 'package:caresync/Tejas/Model%20Class/MedicalStoreModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'MedicineCategories.dart';

// import 'package:carousel_slider/carousel_slider.dart';

// class MedicalStore extends StatefulWidget {
//   const MedicalStore({super.key});

//   @override
//   State createState() => _MedicalStore();
// }

// class _MedicalStore extends State<MedicalStore> {
//   List<String> carouselImages = [
//     "assets/jpg/MedicalStoreCaraoiusal/M1.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M2.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M3.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M4.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M5.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M6.jpg",
//   ];

//   Stream<List<MedicalStoresModel>> fetchMedicalStoresStream() {
//     return FirebaseFirestore.instance
//         .collection('Medical Stores')
//         .snapshots()
//         .asyncMap((querySnapshot) async {
//       List<MedicalStoresModel> medicals = [];
//       for (var doc in querySnapshot.docs) {
//         try {
//           // Fetch categories for each medical store
//           final categoriesSnapshot = await doc.reference.collection('categories').get();

//           List<String> categoryImages = categoriesSnapshot.docs.map((catDoc) {
//             return (catDoc.data()['image_url'] ?? '') as String;
//           }).toList();

//           medicals.add(MedicalStoresModel(
//             id: doc.id,
//             title: doc.data()['name'] ?? 'No Name',
//             address: doc.data()['address'] ?? 'No Address',
//             phoneNo: doc.data()['phone'] ?? 'No Phone',
//             image: doc.data()['image_url'] ?? '',
//             categoryImages: categoryImages,
//             categories: [],
//           ));
//         } catch (e) {
//           print("Error processing document ${doc.id}: $e");
//         }
//       }
//       return medicals;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background gradient
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

//           // Main content
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
//             child: Column(
//               children: [
//                 // Custom AppBar content
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
//                     Text(
//                       'Medical Stores',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.09),
//                   ],
//                 ),

//                 SizedBox(height: screenHeight * 0.03),

//                 // Carousel slider
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: screenHeight * 0.2,
//                     autoPlay: true,
//                     enlargeCenterPage: true,
//                   ),
//                   items: carouselImages.map((imagePath) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                           width: screenWidth * 0.9,
//                           margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
//                               imagePath,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),

//                 // Medical List using StreamBuilder
//                 Expanded(
//                   child: StreamBuilder<List<MedicalStoresModel>>(
//                     stream: fetchMedicalStoresStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         return Center(
//                           child: Text(
//                             "Error fetching data: ${snapshot.error}",
//                             style: TextStyle(fontSize: screenWidth * 0.04),
//                           ),
//                         );
//                       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return Center(
//                           child: Text(
//                             "No Medical Stores Available",
//                             style: TextStyle(fontSize: screenWidth * 0.04),
//                           ),
//                         );
//                       } else {
//                         final listOfMedicals = snapshot.data!;
//                         return ListView.builder(
//                           itemCount: listOfMedicals.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: screenWidth * 0.02,
//                                   vertical: screenHeight * 0.013),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) => ProductCategories(
//                                         categoryImages: listOfMedicals[index].categoryImages,
//                                         storeId: listOfMedicals[index].id,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black87.withOpacity(0.6),
//                                         offset: const Offset(0, 4),
//                                         blurRadius: 6.0,
//                                         spreadRadius: 0.1,
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         margin: EdgeInsets.symmetric(
//                                             horizontal: screenWidth * 0.04,
//                                             vertical: screenHeight * 0.020),
//                                         width: screenWidth * 0.25,
//                                         height: screenHeight * 0.12,
//                                         decoration: BoxDecoration(
//                                           color: const Color.fromARGB(194, 255, 255, 255),
//                                           borderRadius: BorderRadius.circular(4.2),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(0.8),
//                                               offset: const Offset(0, 3),
//                                               blurRadius: 4.0,
//                                             ),
//                                           ],
//                                         ),
//                                         child: Image.network(
//                                           listOfMedicals[index].image,
//                                           width: 100,
//                                           height: 100,
//                                           fit: BoxFit.cover,
//                                           loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                                             if (loadingProgress == null) {
//                                               return child;
//                                             } else {
//                                               return Center(
//                                                 child: CircularProgressIndicator(
//                                                   value: loadingProgress.expectedTotalBytes != null
//                                                       ? loadingProgress.cumulativeBytesLoaded /
//                                                           (loadingProgress.expectedTotalBytes ?? 1)
//                                                       : null,
//                                                 ),
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               listOfMedicals[index].title,
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.04,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: const Color.fromRGBO(0, 0, 0, 1),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               listOfMedicals[index].address,
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.035,
//                                                 height: 1.5,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: const Color.fromRGBO(0, 0, 0, 0.7),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               listOfMedicals[index].phoneNo,
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.035,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: const Color.fromRGBO(0, 0, 0, 0.7),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       }
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


// import 'package:caresync/Tejas/Model%20Class/MedicalStoreModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'MedicineCategories.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class MedicalStore extends StatefulWidget {
//   const MedicalStore({super.key});

//   @override
//   State createState() => _MedicalStore();
// }

// class _MedicalStore extends State<MedicalStore> {
//   List<String> carouselImages = [
//     "assets/jpg/MedicalStoreCaraoiusal/M1.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M2.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M3.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M4.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M5.jpg",
//     "assets/jpg/MedicalStoreCaraoiusal/M6.jpg",
//   ];

//   Stream<List<MedicalStoresModel>> fetchMedicalStoresStream() {
//     return FirebaseFirestore.instance
//         .collection('Medical Stores')
//         .snapshots()
//         .asyncMap((querySnapshot) async {
//       List<MedicalStoresModel> medicals = [];
//       for (var doc in querySnapshot.docs) {
//         try {
//           // Fetch categories for each medical store
//           final categoriesSnapshot = await doc.reference.collection('categories').get();

//           List<String> categoryImages = categoriesSnapshot.docs.map((catDoc) {
//             return (catDoc.data()['image_url'] ?? '') as String;
//           }).toList();

//           medicals.add(MedicalStoresModel(
//             id: doc.id,
//             title: doc.data()['name'] ?? 'No Name',
//             address: doc.data()['address'] ?? 'No Address',
//             phoneNo: doc.data()['phone'] ?? 'No Phone',
//             image: doc.data()['image_url'] ?? '',
//             categoryImages: categoryImages,
//             categories: [],
//           ));
//         } catch (e) {
//           print("Error processing document ${doc.id}: $e");
//         }
//       }
//       return medicals;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background gradient
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

//           // Main content
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
//             child: Column(
//               children: [
//                 // Custom AppBar content
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
//                     Text(
//                       'Medical Stores',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.09),
//                   ],
//                 ),

//                 SizedBox(height: screenHeight * 0.03),

//                 // Carousel slider
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: screenHeight * 0.2,
//                     autoPlay: true,
//                     enlargeCenterPage: true,
//                   ),
//                   items: carouselImages.map((imagePath) {
//                     return Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                           width: screenWidth * 0.9,
//                           margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
//                               imagePath,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 ),

//                 // Medical List using StreamBuilder
//                 Expanded(
//                   child: StreamBuilder<List<MedicalStoresModel>>(
//                     stream: fetchMedicalStoresStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         return Center(
//                           child: Text(
//                             "Error fetching data: ${snapshot.error}",
//                             style: TextStyle(fontSize: screenWidth * 0.04),
//                           ),
//                         );
//                       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return Center(
//                           child: Text(
//                             "No Medical Stores Available",
//                             style: TextStyle(fontSize: screenWidth * 0.04),
//                           ),
//                         );
//                       } else {
//                         final listOfMedicals = snapshot.data!;
//                         return ListView.builder(
//                           itemCount: listOfMedicals.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: screenWidth * 0.02,
//                                   vertical: screenHeight * 0.013),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) => ProductCategories(
//                                         categoryImages: listOfMedicals[index].categoryImages,
//                                         storeId: listOfMedicals[index].id,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black87.withOpacity(0.6),
//                                         offset: const Offset(0, 4),
//                                         blurRadius: 6.0,
//                                         spreadRadius: 0.1,
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         margin: EdgeInsets.symmetric(
//                                             horizontal: screenWidth * 0.04,
//                                             vertical: screenHeight * 0.020),
//                                         width: screenWidth * 0.25,
//                                         height: screenHeight * 0.12,
//                                         decoration: BoxDecoration(
//                                           color: const Color.fromARGB(194, 255, 255, 255),
//                                           borderRadius: BorderRadius.circular(4.2),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(0.8),
//                                               offset: const Offset(0, 3),
//                                               blurRadius: 4.0,
//                                             ),
//                                           ],
//                                         ),
//                                         child: Image.network(
//                                           listOfMedicals[index].image,
//                                           width: 100,
//                                           height: 100,
//                                           fit: BoxFit.cover,
//                                           loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                                             if (loadingProgress == null) {
//                                               return child;
//                                             } else {
//                                               return Center(
//                                                 child: CircularProgressIndicator(
//                                                   value: loadingProgress.expectedTotalBytes != null
//                                                       ? loadingProgress.cumulativeBytesLoaded /
//                                                           (loadingProgress.expectedTotalBytes ?? 1)
//                                                       : null,
//                                                 ),
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               listOfMedicals[index].title,
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.04,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: const Color.fromRGBO(0, 0, 0, 1),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               listOfMedicals[index].address,
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.035,
//                                                 height: 1.5,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: const Color.fromRGBO(0, 0, 0, 0.7),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               listOfMedicals[index].phoneNo,
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.035,
//                                                 height: 1.5,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: const Color.fromRGBO(0, 0, 0, 0.7),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       }
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


import 'package:caresync/features/pharmacy/data/models/medical_store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'medicine_categories_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MedicalStore extends StatefulWidget {
  const MedicalStore({super.key});

  @override
  State createState() => _MedicalStore();
}

class _MedicalStore extends State<MedicalStore> {
  List<String> carouselImages = [
    "assets/jpg/MedicalStoreCaraoiusal/M1.jpg",
    "assets/jpg/MedicalStoreCaraoiusal/M2.jpg",
    "assets/jpg/MedicalStoreCaraoiusal/M3.jpg",
    "assets/jpg/MedicalStoreCaraoiusal/M4.jpg",
    "assets/jpg/MedicalStoreCaraoiusal/M5.jpg",
    "assets/jpg/MedicalStoreCaraoiusal/M6.jpg",
  ];

  Stream<List<MedicalStoresModel>> fetchMedicalStoresStream() {
    return FirebaseFirestore.instance
        .collection('Medical Stores')
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<MedicalStoresModel> medicals = [];
      for (var doc in querySnapshot.docs) {
        try {
          // Fetch categories for each medical store
          final categoriesSnapshot = await doc.reference.collection('categories').get();

          List<String> categoryImages = categoriesSnapshot.docs.map((catDoc) {
            return (catDoc.data()['image_url'] ?? '') as String;
          }).toList();

          medicals.add(MedicalStoresModel(
            id: doc.id,
            title: doc.data()['name'] ?? 'No Name',
            address: doc.data()['address'] ?? 'No Address',
            phoneNo: doc.data()['phone'] ?? 'No Phone',
            image: doc.data()['image_url'] ?? '',
            categoryImages: categoryImages,
            categories: [],
          ));
        } catch (e) {
          print("Error processing document ${doc.id}: $e");
        }
      }
      return medicals;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
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

          // Main content
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
            child: Column(
              children: [
                // Custom AppBar content
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              width: 1),
                        ),
                        child: const Icon(
                          size: 30,
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      'Medical Stores',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.09),
                  ],
                ),

                SizedBox(height: screenHeight * 0.03),

                // Carousel slider
                CarouselSlider(
                  options: CarouselOptions(
                    height: screenHeight * 0.2,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: carouselImages.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: screenWidth * 0.9,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                // Medical List using StreamBuilder
                Expanded(
                  child: StreamBuilder<List<MedicalStoresModel>>(
                    stream: fetchMedicalStoresStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error fetching data: ${snapshot.error}",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "No Medical Stores Available",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        );
                      } else {
                        final listOfMedicals = snapshot.data!;
                        return ListView.builder(
                          itemCount: listOfMedicals.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.013),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductCategories(
                                        categoryImages: listOfMedicals[index].categoryImages,
                                        storeId: listOfMedicals[index].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black87.withOpacity(0.6),
                                        offset: const Offset(0, 4),
                                        blurRadius: 6.0,
                                        spreadRadius: 0.1,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.04,
                                            vertical: screenHeight * 0.020),
                                        width: screenWidth * 0.25,
                                        height: screenHeight * 0.12,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(194, 255, 255, 255),
                                          borderRadius: BorderRadius.circular(4.2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.8),
                                              offset: const Offset(0, 3),
                                              blurRadius: 4.0,
                                            ),
                                          ],
                                        ),
                                        child: Image.network(
                                          listOfMedicals[index].image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                          (loadingProgress.expectedTotalBytes ?? 1)
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listOfMedicals[index].title,
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              listOfMedicals[index].address,
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.035,
                                                height: 1.5,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromRGBO(0, 0, 0, 0.7),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              listOfMedicals[index].phoneNo,
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.035,
                                                height: 1.5,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromRGBO(0, 0, 0, 0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
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

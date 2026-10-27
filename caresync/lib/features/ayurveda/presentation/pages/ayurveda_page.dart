// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'AyurvedaDetailScreen.dart';

// class AyurvedaGridScreen extends StatefulWidget {
//   const AyurvedaGridScreen({super.key});

//   @override
//   State<AyurvedaGridScreen> createState() => _AyurvedaGridScreenState();
// }

// class _AyurvedaGridScreenState extends State<AyurvedaGridScreen> {
//   List<QueryDocumentSnapshot> _ayurvedaItems = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchItems();
//   }

//   Future<void> _fetchItems() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('Ayurveda')
//           .orderBy('createdAt', descending: true)
//           .get();

//       setState(() {
//         _ayurvedaItems = querySnapshot.docs;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final crossAxisCount = screenWidth > 800 ? 4 : (screenWidth > 600 ? 3 : 2);

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Gradient Background
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
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding:
//                       EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // AppBar
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                               height: screenWidth * 0.1,
//                               width: screenWidth * 0.1,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(17),
//                                   color: Colors.transparent,
//                                   border: Border.all(
//                                       color: Colors.black, width: 1)),
//                               child: const Icon(
//                                 size: 30,
//                                 Icons.arrow_back_ios_new_rounded,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             'Ayurveda Items',
//                             style: GoogleFonts.poppins(
//                               fontSize: screenWidth * 0.07,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(
//                             width: screenWidth * 0.09,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       // Grid Items
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: LayoutBuilder(
//                             builder: (context, constraints) {
//                               final itemWidth =
//                                   constraints.maxWidth / crossAxisCount;
//                               final imageSize = itemWidth * 0.5;
//                               return GridView.builder(
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: crossAxisCount,
//                                   crossAxisSpacing: 16.0,
//                                   mainAxisSpacing: 16.0,
//                                   childAspectRatio: 1,
//                                 ),
//                                 itemCount: _ayurvedaItems.length,
//                                 itemBuilder: (context, index) {
//                                   final item = _ayurvedaItems[index];
//                                   return Hero(
//                                     tag: "item-${item['name']}",
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 AyurvedaDetailScreen(
//                                               name: item['name'],
//                                               imagePath: item['image'],
//                                               description: item['description'],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           gradient: const LinearGradient(
//                                             colors: [
//                                               Color(0xFFBFF2DF),
//                                               Color(0xFF66D9B3)
//                                             ],
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                           ),
//                                           borderRadius: const BorderRadius.only(
//                                             topLeft: Radius.circular(10),
//                                             topRight: Radius.circular(10),
//                                             bottomLeft: Radius.circular(70),
//                                             bottomRight: Radius.circular(70),
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.grey.withOpacity(0.6),
//                                               spreadRadius: 4,
//                                               blurRadius: 12,
//                                               offset: const Offset(0,
//                                                   6), // Slightly larger shadow
//                                             ),
//                                           ],
//                                           border: Border.all(
//                                             color: const Color(0xFF66D9B3),
//                                             width:
//                                                 2, // Adds a subtle border for extra definition
//                                           ),
//                                         ),

//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               clipBehavior: Clip.antiAlias,
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           12)),
//                                               child: Image.network(
//                                                 item['image'],
//                                                 width: imageSize,
//                                                 height: imageSize,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 8.0),
//                                             Text(
//                                               item['name'],
//                                               style: GoogleFonts.poppins(
//                                                 fontSize:
//                                                     screenWidth > 600 ? 18 : 14,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'AyurvedaDetailScreen.dart';

// class AyurvedaGridScreen extends StatelessWidget {
//   const AyurvedaGridScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final crossAxisCount = screenWidth > 800 ? 4 : (screenWidth > 600 ? 3 : 2);

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Gradient Background
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
//                 // AppBar
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
//                             borderRadius: BorderRadius.circular(17),
//                             color: Colors.transparent,
//                             border: Border.all(color: Colors.black, width: 1)),
//                         child: const Icon(
//                           size: 30,
//                           Icons.arrow_back_ios_new_rounded,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'Ayurveda Items',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(
//                       width: screenWidth * 0.09,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 // Grid Items
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         final itemWidth = constraints.maxWidth / crossAxisCount;
//                         final imageSize = itemWidth * 0.5;

//                         return StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance
//                               .collection('Ayurveda')
//                               .orderBy('createdAt', descending: true)
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                             if (snapshot.hasError) {
//                               return Center(
//                                 child: Text(
//                                   'Error: ${snapshot.error}',
//                                   style: GoogleFonts.poppins(fontSize: 16),
//                                 ),
//                               );
//                             }
//                             final ayurvedaItems = snapshot.data?.docs ?? [];
//                             if (ayurvedaItems.isEmpty) {
//                               return Center(
//                                 child: Text(
//                                   'No items available',
//                                   style: GoogleFonts.poppins(fontSize: 18),
//                                 ),
//                               );
//                             }
//                             return GridView.builder(
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: crossAxisCount,
//                                 crossAxisSpacing: 16.0,
//                                 mainAxisSpacing: 16.0,
//                                 childAspectRatio: 1,
//                               ),
//                               itemCount: ayurvedaItems.length,
//                               itemBuilder: (context, index) {
//                                 final item = ayurvedaItems[index];
//                                 return Hero(
//                                   tag: "item-${item['name']}",
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               AyurvedaDetailScreen(
//                                             name: item['name'],
//                                             imagePath: item['image'],
//                                             description: item['description'],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         gradient: const LinearGradient(
//                                           colors: [
//                                             Color(0xFFBFF2DF),
//                                             Color(0xFF66D9B3)
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         borderRadius: const BorderRadius.only(
//                                           topLeft: Radius.circular(10),
//                                           topRight: Radius.circular(10),
//                                           bottomLeft: Radius.circular(70),
//                                           bottomRight: Radius.circular(70),
//                                         ),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.withOpacity(0.6),
//                                             spreadRadius: 4,
//                                             blurRadius: 12,
//                                             offset: const Offset(0,
//                                                 6), // Slightly larger shadow
//                                           ),
//                                         ],
//                                         border: Border.all(
//                                           color: const Color(0xFF66D9B3),
//                                           width:
//                                               2, // Adds a subtle border for extra definition
//                                         ),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             clipBehavior: Clip.antiAlias,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(12),
//                                             ),
//                                             child: Image.network(
//                                               item['image'],
//                                               width: imageSize,
//                                               height: imageSize,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8.0),
//                                           Text(
//                                             item['name'],
//                                             style: GoogleFonts.poppins(
//                                               fontSize: screenWidth > 600
//                                                   ? 18
//                                                   : 14,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         );
//                       },
//                     ),
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


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'ayurveda_detail_page.dart';

class AyurvedaGridScreen extends StatefulWidget {
  const AyurvedaGridScreen({super.key});

  @override
  State<AyurvedaGridScreen> createState() => _AyurvedaGridScreenState();
}

class _AyurvedaGridScreenState extends State<AyurvedaGridScreen> {
  late Database db;
  List<Map<String, dynamic>> ayurvedaItems = [];

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/ayurvedamodule.db';

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Ayurveda (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            imagePath TEXT
          )
        ''');
      },
    );

    await fetchAndCacheData();
    await loadLocalData();
  }

  Future<void> fetchAndCacheData() async {
    try {
      // Fetch from Firestore
      final firestoreItems = await FirebaseFirestore.instance
          .collection('Ayurveda')
          .orderBy('createdAt', descending: true)
          .get();

      for (var doc in firestoreItems.docs) {
        final data = doc.data();
        final id = doc.id;
        final name = data['name'];
        final description = data['description'];
        final imageUrl = data['image'];

        // Check if image is already downloaded
        final imagePath = await downloadAndSaveImage(imageUrl, id);

        if (imagePath != null) {
          await db.insert(
            'Ayurveda',
            {
              'id': id,
              'name': name,
              'description': description,
              'imagePath': imagePath,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching or caching data: $e');
    }
  }

  Future<String?> downloadAndSaveImage(String imageUrl, String id) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$id.jpg';
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      // Attempt to download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      debugPrint("Error downloading image: $e");
    }
    return null;
  }

  Future<void> loadLocalData() async {
    try {
      final localData = await db.query('Ayurveda');
      setState(() {
        ayurvedaItems = localData;
      });
    } catch (e) {
      debugPrint("Error loading local data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 800 ? 4 : (screenWidth > 600 ? 3 : 2);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
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
            padding: EdgeInsets.fromLTRB(
                16.0, MediaQuery.of(context).size.height * 0.06, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
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
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: const Icon(
                          size: 30,
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      'Ayurveda Items',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.09),
                  ],
                ),
                const SizedBox(height: 20),
                // Grid Items
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: ayurvedaItems.length,
                    itemBuilder: (context, index) {
                      final item = ayurvedaItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AyurvedaDetailScreen(
                                name: item['name'],
                                imagePath: item['imagePath'],
                                description: item['description'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFBFF2DF), Color(0xFF66D9B3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 4,
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFF66D9B3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.file(
                                  File(item['imagePath']),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image,
                                        size: 50); // Placeholder for missing images
                                  },
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                item['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth > 600 ? 18 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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



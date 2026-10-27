// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AyurvedaDetailScreen extends StatefulWidget {
//   final String name;
//   final String imagePath;
//   final String description;

//   const AyurvedaDetailScreen({
//     super.key,
//     required this.name,
//     required this.imagePath,
//     required this.description,
//   });

//   @override
//   State<AyurvedaDetailScreen> createState() => _AyurvedaDetailScreenState();
// }

// class _AyurvedaDetailScreenState extends State<AyurvedaDetailScreen> {
//   bool isFavorite = false; 

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Gradient
//           Container(
//            decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: [0.0, 0.3, 0.7, 1.0],
//             colors: [
//               Color.fromRGBO(97, 206, 255, 1),
//               Colors.white,
//               Colors.white,
//               Color.fromRGBO(14, 190, 126, 1),
//             ],
//           ),
//         ),
//           ),
          
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Custom AppBar Section
//                   Row(
//                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           height: screenWidth * 0.1,
//                           width: screenWidth * 0.1,
//                           decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(17),
//                                   color: Colors.transparent,
//                                   border: Border.all(
//                                       color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
//                               child: const Icon(
//                                 size: 30,
//                                 Icons.arrow_back_ios_new_rounded,
//                                 color: Colors.black,
//                               ),
//                         ),
//                       ),
//                       SizedBox(width: screenWidth*0.2),
//                       Text(
//                         'Detail Info',
//                         style: GoogleFonts.poppins(
//                           fontSize: screenWidth * 0.07,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       // IconButton(
//                       //   icon: Icon(
//                       //     isFavorite ? Icons.favorite : Icons.favorite_border,
//                       //     color: isFavorite ? Colors.red : Colors.grey,
//                       //     size: 30,
//                       //   ),
//                       //   onPressed: () {
//                       //     setState(() {
//                       //       isFavorite = !isFavorite;
//                       //     });
//                       //   },
//                       // ),
//                     ],
//                   ),
//                   const SizedBox(height: 16.0),
                
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           spreadRadius: 5,
//                           blurRadius: 10,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16.0),
//                       child: Hero(
//                         tag : "item-${widget.name}",
//                         child: Image.network(
//                           widget.imagePath,
//                           width: double.infinity,
//                           height: screenWidth * 0.6,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
                  
//                   Text(
//                     widget.name,
//                     style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
                 
//                   Text(
//                     widget.description,
//                     style:  GoogleFonts.poppins(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16.0),
                  
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AyurvedaDetailScreen extends StatelessWidget {
  final String name;
  final String imagePath; 
  final String description;

  const AyurvedaDetailScreen({
    super.key,
    required this.name,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
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
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom AppBar Section
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
                      SizedBox(width: screenWidth * 0.2),
                      Text(
                        'Detail Info',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Image Section
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Hero(
                        tag: "item-$name",
                        child: isImageFromUrl(imagePath)
                            ? Image.network(
                                imagePath,
                                width: double.infinity,
                                height: screenWidth * 0.6,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Image.file(
                                File(imagePath),
                                width: double.infinity,
                                height: screenWidth * 0.6,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Name Section
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Description Section
                  Text(
                    description,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to check if the `imagePath` is a URL or local path
  bool isImageFromUrl(String path) {
    final uri = Uri.tryParse(path);
    return uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}

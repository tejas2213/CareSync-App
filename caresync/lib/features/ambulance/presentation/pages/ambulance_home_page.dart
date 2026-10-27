// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:caresync/features/ambulance/presentation/pages/ambulance_list_page.dart';

// class AmbulanceBookingHome extends StatefulWidget {
//   const AmbulanceBookingHome({super.key});

//   @override
//   _AmbulanceBookingHomeState createState() => _AmbulanceBookingHomeState();
// }

// class _AmbulanceBookingHomeState extends State<AmbulanceBookingHome> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Map<String, List<String>> _ambulanceTypesMap = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchAmbulanceTypes();
//   }

//   Future<void> _fetchAmbulanceTypes() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('Ambulances').get();

//       setState(() {
//         _ambulanceTypesMap.clear();

//         for (var doc in snapshot.docs) {
//           String ambulanceType = doc['ambulanceType'];

//           if (!_ambulanceTypesMap.containsKey(ambulanceType)) {
//             _ambulanceTypesMap[ambulanceType] = [];
//           }

//           _ambulanceTypesMap[ambulanceType]!.add(doc.id);
//         }
//       });
//     } catch (e) {
//       print("Error fetching ambulance types: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     double padding = screenWidth * 0.04;
//     double carouselHeight = screenHeight * 0.25;
//     double textSize = screenWidth * 0.05;

//     return Scaffold(
//       body: Container(
//        decoration: const BoxDecoration(
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
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(padding, screenHeight * 0.06, padding, 0),
//           child: Column(
//             children: [
//               // Back button and title
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       height: screenWidth * 0.1,
//                       width: screenWidth * 0.1,
//                      decoration: BoxDecoration(
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
//                     ),
//                   ),
//                   Text(
//                     'Ambulance Booking',
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.06,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.1),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.04),

//               CarouselSlider(
//                 items: [
//                   carouselItem("assets/png/AmulanceCarasiousal/AmulanceCarasiousal1.png", screenWidth),
//                   carouselItem("assets/png/AmulanceCarasiousal/AmulanceCarasiousal2.png", screenWidth),
//                   carouselItem("assets/png/AmulanceCarasiousal/AmulanceCarasiousal3.png", screenWidth),
//                 ],
//                 options: CarouselOptions(
//                   height: carouselHeight,
//                   enlargeCenterPage: true,
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(seconds: 3),
//                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.06),

//               Text(
//                 'Select Ambulance Type',
//                 style: TextStyle(
//                   fontSize: textSize,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.01),

//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _ambulanceTypesMap.keys.length,
//                   itemBuilder: (context, index) {
//                     String ambulanceType = _ambulanceTypesMap.keys.elementAt(index);

//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AmbulanceListScreen(type: ambulanceType),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: screenHeight * 0.02),
//                         padding: EdgeInsets.all(screenWidth * 0.04),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(screenWidth * 0.04),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               blurRadius: 10,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.local_hospital,
//                               color: Colors.redAccent,
//                               size: screenWidth * 0.1,
//                             ),
//                             SizedBox(width: screenWidth * 0.05),
//                             Expanded(
//                               child: Text(
//                                 ambulanceType,
//                                 style: TextStyle(
//                                   fontSize: textSize,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),

//                             Text(
//                               '(${_ambulanceTypesMap[ambulanceType]!.length})',
//                               style: TextStyle(
//                                 fontSize: textSize,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget carouselItem(String imagePath, double screenWidth) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(screenWidth * 0.04),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(screenWidth * 0.04),
//         child: Image.asset(
//           imagePath,
//           fit: BoxFit.fill,
//           width: screenWidth,
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caresync/features/ambulance/presentation/pages/ambulance_list_page.dart';

class AmbulanceBookingHome extends StatefulWidget {
  const AmbulanceBookingHome({super.key});

  @override
  _AmbulanceBookingHomeState createState() => _AmbulanceBookingHomeState();
}

class _AmbulanceBookingHomeState extends State<AmbulanceBookingHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double padding = screenWidth * 0.04;
    double carouselHeight = screenHeight * 0.25;
    double textSize = screenWidth * 0.05;

    return Scaffold(
      body: Container(
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
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(padding, screenHeight * 0.06, padding, 0),
          child: Column(
            children: [
              // Back button and title
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
                            color: const Color.fromRGBO(0, 0, 0, 1), width: 1),
                      ),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'Ambulance Booking',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.1),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),

              // Carousel
              CarouselSlider(
                items: [
                  carouselItem(
                      "assets/png/AmulanceCarasiousal/AmulanceCarasiousal1.png",
                      screenWidth),
                  carouselItem(
                      "assets/png/AmulanceCarasiousal/AmulanceCarasiousal2.png",
                      screenWidth),
                  carouselItem(
                      "assets/png/AmulanceCarasiousal/AmulanceCarasiousal3.png",
                      screenWidth),
                ],
                options: CarouselOptions(
                  height: carouselHeight,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
              ),
              SizedBox(height: screenHeight * 0.06),

              Text(
                'Select Ambulance Type',
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
             SizedBox(height: screenHeight * 0.001),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('Ambulances').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data.'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('No ambulances available.'));
                    }

                    // Creating a map for ambulance types
                    Map<String, List<String>> ambulanceTypesMap = {};
                    for (var doc in snapshot.data!.docs) {
                      String ambulanceType = doc['ambulanceType'];
                      if (!ambulanceTypesMap.containsKey(ambulanceType)) {
                        ambulanceTypesMap[ambulanceType] = [];
                      }
                      ambulanceTypesMap[ambulanceType]!.add(doc.id);
                    }

                    return ListView.builder(
                      itemCount: ambulanceTypesMap.keys.length,
                      itemBuilder: (context, index) {
                        String ambulanceType =
                            ambulanceTypesMap.keys.elementAt(index);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AmbulanceListScreen(type: ambulanceType),
                              ),
                            );
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(bottom: screenHeight * 0.02),
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.04),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_hospital,
                                  color: Colors.redAccent,
                                  size: screenWidth * 0.1,
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Expanded(
                                  child: Text(
                                    ambulanceType,
                                    style: TextStyle(
                                      fontSize: textSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '(${ambulanceTypesMap[ambulanceType]!.length})',
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
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
      ),
    );
  }

  Widget carouselItem(String imagePath, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
          width: screenWidth,
        ),
      ),
    );
  }
}

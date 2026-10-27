// import 'dart:developer';
// import 'package:animate_do/animate_do.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pie_chart/pie_chart.dart';
// import '../../Snehal/blood_form/bloodcard.dart';
// import 'Drawer.dart';

// class DoctorHomeScreen extends StatefulWidget {
//   const DoctorHomeScreen({super.key});

//   @override
//   State createState() => _DoctorHomeScreenState();
// }

// class _DoctorHomeScreenState extends State with SingleTickerProviderStateMixin {
//   late Future<List<Map<String, String>>> patients;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool isDarkMode = false;
//   String _patientName = '';
//   late AnimationController _controller;

//   List<String> patientKey = [
//     'Total Patients',
//     'Accepted Patients',
//     'Upcoming Patients',
//     'Rejected Patients'
//   ];
//   int totalPatients = 0;
//   int acceptedPatients = 0;
//   int rejectedPatients = 0;
//   int upcomingPatients = 0;
//   List<Map<String, int>> patientCount = [
//     {'Total Patients': 0},
//     {'Accepted Patients': 0},
//     {'Upcoming Patients': 0},
//     {'Rejected Patients': 0},
//   ];
//   Map<String, double> patientCountMap = {
//     'Total Patients': 0,
//     'Accepted Patients': 0,
//     'Upcoming Patients': 0,
//     'Rejected Patients': 0,
//   };

//   get gradientList => null;

//   @override
//   void initState() {
//     log("initstate");
//     super.initState();
//     patients = appointmentStream();
//     updateCounts();
//     _loadDoctorData();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 10),
//       vsync: this,
//     )..repeat(reverse: true);
//   }

//   // Future<List<Map<String, String>>> fetchAppointments() async {
//   //   final currentUser = FirebaseAuth.instance.currentUser;
//   //   final doctorId = currentUser?.uid;

//   //   // Ensure currentUser is not null and doctorId is valid
//   //   if (doctorId == null || doctorId.isEmpty) {
//   //     print('Error: No logged-in user or invalid doctor ID.');
//   //     return [];
//   //   }

//   //   List<Map<String, String>> appointmentList = [];

//   //   try {
//   //     // Fetch the appointments collection
//   //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//   //         .collection('CareSync')
//   //         .doc('doctors')
//   //         .collection('accounts')
//   //         .doc(doctorId)
//   //         .collection('appointments')
//   //         .get();

//   //     // Process each document in the snapshot
//   //     for (var doc in querySnapshot.docs) {
//   //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//   //       // Ensure 'status' field exists and is a String
//   //       if (data.containsKey('status') && data['status'] is String) {
//   //         String status = data['status'];
//   //         appointmentList.add({'status': status});
//   //       } else {
//   //         print(
//   //             'Document ${doc.id} is missing "status" or it is not a String.');
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching appointments: $e');
//   //   }
//   //   setState(() {});
//   //   return appointmentList;
//   // }

//   Stream<List<Map<String, String>>> appointmentStream() {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   final doctorId = currentUser?.uid;

//   if (doctorId == null || doctorId.isEmpty) {
//     print('Error: No logged-in user or invalid doctor ID.');
//     return const Stream.empty();
//   }

//   return FirebaseFirestore.instance
//       .collection('CareSync')
//       .doc('doctors')
//       .collection('accounts')
//       .doc(doctorId)
//       .collection('appointments')
//       .snapshots()
//       .map((querySnapshot) {
//     return querySnapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       if (data.containsKey('status') && data['status'] is String) {
//         return {'status': data['status']};
//       } else {
//         return {'status': 'unknown'};
//       }
//     }).toList();
//   });
// }

//   // void assignData() async {
//   //   try {
//   //     // Await the resolution of the Future
//   //     List<Map<String, String>> patientData = await patients;

//   //     // Iterate over the resolved list
//   //     totalPatients = patientData.length;
//   //     for (var patient in patientData) {
//   //       log("--------------${patient['status']}");
//   //       if (patient['status'] == 'pending') {
//   //         upcomingPatients++;
//   //       } else if (patient['status'] == 'Accepted') {
//   //         acceptedPatients++;
//   //       } else if (patient['status'] == 'Rejected') {
//   //         rejectedPatients++;
//   //       }
//   //       setState(() {});
//   //     }

//   //     log("Accepted patient count _____$acceptedPatients");
//   //     log("Total patient count _____$totalPatients");
//   //     log("Rejected patient count _____$rejectedPatients");
//   //     log("Upcoming patient count _____$upcomingPatients");
//   //     patientCount[0]['Total Patients'] = totalPatients;
//   //     patientCount[1]['Accepted Patients'] = acceptedPatients;
//   //     patientCount[2]['Upcoming Patients'] = upcomingPatients;
//   //     patientCount[3]['Rejected Patients'] = rejectedPatients;
//   //     // Assign values to the map
//   //     patientCountMap['Total Patients'] = totalPatients.toDouble();
//   //     patientCountMap['Accepted Patients'] = acceptedPatients.toDouble();
//   //     patientCountMap['Upcoming Patients'] = upcomingPatients.toDouble();
//   //     patientCountMap['Rejected Patients'] = rejectedPatients.toDouble();

//   //     log("Patient count map: $patientCountMap");

//   //     setState(() {});
//   //   } catch (e) {
//   //     print('Error assigning data: $e');
//   //   }
//   // }
//   void updateCounts(List<Map<String, String>> appointmentList) {
//   totalPatients = appointmentList.length;
//   acceptedPatients = 0;
//   rejectedPatients = 0;
//   upcomingPatients = 0;

//   for (var patient in appointmentList) {
//     if (patient['status'] == 'pending') {
//       upcomingPatients++;
//     } else if (patient['status'] == 'Accepted') {
//       acceptedPatients++;
//     } else if (patient['status'] == 'Rejected') {
//       rejectedPatients++;
//     }
//   }

//   patientCountMap = {
//     'Total Patients': totalPatients.toDouble(),
//     'Accepted Patients': acceptedPatients.toDouble(),
//     'Upcoming Patients': upcomingPatients.toDouble(),
//     'Rejected Patients': rejectedPatients.toDouble(),
//   };

//   setState(() {});
// }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _loadDoctorData() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         DocumentSnapshot snapshot = await _firestore
//             .collection('CareSync')
//             .doc('doctors')
//             .collection('accounts')
//             .doc(user.uid)
//             .get();
//         if (snapshot.exists) {
//           Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//           setState(() {
//             _patientName = data['name'];
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching doctor data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     // final gradientList = <List<Color>>[
//     //   [
//     //     Color.fromRGBO(10, 201, 244, 1),
//     //     Color.fromRGBO(255, 255, 255, 0.6),
//     //   ],
//     //   [
//     //     Color.fromRGBO(129, 182, 205, 1),
//     //     Color.fromRGBO(91, 253, 199, 1),
//     //   ],
//     //   [
//     //     Color.fromRGBO(104, 238, 190, 1), // Base color
//     //     Color.fromRGBO(104, 238, 190, 0.8),
//     //   ]
//     // ];
//     final gradientList = <List<Color>>[
//   [
//     const Color.fromRGBO(255, 140, 80, 1), // Bright orange
//     const Color.fromRGBO(255, 200, 150, 1), // Soft orange
//   ],
//   [
//     const Color.fromRGBO(150, 80, 200, 1), // Bright purple
//     const Color.fromRGBO(200, 140, 240, 1), // Soft lavender
//   ],
//   [
//     const Color.fromRGBO(60, 170, 240, 1), // Bright sky blue
//     const Color.fromRGBO(140, 220, 255, 1), // Soft sky blue
//   ],
//   [
//     const Color.fromRGBO(50, 210, 190, 1), // Bright teal
//     const Color.fromRGBO(150, 240, 225, 1), // Soft mint
//   ],
//   [
//     const Color.fromRGBO(255, 160, 120, 1), // Bright peach
//     const Color.fromRGBO(255, 210, 180, 1), // Soft peach
//   ],
//   [
//     const Color.fromRGBO(40, 160, 180, 1), // Deep teal
//     const Color.fromRGBO(120, 210, 220, 1), // Lighter teal
//   ],
//   [
//     const Color.fromRGBO(90, 70, 170, 1), // Rich indigo
//     const Color.fromRGBO(160, 130, 210, 1), // Soft indigo
//   ],
// ];

//     return Scaffold(
//       drawer: AppDrawer(
//         isDarkMode: isDarkMode,
//         toggleTheme: () {
//           setState(() {
//             isDarkMode = !isDarkMode;
//           });
//         },
//       ),
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               return Container(
//                 decoration: const BoxDecoration(
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
//               );
//             },
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(0, height * 0.06, 0, 0),
//             child: Column(
//               children: [
//                 _buildAppBar(width),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 _buildWelcomeSection(width, height),

//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         // Remove or reduce the margin of this Container
//                         Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 10),
//                           padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               mainAxisSpacing: 20,
//                               crossAxisSpacing: 30,
//                             ),
//                             itemCount: patientCount.length,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 height: 200,
//                                 width: 200,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       Color.fromRGBO(104, 238, 190, 1),
//                                       Color.fromRGBO(104, 238, 190, 0.8),
//                                       Color.fromRGBO(255, 255, 255, 0.5),
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(15),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.teal.withOpacity(0.3),
//                                       offset: const Offset(5, 5),
//                                       blurRadius: 10,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         patientKey[index],
//                                         textAlign: TextAlign.center,
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 100,
//                                       left: 26,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(25.0),
//                                         height: 100,
//                                         width: 100,
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               Color.fromRGBO(10, 201, 244, 1),
//                                               Color.fromRGBO(
//                                                   255, 255, 255, 0.6),
//                                             ],
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Color.fromRGBO(
//                                                   10, 201, 244, 0.5),
//                                               blurRadius: 10,
//                                               spreadRadius: 5,
//                                               offset: Offset(2, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         child: Text(
//                                           "${patientCount[index][patientKey[index]]}",
//                                           textAlign: TextAlign.center,
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         // Ensure there is no extra padding here
//                         const SizedBox(height:10),
//                         Container(
//                           margin: const EdgeInsets.all(25),
//                           decoration: BoxDecoration(
//                             color: Colors.transparent,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Colors.black,
//                               style: BorderStyle.solid
//                             )
//                           ),
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "Patients Overview",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.w600
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 10),
//                                 child: PieChart(
//                                   chartRadius:
//                                       MediaQuery.of(context).size.width / 1.5,
//                                   dataMap: patientCountMap,
//                                   legendOptions: const LegendOptions(
//                                     showLegendsInRow: false,
//                                     legendPosition: LegendPosition.bottom,
//                                     showLegends: true,
//                                     legendTextStyle: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   baseChartColor: Colors.grey[300]!,
//                                   gradientList: gradientList,
//                                   emptyColorGradient: const [
//                                     Color(0xff6c5ce7),
//                                     Colors.blue,
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
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

//   ////////////////////////////////
//   Widget buildPatientOverview() {
//   return StreamBuilder<List<Map<String, String>>>(
//     stream: appointmentStream(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       } else if (snapshot.hasError) {
//         return Center(
//           child: Text('Error: ${snapshot.error}'),
//         );
//       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//         return const Center(
//           child: Text('No appointments found.'),
//         );
//       } else {
//         final appointmentList = snapshot.data!;
//         updateCounts(appointmentList);

//         return Column(
//           children: [
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 20,
//                 crossAxisSpacing: 30,
//               ),
//               itemCount: patientCount.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   height: 200,
//                   width: 200,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color.fromRGBO(104, 238, 190, 1),
//                         const Color.fromRGBO(104, 238, 190, 0.8),
//                         const Color.fromRGBO(255, 255, 255, 0.5),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.teal.withOpacity(0.3),
//                         offset: const Offset(5, 5),
//                         blurRadius: 10,
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           patientKey[index],
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 100,
//                         left: 26,
//                         child: Container(
//                           padding: const EdgeInsets.all(25.0),
//                           height: 100,
//                           width: 100,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color.fromRGBO(10, 201, 244, 1),
//                                 Color.fromRGBO(255, 255, 255, 0.6),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color.fromRGBO(10, 201, 244, 0.5),
//                                 blurRadius: 10,
//                                 spreadRadius: 5,
//                                 offset: Offset(2, 2),
//                               ),
//                             ],
//                           ),
//                           child: Text(
//                             "${patientCount[index][patientKey[index]]}",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             buildPieChart(),
//           ],
//         );
//       }
//     },
//   );
// }

// Widget buildPieChart() {
//   return Container(
//     margin: const EdgeInsets.all(25),
//     decoration: BoxDecoration(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(
//         color: Colors.black,
//         style: BorderStyle.solid,
//       ),
//     ),
//     child: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Patients Overview",
//             style: GoogleFonts.poppins(
//               fontSize: 25,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: PieChart(
//             chartRadius: MediaQuery.of(context).size.width / 1.5,
//             dataMap: patientCountMap,
//             legendOptions: const LegendOptions(
//               showLegendsInRow: false,
//               legendPosition: LegendPosition.bottom,
//               showLegends: true,
//               legendTextStyle: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             baseChartColor: Colors.grey[300]!,
//             gradientList: gradientList,
//             emptyColorGradient: const [
//               Color(0xff6c5ce7),
//               Colors.blue,
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
// ////////////////////////////////////////

//   Widget _buildAppBar(double width) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Builder(
//           builder: (context) {
//             return IconButton(
//               icon: const Icon(
//                 Icons.menu,
//                 size: 32,
//                 color: Colors.black87,
//               ),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             );
//           },
//         ),
//         const SizedBox(
//           width: 90,
//         ),
//         Text(
//           'CareSync',
//           style: GoogleFonts.poppins(
//             fontSize: 26,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const Spacer(),
//         IconButton(
//           icon: const Icon(
//             Icons.water_drop_rounded,
//             size: 36,
//             color: Colors.red,
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const BloodDetails()),
//             );
//           },
//         ),

//       ],
//     );
//   }

//   Widget _buildWelcomeSection(double width, double height) {
//     return Stack(children: [
//       Container(
//         width: width * 0.9,
//         height: height * 0.25,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.4),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Welcome',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'Dr. $_patientName !',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: 180,
//                   child: Text(
//                     ' How can we assist you today?',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: width * 0.40,
//               // height: height * 0.50,
//               child: Image.asset('assets/Doctor holding gift box.gif', fit: BoxFit.fill),
//             ),
//           ],
//         ),
//       ),
//     ]);
//   }

//   Widget _buildGridItem(int index, String imagePath) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.5),
//           width: 1.5,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             spreadRadius: 1.5,
//             blurRadius: 5,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         image: DecorationImage(
//           image: AssetImage(imagePath),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:caresync/features/blood_donation/presentation/pages/blood_card_page.dart';
import 'package:caresync/features/chat/presentation/pages/chat_patient_list_page.dart';
import 'package:caresync/features/doctors/presentation/widgets/doctor_drawer.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen>
    with SingleTickerProviderStateMixin {
  // Change patients from Future to Stream
  late Stream<List<Map<String, String>>> patients;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isDarkMode = false;
  String _patientName = '';
  late AnimationController _controller;

  final List<String> patientKey = [
    'Total Patients',
    'Accepted Patients',
    'Upcoming Patients',
    'Rejected Patients'
  ];
  int totalPatients = 0;
  int acceptedPatients = 0;
  int rejectedPatients = 0;
  int upcomingPatients = 0;
  Map<String, double> patientCountMap = {
    'Total Patients': 0,
    'Accepted Patients': 0,
    'Upcoming Patients': 0,
    'Rejected Patients': 0,
  };

  final List<List<Color>> gradientList = [
    [
      const Color.fromRGBO(255, 140, 80, 1),
      const Color.fromRGBO(255, 200, 150, 1),
    ],
    [
      const Color.fromRGBO(150, 80, 200, 1),
      const Color.fromRGBO(200, 140, 240, 1),
    ],
    [
      const Color.fromRGBO(60, 170, 240, 1),
      const Color.fromRGBO(140, 220, 255, 1),
    ],
    [
      const Color.fromRGBO(50, 210, 190, 1),
      const Color.fromRGBO(150, 240, 225, 1),
    ],
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   log("initState called");
  //   _controller = AnimationController(
  //     duration: const Duration(seconds: 10),
  //     vsync: this,
  //   )..repeat(reverse: true);
  //   patients = appointmentStream();
  //   patients.listen((appointmentList) {
  //     updateCounts(appointmentList);
  //   }); // Process and update counts
  //   _loadDoctorData();
  // }
  @override
  void initState() {
    super.initState();
    // Directly listen to the stream
    patients = appointmentStream();
    patients.listen(updateCounts); // Listen for updates from the stream
    updateCounts([]); // Initialize the counts (empty list as a fallback)
    _loadDoctorData();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<List<Map<String, String>>> appointmentStream() async {
  //   final currentUser = _auth.currentUser;
  //   final doctorId = currentUser?.uid;

  //   if (doctorId == null) {
  //     print('Error: No logged-in user or invalid doctor ID.');
  //     return [];
  //   }

  //   final querySnapshot = await _firestore
  //       .collection('CareSync')
  //       .doc('doctors')
  //       .collection('accounts')
  //       .doc(doctorId)
  //       .collection('appointments')
  //       .get();

  //   return querySnapshot.docs.map((doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     return {
  //       'status': data['status'] ?? 'unknown',
  //     };
  //   }).toList();
  // }

  Stream<List<Map<String, String>>> appointmentStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final doctorId = currentUser?.uid;

    if (doctorId == null || doctorId.isEmpty) {
      print('Error: No logged-in user or invalid doctor ID.');
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .doc(doctorId)
        .collection('appointments')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?; // Get data safely
        if (data == null) {
          return {
            'status': 'unknown'
          }; // Return a default value if data is null
        }

        // Ensure the 'status' field is treated as a String and fallback to 'unknown' if missing or null
        final status = (data['status'] ?? 'unknown').toString();

        return {
          'status': status
        }; // Return the map with the 'status' field as a String
      }).toList();
    });
  }

  void updateCounts(List<Map<String, String>> appointmentList) {
    totalPatients = appointmentList.length;
    acceptedPatients = 0;
    rejectedPatients = 0;
    upcomingPatients = 0;

    for (var patient in appointmentList) {
      if (patient['status'] == 'pending') {
        upcomingPatients++;
      } else if (patient['status'] == 'Accepted') {
        acceptedPatients++;
      } else if (patient['status'] == 'Rejected') {
        rejectedPatients++;
      }
    }

    patientCountMap = {
      'Total Patients': totalPatients.toDouble(),
      'Accepted Patients': acceptedPatients.toDouble(),
      'Upcoming Patients': upcomingPatients.toDouble(),
      'Rejected Patients': rejectedPatients.toDouble(),
    };

    setState(() {});
  }

  Future<void> _loadDoctorData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await _firestore
            .collection('CareSync')
            .doc('doctors')
            .collection('accounts')
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            _patientName = data['name'] ?? 'Doctor';
          });
        }
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: AppDrawer(
        isDarkMode: isDarkMode,
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
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
              );
            },
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, height * 0.06, 0, 0),
              child: Column(
                children: [
                  _buildAppBar(width),
                  const SizedBox(height: 15),
                  _buildWelcomeSection(width, height),
                  // Pie chart and other UI widgets remain here.
                  StreamBuilder<List<Map<String, String>>>(
                    stream: patients,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final appointmentList = snapshot.data!;

                        // Update the counts directly without calling setState
                        final totalPatients = appointmentList.length;
                        final acceptedPatients = appointmentList
                            .where((patient) => patient['status'] == 'Accepted')
                            .length;
                        final rejectedPatients = appointmentList
                            .where((patient) => patient['status'] == 'Rejected')
                            .length;
                        final upcomingPatients = appointmentList
                            .where((patient) => patient['status'] == 'pending')
                            .length;

                        final patientCountMap = {
                          'Total Patients': totalPatients.toDouble(),
                          'Accepted Patients': acceptedPatients.toDouble(),
                          'Upcoming Patients': upcomingPatients.toDouble(),
                          'Rejected Patients': rejectedPatients.toDouble(),
                        };

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 30,
                                ),
                                itemCount: patientCountMap.length,
                                itemBuilder: (context, index) {
                                  final key = patientKey[index];
                                  return Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(
                                              104, 238, 190, 1),
                                          Color.fromRGBO(
                                              104, 238, 190, 0.8),
                                          Color.fromRGBO(
                                              255, 255, 255, 0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.teal.withOpacity(0.3),
                                          offset: const Offset(5, 5),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            key,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 120,
                                          left: 26,
                                          child: Container(
                                            padding: const EdgeInsets.all(25.0),
                                            height: 120,
                                            width: 120,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      10, 201, 244, 1),
                                                  Color.fromRGBO(
                                                      255, 255, 255, 0.6),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                      10, 201, 244, 0.5),
                                                  blurRadius: 10,
                                                  spreadRadius: 5,
                                                  offset: Offset(2, 2),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              patientCountMap[key]!
                                                  .toInt()
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
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
                            const SizedBox(height: 10),
                            buildPieChart(patientCountMap, context),
                          ],
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPieChart(
      Map<String, double> patientCountMap, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Patients Overview",
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: PieChart(
              chartRadius: MediaQuery.of(context).size.width / 1.5,
              dataMap: patientCountMap,
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              baseChartColor: Colors.grey[300]!,
              gradientList: const [
                [
                  Color.fromRGBO(255, 140, 80, 1), // Bright orange
                  Color.fromRGBO(255, 200, 150, 1), // Soft orange
                ],
                [
                  Color.fromRGBO(150, 80, 200, 1), // Bright purple
                  Color.fromRGBO(200, 140, 240, 1), // Soft lavender
                ],
                [
                  Color.fromRGBO(60, 170, 240, 1), // Bright sky blue
                  Color.fromRGBO(140, 220, 255, 1), // Soft sky blue
                ],
                [
                  Color.fromRGBO(50, 210, 190, 1), // Bright teal
                  Color.fromRGBO(150, 240, 225, 1), // Soft mint
                ],
                [
                  Color.fromRGBO(255, 160, 120, 1), // Bright peach
                  Color.fromRGBO(255, 210, 180, 1), // Soft peach
                ],
                [
                  Color.fromRGBO(40, 160, 180, 1), // Deep teal
                  Color.fromRGBO(120, 210, 220, 1), // Lighter teal
                ],
                [
                  Color.fromRGBO(90, 70, 170, 1), // Rich indigo
                  Color.fromRGBO(160, 130, 210, 1), // Soft indigo
                ],
               
              ],
              emptyColorGradient: const [
                Color(0xff6c5ce7),
                Colors.blue,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets: _buildAppBar and _buildWelcomeSection as in the original code
  Widget _buildAppBar(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 32,
                color: Colors.black87,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        const SizedBox(
          width: 90,
        ),
        Text(
          'CareSync',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.water_drop_rounded,
            size: 36,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BloodDetails()),
            );
          },
        ),
        ///message
         IconButton(
          icon: const Icon(
            Icons.chat_outlined,
            size: 32,
            color: Colors.black87,
          ),
          onPressed: () async {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              final doctorId =
                  currentUser.uid; // Fetch doctorId from Firebase Auth
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PatientListScreen(
                      doctorId: doctorId), // Pass doctorId to PatientListScreen
                ),
              );
            } else {
              print('User is not logged in');
            }
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(double width, double height) {
    return Stack(children: [
      Container(
        width: width * 0.9,
        height: height * 0.25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Dr. $_patientName !',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 180,
                  child: Text(
                    ' How can we assist you today?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: width * 0.40,
              // height: height * 0.50,
              child: Image.asset('assets/Doctor holding gift box.gif',
                  fit: BoxFit.fill),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildGridItem(int index, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1.5,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

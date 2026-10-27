// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';

// import '../model/bloodform.dart';

// class BloodDetails extends StatefulWidget {
//   const BloodDetails({super.key});

//   @override
//   State createState() => _BloodDetailsState();
// }

// // class _BloodDetailsState extends State<BloodDetails> {
// //   late Future<List<BloodDetail>> appointmentListFuture;

// //   @override
// //   void initState() {
// //     super.initState();
// //     appointmentListFuture = fetchAppointments();
// //   }

// //   Future<List<BloodDetail>> fetchAppointments() async {
// //     final currentUser = FirebaseAuth.instance.currentUser;
// //     final patientId = currentUser?.uid ?? '';

// //     List<BloodDetail> appointmentList = [];
// //     bool _isLoading = false;

// //     try {
// //       QuerySnapshot querySnapshot =
// //           await FirebaseFirestore.instance.collection('blood finder').get();
// //       log("Current Patient Id: $patientId");
// //       for (var doc in querySnapshot.docs) {
// //         String uniId = doc.id;
// //         String recipientId = doc['recipientId'];
// //         String recipientFormId = doc['recipientFormId'];
// //         String recipientName = doc['name'];
// //         String phone = doc['phone'];
// //         String address = doc['address'];
// //         String bloodGroup = doc['blood group'];
// //         String status = doc['status'];

// //         log("Current Recipient Id: $recipientId");
// //         if (patientId != recipientId && status == 'pending') {
// //           appointmentList.add(BloodDetail(
// //             Id: uniId,
// //             recipientId: recipientId,
// //             recipientFormId: recipientFormId,
// //             recipientName: recipientName,
// //             contactNo: phone,
// //             address: address,
// //             blood_group: bloodGroup,
// //             status: status,
// //           ));
// //         }
// //       }
// //     } catch (e) {
// //       print('Error fetching details: $e');
// //     }
// //     return appointmentList;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double screenHeight = MediaQuery.of(context).size.height;
// //     double screenWidth = MediaQuery.of(context).size.width;
// //     double itemFontSize = screenWidth * 0.04;

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Container(
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             stops: [0.0, 0.3, 0.7, 1.0],
// //             colors: [
// //               Color.fromRGBO(97, 206, 255, 1),
// //               Colors.white,
// //               Colors.white,
// //               Color.fromRGBO(14, 190, 126, 1),
// //             ],
// //           ),
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.only(
// //             top: screenHeight * 0.06,
// //             left: screenWidth * 0.04,
// //             right: screenWidth * 0.04,
// //           ),
// //           child: Column(
// //             children: [
// //               Row(
// //                 children: [
// //                   GestureDetector(
// //                     onTap: () {
// //                       Navigator.pop(context);
// //                       setState(() {});
// //                     },
// //                     child: Container(
// //                       height: screenWidth * 0.1,
// //                       width: screenWidth * 0.1,
// //                       decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(17),
// //                           color: Colors.transparent,
// //                           border: Border.all(
// //                               color: const Color.fromRGBO(0, 0, 0, 1),
// //                               width: 1)),
// //                       child: const Icon(
// //                         size: 30,
// //                         Icons.arrow_back_ios_new_rounded,
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(
// //                     width: screenWidth * 0.05,
// //                   ),
// //                   Text(
// //                     "Donate Blood",
// //                     style: GoogleFonts.poppins(
// //                       fontSize: screenWidth * 0.07,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               Container(
// //                   margin: const EdgeInsets.all(15),
// //                   padding: const EdgeInsets.all(10),
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       colors: [Colors.red.shade100, Colors.red.shade400],
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                     ),
// //                     borderRadius: BorderRadius.circular(15),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.grey.withOpacity(0.5),
// //                         spreadRadius: 2,
// //                         blurRadius: 5,
// //                         offset:
// //                             const Offset(3, 3), // Changes position of shadow
// //                       ),
// //                     ],
// //                   ),
// //                   child: Lottie.asset("assets/json/donateBlood.json",
// //                       height: 300, width: 300)),
// //               // Center(
// //               //   child: Lottie.asset("assets/json/donateBlood.json")
// //               // ),
// //               Expanded(
// //                 child: FutureBuilder<List<BloodDetail>>(
// //                   future: appointmentListFuture,
// //                   builder: (context, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return const Center(child: CircularProgressIndicator());
// //                     } else if (snapshot.hasError) {
// //                       return Center(child: Text('Error: ${snapshot.error}'));
// //                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                       return Center(
// //                         child: Text(
// //                           'No Blood Requirements.',
// //                           style: GoogleFonts.rubik(
// //                             fontSize: screenWidth * 0.05,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       );
// //                     } else {
// //                       var appointmentList = snapshot.data!;
// //                       return ListView.builder(
// //                         itemCount: appointmentList.length,
// //                         itemBuilder: (context, index) {
// //                           return Padding(
// //                             padding: const EdgeInsets.symmetric(
// //                                 horizontal: 8.0, vertical: 10),
// //                             child: Container(
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white,
// //                                 borderRadius: BorderRadius.circular(12),
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Colors.black.withOpacity(0.4),
// //                                     blurRadius: 8,
// //                                     offset: const Offset(0, 3),
// //                                   ),
// //                                 ],
// //                                 border: Border.all(
// //                                   color: Colors.grey.shade300,
// //                                   width: 1.5,
// //                                 ),
// //                               ),
// //                               padding: const EdgeInsets.all(16),
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     'Recipint Name: ${appointmentList[index].recipientName}',
// //                                     style: GoogleFonts.poppins(
// //                                       fontSize: 16,
// //                                       fontWeight: FontWeight.w600,
// //                                     ),
// //                                   ),

// //                                   const SizedBox(height: 8),
// //                                   Text(
// //                                     'Contact No.: ${appointmentList[index].contactNo}',
// //                                     style: GoogleFonts.poppins(fontSize: 14),
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Text(
// //                                     'Address: ${appointmentList[index].address}',
// //                                     style: GoogleFonts.poppins(fontSize: 14),
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Text(
// //                                     'Required Blood Group: ${appointmentList[index].blood_group}',
// //                                     style: GoogleFonts.poppins(fontSize: 14),
// //                                   ),
// //                                   const SizedBox(height: 4),
// //                                   Text(
// //                                     'Status: ${appointmentList[index].status}',
// //                                     style: GoogleFonts.poppins(
// //                                         fontSize: 15,
// //                                         fontWeight: FontWeight.w600,
// //                                         color: colorText(
// //                                             appointmentList[index].status)),
// //                                   ),

// //                                   GestureDetector(
// //                                     onTap: _isLoading
// //                                         ? null // Disable tap while loading
// //                                         : () {
// //                                             changeStatus(
// //                                               appointmentList[index]
// //                                                   .recipientId,
// //                                               appointmentList[index]
// //                                                   .recipientFormId,
// //                                               appointmentList[index].Id,
// //                                             );
// //                                           },
// //                                     child: Center(
// //                                       child: Container(
// //                                         width: screenWidth * 0.82,
// //                                         margin: const EdgeInsets.all(6),
// //                                         alignment: Alignment.center,
// //                                         padding: const EdgeInsets.symmetric(
// //                                             vertical: 10, horizontal: 15),
// //                                         decoration: BoxDecoration(
// //                                           borderRadius:
// //                                               BorderRadius.circular(20),
// //                                           gradient: const LinearGradient(
// //                                             colors: [Colors.red, Colors.orange],
// //                                             begin: Alignment.topLeft,
// //                                             end: Alignment.bottomRight,
// //                                           ),
// //                                           boxShadow: [
// //                                             BoxShadow(
// //                                               color:
// //                                                   Colors.black.withOpacity(0.2),
// //                                               offset: const Offset(2, 4),
// //                                               blurRadius: 6,
// //                                             ),
// //                                           ],
// //                                         ),
// //                                         child: _isLoading
// //                                             ? const CircularProgressIndicator(
// //                                                 color: Colors.white,
// //                                                 strokeWidth: 2,
// //                                               )
// //                                             : Text(
// //                                                 "Donate",
// //                                                 style: GoogleFonts.poppins(
// //                                                   fontSize: 20,
// //                                                   fontWeight: FontWeight.w600,
// //                                                   color: Colors.white,
// //                                                   shadows: [
// //                                                     Shadow(
// //                                                       offset:
// //                                                           const Offset(1, 1),
// //                                                       blurRadius: 3,
// //                                                       color: Colors.black
// //                                                           .withOpacity(0.3),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                       );
// //                     }
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   bool _isLoading = false;

// //   void changeStatus(
// //       String recipientId, String recipientFormId, String uniId) async {
// //     setState(() {
// //       _isLoading = true; // Start loading
// //     });

// //     try {
// //       // Your existing donation logic
// //       await FirebaseFirestore.instance
// //           .collection('CareSync')
// //           .doc('patients')
// //           .collection('accounts')
// //           .doc(recipientId)
// //           .collection('search blood')
// //           .doc(recipientFormId)
// //           .update({'status': "Accepted"});

// //       await FirebaseFirestore.instance
// //           .collection('blood finder')
// //           .doc(uniId)
// //           .update({'status': "Accepted"});

// //       Navigator.of(context).pushReplacement(
// //         MaterialPageRoute(builder: (context) => const BloodDetails()),
// //       );
// //     } catch (e) {
// //       // Handle errors
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error: ${e.toString()}')),
// //       );
// //     } finally {
// //       setState(() {
// //         _isLoading = false; // Stop loading
// //       });
// //     }
// //   }

// //   dynamic colorText(String status) {
// //     if (status == 'pending') {
// //       return Colors.orange;
// //     } else if (status == 'Accepted') {
// //       return Colors.green;
// //     } else {
// //       return Colors.red;
// //     }
// //   }
// // }

// class _BloodDetailsState extends State<BloodDetails> {
//   late Future<List<BloodDetail>> appointmentListFuture;
//   String? _loadingItemId; // Tracks the ID of the item being processed

//   @override
//   void initState() {
//     super.initState();
//     appointmentListFuture = fetchAppointments();
//   }

//   Future<List<BloodDetail>> fetchAppointments() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final patientId = currentUser?.uid ?? '';

//     List<BloodDetail> appointmentList = [];

//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('blood finder').get();
//       log("Current Patient Id: $patientId");
//       for (var doc in querySnapshot.docs) {
//         String uniId = doc.id;
//         String recipientId = doc['recipientId'];
//         String recipientFormId = doc['recipientFormId'];
//         String recipientName = doc['name'];
//         String phone = doc['phone'];
//         String address = doc['address'];
//         String bloodGroup = doc['blood group'];
//         String status = doc['status'];

//         log("Current Recipient Id: $recipientId");
//         if (patientId != recipientId && status == 'pending') {
//           appointmentList.add(BloodDetail(
//             Id: uniId,
//             recipientId: recipientId,
//             recipientFormId: recipientFormId,
//             recipientName: recipientName,
//             contactNo: phone,
//             address: address,
//             blood_group: bloodGroup,
//             status: status,
//           ));
//         }
//       }
//     } catch (e) {
//       print('Error fetching details: $e');
//     }
//     return appointmentList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         decoration: const BoxDecoration(
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
//           padding: EdgeInsets.only(
//             top: screenHeight * 0.06,
//             left: screenWidth * 0.04,
//             right: screenWidth * 0.04,
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                       setState(() {});
//                     },
//                     child: Container(
//                       height: screenWidth * 0.1,
//                       width: screenWidth * 0.1,
//                       decoration: BoxDecoration(
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
//                   SizedBox(width: screenWidth * 0.05),
//                   Text(
//                     "Donate Blood",
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.07,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: const EdgeInsets.all(15),
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.red.shade100, Colors.red.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(3, 3), // Changes position of shadow
//                     ),
//                   ],
//                 ),
//                 child: Lottie.asset("assets/json/donateBlood.json",
//                     height: 300, width: 300),
//               ),
//               Expanded(
//                 child: FutureBuilder<List<BloodDetail>>(
//                   future: appointmentListFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(
//                         child: Text(
//                           'No Blood Requirements.',
//                           style: GoogleFonts.rubik(
//                             fontSize: screenWidth * 0.05,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       );
//                     } else {
//                       var appointmentList = snapshot.data!;
//                       return ListView.builder(
//                         itemCount: appointmentList.length,
//                         itemBuilder: (context, index) {
//                           final item = appointmentList[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0, vertical: 10),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.4),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                                 border: Border.all(
//                                   color: Colors.grey.shade300,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Recipient Name: ${item.recipientName}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Contact No.: ${item.contactNo}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Address: ${item.address}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Required Blood Group: ${item.blood_group}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Status: ${item.status}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w600,
//                                       color: colorText(item.status),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: _loadingItemId == item.Id
//                                         ? null
//                                         : () {
//                                             changeStatus(
//                                               item.recipientId,
//                                               item.recipientFormId,
//                                               item.Id,
//                                             );
//                                           },
//                                     child: Center(
//                                       child: Container(
//                                         width: screenWidth * 0.82,
//                                         margin: const EdgeInsets.all(6),
//                                         alignment: Alignment.center,
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 10, horizontal: 15),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           gradient: const LinearGradient(
//                                             colors: [Colors.red, Colors.orange],
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                           ),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.black.withOpacity(0.2),
//                                               offset: const Offset(2, 4),
//                                               blurRadius: 6,
//                                             ),
//                                           ],
//                                         ),
//                                         child: _loadingItemId == item.Id
//                                             ? const CircularProgressIndicator(
//                                                 color: Colors.white,
//                                                 strokeWidth: 2,
//                                               )
//                                             : Text(
//                                                 "Donate",
//                                                 style: GoogleFonts.poppins(
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.white,
//                                                   shadows: [
//                                                     Shadow(
//                                                       offset:
//                                                           const Offset(1, 1),
//                                                       blurRadius: 3,
//                                                       color: Colors.black
//                                                           .withOpacity(0.3),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void changeStatus(
//       String recipientId, String recipientFormId, String uniId) async {
//     setState(() {
//       _loadingItemId = uniId; // Start loading for this specific item
//     });

//     try {
//       await FirebaseFirestore.instance
//           .collection('CareSync')
//           .doc('patients')
//           .collection('accounts')
//           .doc(recipientId)
//           .collection('search blood')
//           .doc(recipientFormId)
//           .update({'status': "Accepted"});

//       await FirebaseFirestore.instance
//           .collection('blood finder')
//           .doc(uniId)
//           .update({'status': "Accepted"});

//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const BloodDetails()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         _loadingItemId = null; // Stop loading
//       });
//     }
//   }

//   dynamic colorText(String status) {
//     if (status == 'pending') {
//       return Colors.orange;
//     } else if (status == 'Accepted') {
//       return Colors.green;
//     } else {
//       return Colors.red;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:caresync/features/blood_donation/data/models/blood_form_model.dart';

class BloodDetails extends StatefulWidget {
  const BloodDetails({super.key});

  @override
  State createState() => _BloodDetailsState();
}

class _BloodDetailsState extends State<BloodDetails> {
  String? _loadingItemId; // Tracks the ID of the item being processed

  Stream<List<BloodDetail>> streamAppointments() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final patientId = currentUser?.uid ?? '';

    return FirebaseFirestore.instance
        .collection('blood finder')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.where((doc) {
        String recipientId = doc['recipientId'];
        String status = doc['status'];
        return patientId != recipientId && status == 'pending';
      }).map((doc) {
        return BloodDetail(
          Id: doc.id,
          recipientId: doc['recipientId'],
          recipientFormId: doc['recipientFormId'],
          recipientName: doc['name'],
          contactNo: doc['phone'],
          address: doc['address'],
          blood_group: doc['blood group'],
          status: doc['status'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
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
          padding: EdgeInsets.only(
            top: screenHeight * 0.06,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
          ),
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
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Text(
                    "Donate Blood",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade100, Colors.red.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(3, 3), // Changes position of shadow
                    ),
                  ],
                ),
                child: Lottie.asset("assets/json/donateBlood.json",
                    height: 300, width: 300),
              ),
              Expanded(
                child: StreamBuilder<List<BloodDetail>>(
                  stream: streamAppointments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No Blood Requirements.',
                          style: GoogleFonts.rubik(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    } else {
                      var appointmentList = snapshot.data!;
                      return ListView.builder(
                        itemCount: appointmentList.length,
                        itemBuilder: (context, index) {
                          final item = appointmentList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recipient Name: ${item.recipientName}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Contact No.: ${item.contactNo}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Address: ${item.address}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Required Blood Group: ${item.blood_group}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Status: ${item.status}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: colorText(item.status),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _loadingItemId == item.Id
                                        ? null
                                        : () {
                                            changeStatus(
                                              item.recipientId,
                                              item.recipientFormId,
                                              item.Id,
                                            );
                                          },
                                    child: Center(
                                      child: Container(
                                        width: screenWidth * 0.82,
                                        margin: const EdgeInsets.all(6),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: const LinearGradient(
                                            colors: [Colors.red, Colors.orange],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              offset: const Offset(2, 4),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: _loadingItemId == item.Id
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )
                                            : Text(
                                                "Donate",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      offset:
                                                          const Offset(1, 1),
                                                      blurRadius: 3,
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  void changeStatus (
      String recipientId, String recipientFormId, String uniId) async {
    setState(() {
      _loadingItemId = uniId; // Start loading for this specific item
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid ?? '';
    dynamic name = await fetchAccountFields(userId);
    String donorRole = 'patients';
    if (name == null) {
      name = await fetchDrAccountFields(userId);
      donorRole = 'doctors';
    }
    try {
      await FirebaseFirestore.instance
          .collection('CareSync')
          .doc('patients')
          .collection('accounts')
          .doc(recipientId)
          .collection('search blood')
          .doc(recipientFormId)
          .update({
        'status': "Accepted",
        'donorId': userId,
        'donorName': name,
        'donorRole': donorRole
      });

      await FirebaseFirestore.instance
          .collection('blood finder')
          .doc(uniId)
          .update({
        'status': "Accepted",
        'donorId': userId,
        'donorName': name,
        'donorRole': donorRole
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _loadingItemId = null; // Stop loading
      });
    }
  }

  Future<String?> fetchAccountFields(String userId) async {
  // Fetch the field or return null if not found
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .doc('CareSync/patients/accounts/$userId')
        .get();

    if (snapshot.exists) {
      return snapshot.get('name'); // Assuming the field is 'name'
    }
  } catch (e) {
    print("Error fetching patient account: $e");
  }
  return null;
}

Future<String?> fetchDrAccountFields(String userId) async {
  // Similar logic for fetching doctor account fields
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .doc('CareSync/doctors/accounts/$userId')
        .get();

    if (snapshot.exists) {
      return snapshot.get('name'); // Assuming the field is 'name'
    }
  } catch (e) {
    print("Error fetching doctor account: $e");
  }
  return null;
}


  dynamic colorText(String status) {
    if (status == 'pending') {
      return Colors.orange;
    } else if (status == 'Accepted') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}

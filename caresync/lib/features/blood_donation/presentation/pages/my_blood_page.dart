// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../model/bloodform.dart';

// class MyBloodReq extends StatefulWidget {
//   const MyBloodReq({super.key});

//   @override
//   State createState() => _MyBloodReqState();
// }

// class _MyBloodReqState extends State<MyBloodReq> {
//   late Future<List<BloodDetail>> appointmentListFuture;

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
//       log("In try block");
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
//         if (patientId == recipientId ) {
//           log("In if block");
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
//           log("Data added in list successfully");
//         }
//         log("Outside if");
//       }
//     } catch (e) {
//       log('Error fetching details: $e');
//     }
//     return appointmentList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double itemFontSize = screenWidth * 0.04;

//     return Scaffold(
//       backgroundColor: Colors.white,
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
//                     },
//                     child: Container(
//                         height: screenWidth * 0.1,
//                         width: screenWidth * 0.1,
//                         decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(17),
//                       color: Colors.transparent,
//                       border: Border.all(
//                           color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
//                   child: const Icon(
//                     size: 30,
//                     Icons.arrow_back_ios_new_rounded,
//                     color: Colors.black,
//                   ),),
//                   ),
//                   SizedBox(
//                     width: screenWidth * 0.05,
//                   ),
//                   Text(
//                     "Blood Requirement",
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.07,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top:20,bottom:10),
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
//                 child: Image.asset(
//                   "assets/gif/Blood Donation (2).gif",
//                   height: 200,
//                   width: 200,
//                   // fit: BoxFit.cover, // Ensures the image fits well
//                 ),
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
//                                     'Recipint Name: ${appointmentList[index].recipientName}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   // const SizedBox(height: 4),
//                                   // Text(
//                                   //   'Doctor Name: ${appointmentList[index].doctorName}',
//                                   //   style: GoogleFonts.poppins(
//                                   //     fontSize: 16,
//                                   //     fontWeight: FontWeight.w600,
//                                   //   ),
//                                   // ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Contact No.: ${appointmentList[index].contactNo}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Address: ${appointmentList[index].address}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Required Blood Group: ${appointmentList[index].blood_group}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Status: ${appointmentList[index].status}',
//                                     style: GoogleFonts.poppins(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: colorText(
//                                             appointmentList[index].status)),
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

//   void changeStatus(String recipientId, String recipientFormId, String uniId) async {
//     log("status change patient Id : $recipientId");
//     log("status change patient Form Id : $recipientFormId");
//     log("status change uni Form Id : $uniId");

//     await FirebaseFirestore.instance
//         .collection('CareSync')
//         .doc('patients')
//         .collection('accounts')
//         .doc(recipientId)
//         .collection('search blood')
//         .doc(recipientFormId)
//         .update({'status': "Accepted"});

//     await FirebaseFirestore.instance
//         .collection('blood finder')
//         .doc(uniId)
//         .update({'status': "Accepted"});
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


class MyBloodReq extends StatefulWidget {
  const MyBloodReq({super.key});

  @override
  State createState() => _MyBloodReqState();
}

class _MyBloodReqState extends State<MyBloodReq> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double itemFontSize = screenWidth * 0.04;

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
                            color: const Color.fromRGBO(0, 0, 0, 1), width: 1),
                      ),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  Text(
                    "Blood Requirement",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
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
                child: Image.asset(
                  "assets/gif/Blood Donation (2).gif",
                  height: 200,
                  width: 200,
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('blood finder')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
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
                      final currentUser = FirebaseAuth.instance.currentUser;
                      final patientId = currentUser?.uid ?? '';
                      final docs = snapshot.data!.docs;
                      final filteredDocs = docs.where((doc) {
                        return doc['recipientId'] == patientId;
                      }).toList();

                      if (filteredDocs.isEmpty) {
                        return Center(
                          child: Text(
                            'No Blood Requirements.',
                            style: GoogleFonts.rubik(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
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
                                    'Recipient Name: ${doc['name']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Contact No.: ${doc['phone']}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Address: ${doc['address']}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Required Blood Group: ${doc['blood group']}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  // Text(
                                  //   'Status: ${doc['status']}',
                                  //   style: GoogleFonts.poppins(
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.w600,
                                  //     color: colorText(doc['status']),
                                  //   ),
                                  // ),
                                  doc['status'] != "pending"
                                      ? Column(
                                          children: [
                                            Text(
                                              'Donor Name: ${doc['donorName']}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: colorText(doc['status']),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Donor Role: ${doc['donorRole']}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: colorText(doc['status']),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(width: 0,),
                                      const SizedBox(height: 4),
                                  Text(
                                    'Status: ${doc['status']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: colorText(doc['status']),
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


// class _MyBloodReqState extends State<MyBloodReq> {
//   String? _loadingItemId; // Tracks the ID of the item being processed

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
//               // Header and GIF section...

//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       height: screenWidth * 0.1,
//                       width: screenWidth * 0.1,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(17),
//                         color: Colors.transparent,
//                         border: Border.all(
//                             color: const Color.fromRGBO(0, 0, 0, 1), width: 1),
//                       ),
//                       child: const Icon(
//                         size: 30,
//                         Icons.arrow_back_ios_new_rounded,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: screenWidth * 0.05,
//                   ),
//                   Text(
//                     "Blood Requirement",
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.07,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top: 20, bottom: 10),
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
//                 child: Image.asset(
//                   "assets/gif/Blood Donation (2).gif",
//                   height: 200,
//                   width: 200,
//                 ),
//               ),


//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('blood finder')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
//                       final currentUser = FirebaseAuth.instance.currentUser;
//                       final patientId = currentUser?.uid ?? '';
//                       final docs = snapshot.data!.docs;
//                       final filteredDocs = docs.where((doc) {
//                         return doc['recipientId'] == patientId;
//                       }).toList();

//                       if (filteredDocs.isEmpty) {
//                         return Center(
//                           child: Text(
//                             'No Blood Requirements.',
//                             style: GoogleFonts.rubik(
//                               fontSize: screenWidth * 0.05,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         );
//                       }

//                       return ListView.builder(
//                         itemCount: filteredDocs.length,
//                         itemBuilder: (context, index) {
//                           final doc = filteredDocs[index];
//                           final itemId = doc.id;

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
//                                     'Recipient Name: ${doc['name']}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Contact No.: ${doc['phone']}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Address: ${doc['address']}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Required Blood Group: ${doc['blood group']}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Status: ${doc['status']}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w600,
//                                       color: colorText(doc['status']),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),
//                                   ElevatedButton(
//                                     onPressed: _loadingItemId == itemId
//                                         ? null
//                                         : () => _handleDonateButton(
//                                               doc['recipientId'],
//                                               doc['recipientFormId'],
//                                               itemId,
//                                             ),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red.shade400,
//                                     ),
//                                     child: _loadingItemId == itemId
//                                         ? const SizedBox(
//                                             height: 20,
//                                             width: 20,
//                                             child: CircularProgressIndicator(
//                                               strokeWidth: 2,
//                                               color: Colors.white,
//                                             ),
//                                           )
//                                         : const Text('Donate'),
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

//   Future<void> _handleDonateButton(
//       String recipientId, String recipientFormId, String itemId) async {
//     setState(() {
//       _loadingItemId = itemId; // Mark the clicked item as loading
//     });

//     try {
//       // Perform the donation logic
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
//           .doc(itemId)
//           .update({'status': "Accepted"});
//     } catch (e) {
//       log("Error in donating: $e");
//     } finally {
//       setState(() {
//         _loadingItemId = null; // Clear the loading state after completion
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

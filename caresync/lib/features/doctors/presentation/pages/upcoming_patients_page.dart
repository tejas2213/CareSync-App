// // import 'dart:developer';

// // import 'package:caresync/features/appointments/data/models/doctor_appointment_model.dart';
// // import 'package:caresync/features/appointments/data/models/appointment_model.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class UpcomingPatientScreen extends StatefulWidget {
// //   const UpcomingPatientScreen({super.key});

// //   @override
// //   _UpcomingPatientScreenState createState() => _UpcomingPatientScreenState();
// // }

// // class _UpcomingPatientScreenState extends State<UpcomingPatientScreen> {
// //   late Future<List<DrAppointment>> patients;
// //   String? appId;

// //   @override
// //   void initState() {
// //     super.initState();
// //     patients = fetchAppointments();
// //   }

// //   Future<List<DrAppointment>> fetchAppointments() async {
// //     final currentUser = FirebaseAuth.instance.currentUser;
// //     final doctorId = currentUser?.uid ?? '';

// //     List<DrAppointment> appointmentList = [];

// //     try {
// //       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
// //           .collection('CareSync')
// //           .doc('doctors')
// //           .collection('accounts')
// //           .doc(doctorId)
// //           .collection('appointments')
// //           .get();

// //       for (var doc in querySnapshot.docs) {
// //         String appointmentId = doc.id;
// //         String doctorName = doc['doctorName'];
// //         String name = doc['name'];
// //         String date = doc['date'];
// //         String phone = doc['phone'];
// //         String time = doc['time'];
// //         String status = doc['status'];
// //         String patientId = doc['patientId'];

// //         appointmentList.add(DrAppointment(
// //           appointmentId: appointmentId,
// //           patientId: patientId,
// //           name: name,
// //           date: date,
// //           phone: phone,
// //           time: time,
// //           status: status,
// //         ));
// //       }
// //     } catch (e) {
// //       print('Error fetching appointments: $e');
// //     }
// //     return appointmentList;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double screenHeight = MediaQuery.of(context).size.height;
// //     double screenWidth = MediaQuery.of(context).size.width;

// //     return Scaffold(
// //       body: FutureBuilder<List<DrAppointment>>(
// //         future: patients,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //             return Center(child: Text('No Upcoming Patients'));
// //           } else {
// //             List<DrAppointment> patientList = snapshot.data!;
// //             return Stack(
// //               children: [
// //                 Container(
// //                   decoration: const BoxDecoration(
// //                     gradient: LinearGradient(
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                       stops: [0.0, 0.3, 0.7, 1.0],
// //                       colors: [
// //                         Color.fromRGBO(97, 206, 255, 220),
// //                         Colors.white,
// //                         Colors.white,
// //                         Color.fromRGBO(14, 190, 126, 220),
// //                       ],
// //                     ),
// //                   ),
// //                   child: Padding(
// //                     padding: EdgeInsets.only(top: screenHeight * 0.1),
// //                     child: ListView.builder(
// //                       itemCount: patientList.length,
// //                       itemBuilder: (context, index) {
// //                         final patient = patientList[index];
// //                         return Card(
// //                           elevation: 5,
// //                           shadowColor: Colors.grey.withOpacity(0.3),
// //                           color: Colors.teal[50], // Soft teal background
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius:
// //                                 BorderRadius.circular(24), // Rounded corners
// //                           ),
// //                           margin: EdgeInsets.symmetric(
// //                               horizontal: screenWidth * 0.04,
// //                               vertical: screenHeight * 0.015),
// //                           child: Padding(
// //                             padding: EdgeInsets.all(screenWidth * 0.03),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Row(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     SizedBox(width: screenWidth * 0.03),
// //                                     Expanded(
// //                                       child: Column(
// //                                         crossAxisAlignment:
// //                                             CrossAxisAlignment.start,
// //                                         children: [
// //                                           Text(
// //                                             patient.name,
// //                                             style: TextStyle(
// //                                               fontSize: screenWidth * 0.055,
// //                                               fontWeight: FontWeight.bold,
// //                                               color: Colors.teal[800],
// //                                             ),
// //                                           ),
// //                                           _buildPatientInfo(
// //                                               Icons.call,
// //                                               'Contact Number: ${patient.phone}',
// //                                               Colors.green,
// //                                               screenWidth),
// //                                           _buildPatientInfo(
// //                                               Icons.access_time,
// //                                               'Time: ${patient.time}',
// //                                               Colors.orange,
// //                                               screenWidth),
// //                                           _buildPatientInfo(
// //                                               Icons.calendar_month,
// //                                               'Date: ${patient.date}',
// //                                               Colors.blue,
// //                                               screenWidth),
// //                                           SizedBox(
// //                                               height: screenHeight * 0.015),
// //                                           Row(
// //                                             mainAxisAlignment:
// //                                                 MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               ElevatedButton(
// //                                                 onPressed: () {
// //                                                   // Handle Confirm button action
// //                                                   // changeStatus(1);
// //                                                 },
// //                                                 style: ElevatedButton.styleFrom(
// //                                                   backgroundColor: Colors.green,
// //                                                   padding: EdgeInsets.symmetric(
// //                                                       horizontal:
// //                                                           screenWidth * 0.06,
// //                                                       vertical:
// //                                                           screenHeight * 0.015),
// //                                                   textStyle: TextStyle(
// //                                                       fontSize:
// //                                                           screenWidth * 0.035),
// //                                                 ),
// //                                                 child: Text(
// //                                                   'Confirm',
// //                                                   style: GoogleFonts.poppins(
// //                                                     fontSize: 16,
// //                                                     fontWeight: FontWeight.w600,
// //                                                     color: Colors.white,
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                               ElevatedButton(
// //                                                 onPressed: () {
// //                                                   // Handle Cancel button action
// //                                                 },
// //                                                 style: ElevatedButton.styleFrom(
// //                                                   backgroundColor:
// //                                                       Colors.orange,
// //                                                   padding: EdgeInsets.symmetric(
// //                                                       horizontal:
// //                                                           screenWidth * 0.06,
// //                                                       vertical:
// //                                                           screenHeight * 0.015),
// //                                                   textStyle: TextStyle(
// //                                                       fontSize:
// //                                                           screenWidth * 0.035),
// //                                                 ),
// //                                                 child: Text(
// //                                                   'Cancel',
// //                                                   style: GoogleFonts.poppins(
// //                                                     fontSize: 16,
// //                                                     fontWeight: FontWeight.w600,
// //                                                     color: Colors.white,
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   top: screenHeight * 0.06,
// //                   left: screenWidth * 0.04,
// //                   child: Row(
// //                     children: [
// //                       GestureDetector(
// //                         onTap: () {
// //                           Navigator.pop(context);
// //                         },
// //                         child: Container(
// //                           height: screenWidth * 0.1,
// //                           width: screenWidth * 0.1,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(17),
// //                             color: Colors.white,
// //                           ),
// //                           child: const Icon(
// //                             size: 30,
// //                             Icons.arrow_back_ios_new_rounded,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: screenWidth * 0.05),
// //                       Center(
// //                         child: Text(
// //                           "Upcoming Patients",
// //                           textAlign: TextAlign.center,
// //                           style: GoogleFonts.poppins(
// //                             fontSize: screenWidth * 0.065,
// //                             fontWeight: FontWeight.w600,
// //                             color: Colors.black,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildPatientInfo(
// //       IconData icon, String info, Color color, double screenWidth) {
// //     return Row(
// //       children: [
// //         Icon(icon, color: color, size: screenWidth * 0.045),
// //         SizedBox(width: screenWidth * 0.02),
// //         Text(info, style: TextStyle(fontSize: screenWidth * 0.045)),
// //       ],
// //     );
// //   }

// //   // void changeStatus(int status) async {
// //   //   final currentUser = FirebaseAuth.instance.currentUser;
// //   //   final doctorId = currentUser?.uid ?? '';

// //   //   String changeStatusApp;
// //   //   if (status == 1) {
// //   //     changeStatusApp = "Accepted";
// //   //   } else if (status == 0) {
// //   //     changeStatusApp = "Rejected";
// //   //   }

// //   //   await FirebaseFirestore.instance
// //   //       .collection('CareSync')
// //   //       .doc('doctors')
// //   //       .collection('accounts')
// //   //       .doc(doctorId)
// //   //       .collection('appointments')
// //   //       .doc(appoint);
// //   // }
// // }

// import 'dart:developer';
// import 'package:caresync/features/appointments/data/models/doctor_appointment_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'DoctorHomeScreen.dart';

// class UpcomingPatientScreen extends StatefulWidget {
//   const UpcomingPatientScreen({super.key});

//   @override
//   _UpcomingPatientScreenState createState() => _UpcomingPatientScreenState();
// }

// class _UpcomingPatientScreenState extends State<UpcomingPatientScreen> {
//   late Future<List<DrAppointment>> patients;
//   List<DrAppointment> upcomingPatientList = [];
//   @override
//   void initState() {
//     super.initState();
//     patients = fetchAppointments();
//   }

//   Future<List<DrAppointment>> fetchAppointments() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final doctorId = currentUser?.uid ?? '';

//     List<DrAppointment> appointmentList = [];

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('CareSync')
//           .doc('doctors')
//           .collection('accounts')
//           .doc(doctorId)
//           .collection('appointments')
//           .get();

//       for (var doc in querySnapshot.docs) {
//         String doctorName = doc['doctorName'];
//         String patientAppId = doc['appointmentId'];
//         String name = doc['name'];
//         String date = doc['date'];
//         String phone = doc['phone'];
//         String time = doc['time'];
//         String status = doc['status'];
//         String appointmentId = doc.id;
//         String patientId = doc['patientId'];

//         appointmentList.add(DrAppointment(
//           patientAppId: patientAppId,
//           appointmentId: appointmentId,
//           patientId: patientId,
//           name: name,
//           date: date,
//           phone: phone,
//           time: time,
//           status: status,
//         ));
//       }

//       for (int i = 0; i < appointmentList.length; i++) {
//         if (appointmentList[i].status == 'pending') {
//           log("Pending Pat Id : ${appointmentList[i].patientAppId}  ");
//           upcomingPatientList.add(appointmentList[i]);
//         }
//       }
//     } catch (e) {
//       print('Error fetching appointments: $e');
//     }
//     return appointmentList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;

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
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     height: screenWidth * 0.1,
//                     width: screenWidth * 0.1,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(17),
//                         color: Colors.transparent,
//                         border: Border.all(
//                             color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
//                     child: const Icon(
//                       size: 30,
//                       Icons.arrow_back_ios_new_rounded,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'Upcoming Patients',
//                   style: GoogleFonts.poppins(
//                     fontSize: 27,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//               ],
//             ),
//           ),
//           FutureBuilder<List<DrAppointment>>(
//               future: patients,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError ||
//                     !snapshot.hasData ||
//                     snapshot.data!.isEmpty ||
//                     upcomingPatientList.isEmpty) {
//                   return const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(20.0),
//                       child: Text(
//                         'No Upcoming Appointments yet',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 }

//                 List<DrAppointment> patientList = snapshot.data!;
//                 return Padding(
//                   padding: EdgeInsets.only(top: screenHeight * 0.1),
//                   child: ListView.builder(
//                     itemCount: upcomingPatientList.length,
//                     itemBuilder: (context, index) {
//                       final patient = upcomingPatientList[index];
//                       return Card(
//                         elevation: 5,
//                         shadowColor: Colors.grey.withOpacity(0.3),
//                         color: Colors.teal[50], // Soft teal background
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(24), // Rounded corners
//                         ),
//                         margin: EdgeInsets.symmetric(
//                             horizontal: screenWidth * 0.04,
//                             vertical: screenHeight * 0.015),
//                         child: Padding(
//                           padding: EdgeInsets.all(screenWidth * 0.03),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(width: screenWidth * 0.03),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           patient.name,
//                                           style: TextStyle(
//                                             fontSize: screenWidth * 0.055,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.teal[800],
//                                           ),
//                                         ),
//                                         _buildPatientInfo(
//                                             Icons.call,
//                                             'Contact Number: ${patient.phone}',
//                                             Colors.green,
//                                             screenWidth),
//                                         _buildPatientInfo(
//                                             Icons.access_time,
//                                             'Time: ${patient.time}',
//                                             Colors.orange,
//                                             screenWidth),
//                                         _buildPatientInfo(
//                                             Icons.calendar_month,
//                                             'Date: ${patient.date}',
//                                             Colors.blue,
//                                             screenWidth),
//                                         SizedBox(height: screenHeight * 0.015),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             ElevatedButton(
//                                               onPressed: () async {
//                                                 // Handle Confirm button action
//                                                 await changeStatus(
//                                                   1,
//                                                   upcomingPatientList[index]
//                                                       .appointmentId,
//                                                   upcomingPatientList[index]
//                                                       .patientId,
//                                                   upcomingPatientList[index]
//                                                       .patientAppId,
//                                                 );

//                                                 setState(() {
//                                                   Navigator.of(context)
//                                                       .pushReplacement(
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             const DoctorHomeScreen()),
//                                                   );
//                                                 });
//                                               },
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.green,
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal:
//                                                         screenWidth * 0.06,
//                                                     vertical:
//                                                         screenHeight * 0.015),
//                                                 textStyle: TextStyle(
//                                                     fontSize:
//                                                         screenWidth * 0.035),
//                                               ),
//                                               child: Text(
//                                                 'Confirm',
//                                                 style: GoogleFonts.poppins(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                             ElevatedButton(
//                                               onPressed: () {
//                                                 // Handle Cancel button action

//                                                 log("PAT APP ID FROM DOC: ${patientList[index].patientAppId}");
//                                                 changeStatus(
//                                                   0,
//                                                   upcomingPatientList[index]
//                                                       .appointmentId,
//                                                   upcomingPatientList[index]
//                                                       .patientId,
//                                                   upcomingPatientList[index]
//                                                       .patientAppId,
//                                                 );
//                                                 setState(() {
//                                                   Navigator.of(context)
//                                                       .pushReplacement(
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             const DoctorHomeScreen()),
//                                                   );
//                                                 });
//                                               },
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.orange,
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal:
//                                                         screenWidth * 0.06,
//                                                     vertical:
//                                                         screenHeight * 0.015),
//                                                 textStyle: TextStyle(
//                                                     fontSize:
//                                                         screenWidth * 0.035),
//                                               ),
//                                               child: Text(
//                                                 'Cancel',
//                                                 style: GoogleFonts.poppins(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               }),
//         ],
//       ),
//     );
//   }

//   Widget _buildPatientInfo(
//       IconData icon, String info, Color color, double screenWidth) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: screenWidth * 0.045),
//         SizedBox(width: screenWidth * 0.02),
//         Text(info, style: TextStyle(fontSize: screenWidth * 0.045)),
//       ],
//     );
//   }

//   Future<void> changeStatus(int status, String appointmentId, String patientId,
//       String patientAppId) async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final doctorId = currentUser?.uid ?? '';
//     log("---------------$patientId");
//     String? changeStatusApp;
//     if (status == 1) {
//       changeStatusApp = "Accepted";
//     } else if (status == 0) {
//       changeStatusApp = "Rejected";
//     }
//     log("---------------appointment id of petient$appointmentId");
//     log("Patient app id: $patientAppId");
//     log("STatus : $changeStatusApp");
//     await FirebaseFirestore.instance
//         .collection('CareSync')
//         .doc('doctors')
//         .collection('accounts')
//         .doc(doctorId)
//         .collection('appointments')
//         .doc(appointmentId)
//         .update({'status': changeStatusApp});

//     await FirebaseFirestore.instance
//         .collection('CareSync')
//         .doc('patients')
//         .collection('accounts')
//         .doc(patientId)
//         .collection('appointments')
//         .doc(patientAppId)
//         .update({'status': changeStatusApp});
//   }
// }

import 'package:caresync/features/appointments/data/models/doctor_appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'doctor_home_page.dart';

class UpcomingPatientScreen extends StatefulWidget {
  const UpcomingPatientScreen({super.key});

  @override
  _UpcomingPatientScreenState createState() => _UpcomingPatientScreenState();
}

class _UpcomingPatientScreenState extends State<UpcomingPatientScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
            child: Row(
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
                            color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
                    child: const Icon(
                      size: 30,
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  'Upcoming Patients',
                  style: GoogleFonts.poppins(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('CareSync')
                .doc('doctors')
                .collection('accounts')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('appointments')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No Upcoming Appointments yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              

              List<DrAppointment> upcomingPatientList = snapshot.data!.docs
                  .map((doc) => DrAppointment(
                        patientAppId: doc['appointmentId'],
                        appointmentId: doc.id,
                        patientId: doc['patientId'],
                        name: doc['name'],
                        date: doc['date'],
                        phone: doc['phone'],
                        time: doc['time'],
                        status: doc['status'],
                      ))
                  .where((appointment) => appointment.status == 'pending')
                  .toList();

              if (upcomingPatientList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No Upcoming Appointments yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.1),
                child: ListView.builder(
                  itemCount: upcomingPatientList.length,
                  itemBuilder: (context, index) {
                    final patient = upcomingPatientList[index];
                    return Card(
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(0.3),
                      color: Colors.teal[50], // Soft teal background
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(24), // Rounded corners
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.015),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: screenWidth * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient.name,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.055,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal[800],
                                        ),
                                      ),
                                      _buildPatientInfo(
                                          Icons.call,
                                          'Contact Number: ${patient.phone}',
                                          Colors.green,
                                          screenWidth),
                                      _buildPatientInfo(
                                          Icons.access_time,
                                          'Time: ${patient.time}',
                                          Colors.orange,
                                          screenWidth),
                                      _buildPatientInfo(
                                          Icons.calendar_month,
                                          'Date: ${patient.date}',
                                          Colors.blue,
                                          screenWidth),
                                      SizedBox(height: screenHeight * 0.015),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              // Handle Confirm button action
                                              await changeStatus(
                                                1,
                                                upcomingPatientList[index]
                                                    .appointmentId,
                                                upcomingPatientList[index]
                                                    .patientId,
                                                upcomingPatientList[index]
                                                    .patientAppId,
                                              );

                                              setState(() {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DoctorHomeScreen()),
                                                );
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.06,
                                                  vertical:
                                                      screenHeight * 0.015),
                                              textStyle: TextStyle(
                                                  fontSize:
                                                      screenWidth * 0.035),
                                            ),
                                            child: Text(
                                              'Confirm',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Handle Cancel button action

                                              // log("PAT APP ID FROM DOC: ${patientList[index].patientAppId}");
                                              changeStatus(
                                                0,
                                                upcomingPatientList[index]
                                                    .appointmentId,
                                                upcomingPatientList[index]
                                                    .patientId,
                                                upcomingPatientList[index]
                                                    .patientAppId,
                                              );
                                              setState(() {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DoctorHomeScreen()),
                                                );
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.06,
                                                  vertical:
                                                      screenHeight * 0.015),
                                              textStyle: TextStyle(
                                                  fontSize:
                                                      screenWidth * 0.035),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo(
      IconData icon, String info, Color color, double screenWidth) {
    return Row(
      children: [
        Icon(icon, color: color, size: screenWidth * 0.045),
        SizedBox(width: screenWidth * 0.02),
        Text(info, style: TextStyle(fontSize: screenWidth * 0.045)),
      ],
    );
  }

  Future<void> changeStatus(int status, String appointmentId, String patientId,
      String patientAppId) async {
    String changeStatusApp = (status == 1) ? "Accepted" : "Rejected";

    await FirebaseFirestore.instance
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': changeStatusApp});

    await FirebaseFirestore.instance
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('appointments')
        .doc(patientAppId)
        .update({'status': changeStatusApp});
  }
}

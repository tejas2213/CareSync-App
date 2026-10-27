// import 'package:caresync/features/appointments/data/models/appointment_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Myappointments extends StatefulWidget {
//   const Myappointments({super.key});

//   @override
//   State createState() => _MyappointmentsState();
// }

// class _MyappointmentsState extends State<Myappointments> {
//   late Future<List<MyAppointment>> appointmentListFuture;

//   @override
//   void initState() {
//     super.initState();
//     appointmentListFuture = fetchAppointments();
//   }

//   Future<List<MyAppointment>> fetchAppointments() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final patientId = currentUser?.uid ?? '';

//     List<MyAppointment> appointmentList = [];

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('CareSync')
//           .doc('patients')
//           .collection('accounts')
//           .doc(patientId)
//           .collection('appointments')
//           .get();

//       for (var doc in querySnapshot.docs) {
//         String doctorId = doc.id;
//         String doctorName = doc['doctorName'];
//         String name = doc['name'];
//         String date = doc['date'];
//         String phone = doc['phone'];
//         String time = doc['time'];
//         String status = doc['status'];

//         appointmentList.add(MyAppointment(
//           doctorId: doctorId,
//           name: name,
//           doctorName: doctorName,
//           date: date,
//           phone: phone,
//           time: time,
//           status: status,
//         ));
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
//     double itemFontSize = screenWidth * 0.04;

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
//                   SizedBox(
//                     width: screenWidth * 0.05,
//                   ),
//                   Text(
//                     "My Appointments",
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.07,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: FutureBuilder<List<MyAppointment>>(
//                   future: appointmentListFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(
//                         child: Text(
//                           'No Appointments are booked.',
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
//                                     'Patient Name: ${appointmentList[index].name}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Doctor Name: ${appointmentList[index].doctorName}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Contact No.: ${appointmentList[index].phone}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Date: ${appointmentList[index].date}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Time: ${appointmentList[index].time}',
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




// class _MyappointmentsState extends State<Myappointments> {
//   List<MyAppointment> appointmentList = [];

//   Future<List<MyAppointment>> fetchAppointments() async {

  
//   final currentUser = FirebaseAuth.instance.currentUser;
//   final patientId = currentUser?.uid ?? '';
//         // Store user information in Firestore
//   try {
//     // Reference to the Firestore collection
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('CareSync')
//         .doc('patients')
//         .collection('accounts')
//         .doc(patientId)
//         .collection('appointments')
//         .get();

//     // Extracting required fields from each document
//     for (var doc in querySnapshot.docs) {
//       String doctorId = doc.id; 
//       String doctorName = doc['doctorName'];
//       String name = doc['name'];
//       String date = doc['date'];
//       String phone = doc['phone'];
//       String time = doc['time'];
//       String status = doc['status'];

//       // Adding to the local list
//       appointmentList.add(MyAppointment(
//         doctorId: doctorId,
//         name: name,
//         doctorName: doctorName,
//         date: date,
//         phone: phone,
//         time: time,
//         status: status,
//       ));
//     }
//   } catch (e) {
//     print('Error fetching doctors: $e');
//   }
//   return appointmentList;
// }

//   @override
//   void initState() async {
//     super.initState();
//     appointmentList = await fetchAppointments();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double itemFontSize = screenWidth * 0.04;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color.fromRGBO(97, 206, 255, 220),
//               Colors.white,
//               Colors.white,
//               Color.fromRGBO(14, 190, 126, 220),
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
//                           borderRadius: BorderRadius.circular(17),
//                           color: Colors.white,
//                         ),
//                         child: const Icon(
//                           size: 30,
//                           Icons.arrow_back_ios_new_rounded,
//                           color: Colors.grey,
//                         )),
//                   ),
//                   SizedBox(
//                     width: screenWidth * 0.05,
//                   ),
//                   Text(
//                     widget.drSpeciality,
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.07,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: appointmentList.isEmpty
//                     ? Center(
//                         child: Text(
//                           'No Appointments are booked.',
//                           style: GoogleFonts.roboto(
//                             fontSize: itemFontSize,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       )
//                     : ListView.builder(
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
//                                     'Patient Name: ${appointmentList[index].name}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Contact No.: ${appointmentList[index].phone}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Date: ${appointmentList[index].date}   Time: ${appointmentList[index].time}',
//                                     style: GoogleFonts.poppins(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Appointment Booked with doctor: ${appointmentList[index].doctorName}',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       color: appointmentList[index].status == 'Pending'
//                                           ? Colors.orange
//                                           : Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:caresync/features/appointments/data/models/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  State createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  /// Stream to fetch real-time appointment updates
  Stream<List<MyAppointment>> fetchAppointmentsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final patientId = currentUser?.uid ?? '';

    return FirebaseFirestore.instance
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('appointments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MyAppointment(
          doctorId: doc.id,
          name: doc['name'] ?? 'Unknown',
          doctorName: doc['doctorName'] ?? 'Unknown',
          date: doc['date'] ?? 'Unknown',
          phone: doc['phone'] ?? 'Unknown',
          time: doc['time'] ?? 'Unknown',
          status: doc['status'] ?? 'Unknown',
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
              // AppBar Section
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
                        Icons.arrow_back_ios_new_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Text(
                    "My Appointments",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Appointment List Section
              Expanded(
                child: StreamBuilder<List<MyAppointment>>(
                  stream: fetchAppointmentsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No Appointments are booked.',
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
                                    'Patient Name: ${appointmentList[index].name}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Doctor Name: ${appointmentList[index].doctorName}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Contact No.: ${appointmentList[index].phone}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Date: ${appointmentList[index].date}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Time: ${appointmentList[index].time}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Status: ${appointmentList[index].status}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: colorText(
                                          appointmentList[index].status),
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

  /// Color for status text
  Color colorText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}

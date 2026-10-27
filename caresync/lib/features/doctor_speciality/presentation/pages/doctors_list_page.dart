// import 'package:caresync/features/appointments/presentation/pages/book_appointment_page.dart';
// import 'package:caresync/features/doctor_speciality/data/models/doctor_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class DoctorListScreen extends StatefulWidget {
//   final String drSpeciality;
//   final int selectedIndex;

//   const DoctorListScreen(
//       {super.key, required this.drSpeciality, required this.selectedIndex});

//   @override
//   _DoctorListScreenState createState() => _DoctorListScreenState();
// }

// Future<List<Doctor>> fetchDoctors() async {
//   List<Doctor> doctorList = [];
//   try {
//     // Reference to the Firestore collection
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('CareSync')
//         .doc('doctors')
//         .collection('accounts')
//         .get();

//     // Extracting required fields from each document
//     for (var doc in querySnapshot.docs) {
//       String doctorId = doc.id;
//       String name = doc['name'];
//       String clinicLocation = doc['cliniclocation'];
//       String specialization = doc['specialization'];
//       String imageUrl = doc['imageUrl'];

//       // Adding to the local list
//       doctorList.add(Doctor(
//         doctorId: doctorId,
//         name: name,
//         clinicName: clinicLocation,
//         specialization: specialization,
//         imageUrl: imageUrl,
//       ));
//     }
//   } catch (e) {
//     print('Error fetching doctors: $e');
//   }
//   return doctorList;
// }

// List<Map<String, dynamic>> drSpecialisation = [
//   {
//     'image': "assets/svg/specialisation/Cardiology Specialties Button # 4.svg",
//     'route': const DoctorListScreen(
//       drSpeciality: "Cardiology",
//       selectedIndex: 0,
//     )
//   },
//   {
//     'image': "assets/svg/specialisation/Dermatology Specialties Button # 3.svg",
//     'route':
//         const DoctorListScreen(drSpeciality: "Dermatology", selectedIndex: 1)
//   },
//   {
//     'image': "assets/svg/specialisation/Specialties Button # 1 (1).svg",
//     'route': const DoctorListScreen(
//         drSpeciality: "General Medicine", selectedIndex: 2)
//   },
//   {
//     'image': "assets/svg/specialisation/Gynecology Specialties Button # 10.svg",
//     'route':
//         const DoctorListScreen(drSpeciality: "Gynecology", selectedIndex: 3)
//   },
//   {
//     'image': "assets/svg/specialisation/Odontology Specialties Button # 12.svg",
//     'route':
//         const DoctorListScreen(drSpeciality: "Odontology", selectedIndex: 4)
//   },
//   {
//     'image': "assets/svg/specialisation/Oncology Specialties Button # 11.svg",
//     'route': const DoctorListScreen(drSpeciality: "Oncology", selectedIndex: 5)
//   },
//   {
//     'image': "assets/svg/specialisation/Ophtamology Specialties Button # 2.svg",
//     'route':
//         const DoctorListScreen(drSpeciality: "Ophthalmology", selectedIndex: 6)
//   },
//   {
//     'image':
//         "assets/svg/specialisation/Orthopedics Specialties Button # 13.svg",
//     'route':
//         const DoctorListScreen(drSpeciality: "Orthopedics", selectedIndex: 7)
//   },
// ];

// class _DoctorListScreenState extends State<DoctorListScreen> {
//   late Future<List<Doctor>> doctorsFuture;

//   @override
//   void initState() {
//     super.initState();
//     doctorsFuture = fetchDoctors();
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
//         child: Hero(
//           tag: "loc-doctor-${drSpecialisation[widget.selectedIndex]['image']}",
//           child: Padding(
//             padding: EdgeInsets.only(
//               top: screenHeight * 0.06,
//               left: screenWidth * 0.04,
//               right: screenWidth * 0.04,
//             ),
//             child: Column(
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
//                         borderRadius: BorderRadius.circular(17),
//                         color: Colors.transparent,
//                         border: Border.all(
//                             color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
//                     child: const Icon(
//                       size: 30,
//                       Icons.arrow_back_ios_new_rounded,
//                       color: Colors.black,
//                     ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: screenWidth * 0.05,
//                     ),
//                     Text(
//                       widget.drSpeciality,
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: FutureBuilder<List<Doctor>>(
//                     future: doctorsFuture,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (snapshot.hasError ||
//                           !snapshot.hasData ||
//                           snapshot.data!.isEmpty) {
//                         return const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Text(
//                               'No doctors are available',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       }

//                       List<Doctor> doctorList = snapshot.data!
//                           .where((doctor) =>
//                               doctor.specialization == widget.drSpeciality)
//                           .toList();

//                       if (doctorList.isEmpty) {
//                         return const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Text(
//                               'No doctors are available',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//                       return ListView.builder(
//                         padding: const EdgeInsets.all(16.0),
//                         itemCount: doctorList.length,
//                         itemBuilder: (context, index) {
//                           final doctor = doctorList[index];
//                           return Container(
//                             margin: EdgeInsets.only(top: screenHeight * 0.02),
//                             padding: EdgeInsets.all(screenWidth * 0.04),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               gradient: const LinearGradient(
//                                 colors: [
//                                   Colors.white,
//                                   Color.fromRGBO(240, 255, 249, 1)
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black
//                                       .withOpacity(0.2), // Adjust shadow color
//                                   blurRadius:
//                                       15, // Spread the shadow for a softer effect
//                                   spreadRadius:
//                                       3, // Increase spread for wider shadow
//                                   offset: const Offset(
//                                       0, 8), // Position shadow slightly below
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       height: screenHeight * 0.13,
//                                       width: screenWidth * 0.25,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color:
//                                                 Colors.black.withOpacity(0.15),
//                                             blurRadius: 8,
//                                             spreadRadius: 2,
//                                             offset: const Offset(0, 4),
//                                           ),
//                                         ],
//                                       ),
//                                       clipBehavior: Clip.antiAlias,
//                                       child: Image.network(
//                                         doctor.imageUrl,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: screenWidth * 0.04),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Dr. ${doctor.name}",
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: screenWidth * 0.05,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black87,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.location_on_rounded,
//                                                   size: screenWidth * 0.05,
//                                                   color: Colors.black54,
//                                                 ),
//                                                 SizedBox(
//                                                     width: screenWidth * 0.02),
//                                                 Text(
//                                                   doctor.clinicName,
//                                                   style: GoogleFonts.poppins(
//                                                     fontSize:
//                                                         screenWidth * 0.045,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: Colors.black54,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                     Icons
//                                                         .local_hospital_rounded,
//                                                     size: screenWidth * 0.05,
//                                                     color: Colors.grey),
//                                                 SizedBox(
//                                                     width: screenWidth * 0.02),
//                                                 Text(
//                                                   doctor.specialization,
//                                                   style: GoogleFonts.poppins(
//                                                     fontSize:
//                                                         screenWidth * 0.042,
//                                                     fontWeight: FontWeight.w400,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: screenHeight * 0.02),
//                                 Center(
//                                   child: SizedBox(
//                                     width: screenWidth * 0.6,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 BookAppointment(
//                                               doctorId: doctor.doctorId,
//                                               doctorName: doctor.name,
//                                               clinicName: doctor.clinicName,
//                                               specialty: doctor.specialization,
//                                               doctorImage: doctor.imageUrl,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         elevation: 8,
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: screenHeight * 0.018),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(25),
//                                         ),
//                                         backgroundColor: Colors.transparent,
//                                         shadowColor:
//                                             Colors.greenAccent.withOpacity(0.3),
//                                       ),
//                                       child: Ink(
//                                         decoration: BoxDecoration(
//                                           gradient: const LinearGradient(
//                                             colors: [
//                                               Color(0xFF12C2E9), // Light Blue
//                                               Color(0xFF3CBA92), // Teal
//                                               Color(0xFF0F9B0F), // Green
//                                             ],
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(25),
//                                         ),
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: screenHeight * 0.018),
//                                           child: Text(
//                                             'Book Appointment',
//                                             style: GoogleFonts.poppins(
//                                               fontSize: screenWidth * 0.045,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               shadows: const [
//                                                 Shadow(
//                                                   blurRadius: 4,
//                                                   color: Colors.black26,
//                                                   offset: Offset(1, 2),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
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
//         ),
//       ),
//     );
//   }
// }

// class _DoctorListScreenState extends State<DoctorListScreen> {
//   Stream<List<Doctor>> fetchDoctorsStream() {
//     return FirebaseFirestore.instance
//         .collection('CareSync')
//         .doc('doctors')
//         .collection('accounts')
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return Doctor(
//           doctorId: doc.id,
//           name: doc['name'],
//           clinicName: doc['cliniclocation'],
//           specialization: doc['specialization'],
//           imageUrl: doc['imageUrl'],
//         );
//       }).toList();
//     });
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
//         child: Hero(
//           tag: "loc-doctor-${drSpecialisation[widget.selectedIndex]['image']}",
//           child: Padding(
//             padding: EdgeInsets.only(
//               top: screenHeight * 0.06,
//               left: screenWidth * 0.04,
//               right: screenWidth * 0.04,
//             ),
//             child: Column(
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
//                               color: const Color.fromRGBO(0, 0, 0, 1), width: 1),
//                         ),
//                         child: const Icon(
//                           size: 30,
//                           Icons.arrow_back_ios_new_rounded,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: screenWidth * 0.05,
//                     ),
//                     Text(
//                       widget.drSpeciality,
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.07,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: StreamBuilder<List<Doctor>>(
//                     stream: fetchDoctorsStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (snapshot.hasError ||
//                           !snapshot.hasData ||
//                           snapshot.data!.isEmpty) {
//                         return const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Text(
//                               'No doctors are available',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       }

//                       List<Doctor> doctorList = snapshot.data!
//                           .where((doctor) =>
//                               doctor.specialization == widget.drSpeciality)
//                           .toList();

//                       if (doctorList.isEmpty) {
//                         return const Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Text(
//                               'No doctors are available',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       }

//                       return ListView.builder(
//                         padding: const EdgeInsets.all(16.0),
//                         itemCount: doctorList.length,
//                         itemBuilder: (context, index) {
//                           final doctor = doctorList[index];
//                           return Container(
//                             margin: EdgeInsets.only(top: screenHeight * 0.02),
//                             padding: EdgeInsets.all(screenWidth * 0.04),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               gradient: const LinearGradient(
//                                 colors: [
//                                   Colors.white,
//                                   Color.fromRGBO(240, 255, 249, 1)
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 15,
//                                   spreadRadius: 3,
//                                   offset: const Offset(0, 8),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       height: screenHeight * 0.13,
//                                       width: screenWidth * 0.25,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color:
//                                                 Colors.black.withOpacity(0.15),
//                                             blurRadius: 8,
//                                             spreadRadius: 2,
//                                             offset: const Offset(0, 4),
//                                           ),
//                                         ],
//                                       ),
//                                       clipBehavior: Clip.antiAlias,
//                                       child: Image.network(
//                                         doctor.imageUrl,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: screenWidth * 0.04),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Dr. ${doctor.name}",
//                                               style: GoogleFonts.poppins(
//                                                 fontSize: screenWidth * 0.05,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black87,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                   Icons.location_on_rounded,
//                                                   size: screenWidth * 0.05,
//                                                   color: Colors.black54,
//                                                 ),
//                                                 SizedBox(
//                                                     width: screenWidth * 0.02),
//                                                 Text(
//                                                   doctor.clinicName,
//                                                   style: GoogleFonts.poppins(
//                                                     fontSize:
//                                                         screenWidth * 0.045,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: Colors.black54,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Row(
//                                               children: [
//                                                 Icon(
//                                                     Icons
//                                                         .local_hospital_rounded,
//                                                     size: screenWidth * 0.05,
//                                                     color: Colors.grey),
//                                                 SizedBox(
//                                                     width: screenWidth * 0.02),
//                                                 Text(
//                                                   doctor.specialization,
//                                                   style: GoogleFonts.poppins(
//                                                     fontSize:
//                                                         screenWidth * 0.042,
//                                                     fontWeight: FontWeight.w400,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: screenHeight * 0.02),
//                                 Center(
//                                   child: SizedBox(
//                                     width: screenWidth * 0.6,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 BookAppointment(
//                                               doctorId: doctor.doctorId,
//                                               doctorName: doctor.name,
//                                               clinicName: doctor.clinicName,
//                                               specialty: doctor.specialization,
//                                               doctorImage: doctor.imageUrl,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         elevation: 8,
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: screenHeight * 0.018),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(25),
//                                         ),
//                                         backgroundColor: Colors.transparent,
//                                         shadowColor:
//                                             Colors.greenAccent.withOpacity(0.3),
//                                       ),
//                                       child: Ink(
//                                         decoration: BoxDecoration(
//                                           gradient: const LinearGradient(
//                                             colors: [
//                                               Color(0xFF12C2E9),
//                                               Color(0xFF3CBA92),
//                                               Color(0xFF0F9B0F),
//                                             ],
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(25),
//                                         ),
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: screenHeight * 0.018),
//                                           child: Text(
//                                             'Book Appointment',
//                                             style: GoogleFonts.poppins(
//                                               fontSize: screenWidth * 0.045,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               shadows: const [
//                                                 Shadow(
//                                                   blurRadius: 4,
//                                                   color: Colors.black26,
//                                                   offset: Offset(1, 2),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
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
//         ),
//       ),
//     );
//   }
// }

import 'package:caresync/features/appointments/presentation/pages/book_appointment_page.dart';
import 'package:caresync/features/doctor_speciality/data/models/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DoctorListScreen extends StatefulWidget {
  final String drSpeciality;
  final int selectedIndex;

  const DoctorListScreen({
    super.key,
    required this.drSpeciality,
    required this.selectedIndex,
  });

  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  /// Stream to fetch doctors in real-time
  Stream<List<Doctor>> fetchDoctorsStream() {
    return FirebaseFirestore.instance
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Doctor(
          doctorId: doc.id,
          name: doc['name'] ?? 'Unknown',
          clinicName: doc['cliniclocation'] ?? 'Unknown location',
          specialization: doc['specialization'] ?? 'General',
          imageUrl: doc['imageUrl'] ?? '',
        );
      }).toList();
    });
  }

  List<Map<String, dynamic>> drSpecialisation = [
    {
      'image':
          "assets/svg/specialisation/Cardiology Specialties Button # 4.svg",
      'route': const DoctorListScreen(
        drSpeciality: "Cardiology",
        selectedIndex: 0,
      )
    },
    {
      'image':
          "assets/svg/specialisation/Dermatology Specialties Button # 3.svg",
      'route':
          const DoctorListScreen(drSpeciality: "Dermatology", selectedIndex: 1)
    },
    {
      'image': "assets/svg/specialisation/Specialties Button # 1 (1).svg",
      'route': const DoctorListScreen(
          drSpeciality: "General Medicine", selectedIndex: 2)
    },
    {
      'image':
          "assets/svg/specialisation/Gynecology Specialties Button # 10.svg",
      'route':
          const DoctorListScreen(drSpeciality: "Gynecology", selectedIndex: 3)
    },
    {
      'image':
          "assets/svg/specialisation/Odontology Specialties Button # 12.svg",
      'route':
          const DoctorListScreen(drSpeciality: "Odontology", selectedIndex: 4)
    },
    {
      'image': "assets/svg/specialisation/Oncology Specialties Button # 11.svg",
      'route':
          const DoctorListScreen(drSpeciality: "Oncology", selectedIndex: 5)
    },
    {
      'image':
          "assets/svg/specialisation/Ophtamology Specialties Button # 2.svg",
      'route': const DoctorListScreen(
          drSpeciality: "Ophthalmology", selectedIndex: 6)
    },
    {
      'image':
          "assets/svg/specialisation/Orthopedics Specialties Button # 13.svg",
      'route':
          const DoctorListScreen(drSpeciality: "Orthopedics", selectedIndex: 7)
    },
  ];

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
                            color: const Color.fromRGBO(0, 0, 0, 1), width: 1),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Text(
                    widget.drSpeciality,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Doctor List Section
              Expanded(
                child: StreamBuilder<List<Doctor>>(
                  stream: fetchDoctorsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error loading doctors.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No doctors are available.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    List<Doctor> doctorList = snapshot.data!
                        .where((doctor) =>
                            doctor.specialization == widget.drSpeciality)
                        .toList();

                    if (doctorList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                               tag: "loc-doctor-${drSpecialisation[widget.selectedIndex]['image']}",
                              child: Lottie.asset("assets/json/noDr.json",height:200),
                            ),
                            const Text(
                              'No doctors found in this specialty.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // return ListView.builder(
                    //   itemCount: doctorList.length,
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   itemBuilder: (context, index) {
                    //     final doctor = doctorList[index];
                    //     return Card(
                    //       elevation: 5,
                    //       margin: const EdgeInsets.symmetric(
                    //           vertical: 8.0, horizontal: 10.0),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       child: ListTile(
                    //         contentPadding: const EdgeInsets.all(15),
                    //         leading: ClipRRect(
                    //           borderRadius: BorderRadius.circular(12),
                    //           child: Image.network(
                    //             doctor.imageUrl,
                    //             width: 70,
                    //             height: 70,
                    //             fit: BoxFit.cover,
                    //             errorBuilder: (context, error, stackTrace) =>
                    //                 const Icon(Icons.error, size: 50),
                    //           ),
                    //         ),
                    //         title: Text(
                    //           "Dr. ${doctor.name}",
                    //           style: GoogleFonts.poppins(
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         subtitle: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               doctor.clinicName,
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: 14,
                    //                 color: Colors.black54,
                    //               ),
                    //             ),
                    //             const SizedBox(height: 4),
                    //             Text(
                    //               doctor.specialization,
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: 14,
                    //                 color: Colors.grey,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         trailing: ElevatedButton(
                    //           onPressed: () {
                    //             Navigator.of(context).push(
                    //               MaterialPageRoute(
                    //                 builder: (context) => BookAppointment(
                    //                   doctorId: doctor.doctorId,
                    //                   doctorName: doctor.name,
                    //                   clinicName: doctor.clinicName,
                    //                   specialty: doctor.specialization,
                    //                   doctorImage: doctor.imageUrl,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(20),
                    //             ),
                    //             backgroundColor: Colors.green,
                    //           ),
                    //           child: const Text("Book"),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // );
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: doctorList.length,
                      itemBuilder: (context, index) {
                        final doctor = doctorList[index];
                        return Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.02),
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.white,
                                Color.fromRGBO(240, 255, 249, 1)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Adjust shadow color
                                blurRadius:
                                    15, // Spread the shadow for a softer effect
                                spreadRadius:
                                    3, // Increase spread for wider shadow
                                offset: const Offset(
                                    0, 8), // Position shadow slightly below
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: screenHeight * 0.13,
                                    width: screenWidth * 0.25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Hero(
                                      tag:
                                          "loc-doctor-${drSpecialisation[widget.selectedIndex]['image']}",
                                      child: Image.network(
                                        doctor.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.04),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Dr. ${doctor.name}",
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                size: screenWidth * 0.05,
                                                color: Colors.black54,
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.02),
                                              Text(
                                                //textAlign: TextAlign.center,
                                                doctor.clinicName,
                                                style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.045,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(Icons.local_hospital_rounded,
                                                  size: screenWidth * 0.05,
                                                  color: Colors.grey),
                                              SizedBox(
                                                  width: screenWidth * 0.02),
                                              Text(
                                                doctor.specialization,
                                                style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.042,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Center(
                                child: SizedBox(
                                  width: screenWidth * 0.6,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BookAppointment(
                                            doctorId: doctor.doctorId,
                                            doctorName: doctor.name,
                                            clinicName: doctor.clinicName,
                                            specialty: doctor.specialization,
                                            doctorImage: doctor.imageUrl,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 8,
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.018),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      shadowColor:
                                          Colors.greenAccent.withOpacity(0.3),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF12C2E9), // Light Blue
                                            Color(0xFF3CBA92), // Teal
                                            Color(0xFF0F9B0F), // Green
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenHeight * 0.018),
                                        child: Text(
                                          'Book Appointment',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: const [
                                              Shadow(
                                                blurRadius: 4,
                                                color: Colors.black26,
                                                offset: Offset(1, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
}

// import 'package:caresync/features/appointments/presentation/pages/book_appointment_page.dart';
// import 'package:caresync/Tejas/PatientSide.dart/PatientHomeScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SelectTime extends StatefulWidget {
//   final String doctorName;
//   final String clinicName;
//   final String specialty;
//   final String doctorImage;
//   final String doctorId;
//   final String patientName;
//   final String number;
//   final String selectedDate;

//   // Constructor to accept doctor data
//   const SelectTime({
//     super.key,
//     required this.doctorName,
//     required this.clinicName,
//     required this.specialty,
//     required this.doctorImage,
//     required this.doctorId,
//     required this.patientName,
//     required this.number,
//     required this.selectedDate,
//   });
//   @override
//   State<SelectTime> createState() => _SelectTimeState();
// }

// class _SelectTimeState extends State<SelectTime> {
//   // Variable to store the selected time slot
//   String? selectedTime;

//   // Function to handle the selection of a time slot
//   void _selectTime(String time) {
//     setState(() {
//       selectedTime = time;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Retrieve screen width and height
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       ///BOOK APPOINTMENT UI
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: [0.0, 0.3, 0.7, 1.0],
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
//             bottom: screenHeight * 0.00,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
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
//                   SizedBox(width: screenWidth * 0.18),

//                   ///TEXT
//                   Text(
//                     "Select Time",
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.065,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),

//               ///CARD
//               Container(
//                 margin: EdgeInsets.only(top: screenHeight * 0.02),
//                 padding: EdgeInsets.all(screenWidth * 0.03),
//                 height: screenHeight * 0.15,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(screenWidth * 0.05),
//                   color: Colors.white,
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color.fromRGBO(0, 0, 0, 0.2),
//                       blurRadius: 18,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ///IMAGE
//                     Container(
//                       height: screenHeight * 0.12,
//                       width: screenHeight * 0.12,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.05),
//                       ),
//                       clipBehavior: Clip.antiAlias,
//                       child: Image.asset(
//                         widget.doctorImage,
//                       ),
//                     ),

//                     ///COLUMN - TEXT
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.only(left: screenWidth * 0.03),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.doctorName,
//                               style: GoogleFonts.poppins(
//                                 fontSize: screenWidth * 0.05,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 widget.clinicName,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: screenWidth * 0.045,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 widget.specialty,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: screenWidth * 0.045,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     ///LIKE ICON
//                     // const Icon(
//                     //   Icons.favorite,
//                     //   color: Colors.red,
//                     // ),
//                   ],
//                 ),
//               ),

//               ///TEXT
//               Padding(
//                 padding: EdgeInsets.only(top: screenHeight * 0.03),
//                 child: Center(
//                   child: Text(
//                     widget.selectedDate,
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.06,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),

//               SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Static content for "Afternoon 7 slots"
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                       child: Text(
//                         "Afternoon 7 slots",
//                         style: GoogleFonts.poppins(
//                           fontSize: screenWidth * 0.06,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),

//                     // Scrollable GridView for Afternoon slots
//                     GridView.builder(
//                       padding: const EdgeInsets.symmetric(vertical: 1),
//                       shrinkWrap: true,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: screenWidth * 0.03,
//                         mainAxisSpacing: screenHeight * 0.015,
//                       ),
//                       itemCount: 7,
//                       itemBuilder: (context, index) {
//                         String time = [
//                           "1:00 PM",
//                           "1:30 PM",
//                           "2:00 PM",
//                           "2:30 PM",
//                           "3:00 PM",
//                           "3:30 PM",
//                           "4:00 PM"
//                         ][index];
//                         bool isSelected = time == selectedTime;
//                         return GestureDetector(
//                           onTap: () => _selectTime(time),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               vertical: screenHeight * 0.015,
//                               horizontal: screenWidth * 0.04,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: isSelected
//                                   ? const Color.fromRGBO(14, 190, 127, 1)
//                                   : const Color.fromRGBO(231, 246, 255, 1),
//                             ),
//                             child: AspectRatio(
//                               aspectRatio: 4 / 3, // Aspect ratio of 4:3
//                               child: Container(
//                                 alignment: Alignment
//                                     .center, // Ensure content is centered
//                                 color: isSelected
//                                     ? const Color.fromRGBO(14, 190, 127, 1)
//                                     : const Color.fromRGBO(231, 246, 255, 1),
//                                 child: Text(
//                                   time,
//                                   style: GoogleFonts.poppins(
//                                     fontSize: screenWidth * 0.045,
//                                     fontWeight: FontWeight.w500,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),

//                     // Static content for "Evening 5 slots"
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(vertical: screenHeight * 0.03),
//                       child: Text(
//                         "Evening 5 slots",
//                         style: GoogleFonts.poppins(
//                           fontSize: screenWidth * 0.06,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),

//                     // Scrollable GridView for Evening slots
//                     GridView.builder(
//                       shrinkWrap: true,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: screenWidth * 0.03,
//                         mainAxisSpacing: screenHeight * 0.015,
//                       ),
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         String time = [
//                           "5:00 PM",
//                           "5:30 PM",
//                           "6:00 PM",
//                           "6:30 PM",
//                           "7:00 PM"
//                         ][index];
//                         bool isSelected = time == selectedTime;
//                         return GestureDetector(
//                           onTap: () => _selectTime(time),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               vertical: screenHeight * 0.015,
//                               horizontal: screenWidth * 0.04,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: isSelected
//                                   ? const Color.fromRGBO(14, 190, 127, 1)
//                                   : const Color.fromRGBO(231, 246, 255, 1),
//                             ),
//                             child: AspectRatio(
//                               aspectRatio: 4 / 3,
//                               child: Center(
//                                 child: Text(
//                                   time,
//                                   style: GoogleFonts.poppins(
//                                     fontSize: screenWidth * 0.045,
//                                     fontWeight: FontWeight.w500,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               ///BUTTON NEXT
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     dialogBuilder(context);
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(top: screenHeight * 0.02),
//                     padding: EdgeInsets.all(screenHeight * 0.015),
//                     alignment: Alignment.center,
//                     width: screenWidth * 0.8,
//                     decoration: BoxDecoration(
//                       color: const Color.fromRGBO(14, 190, 127, 1),
//                       borderRadius: BorderRadius.circular(screenWidth * 0.02),
//                     ),
//                     child: Text(
//                       "Confirm",
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.05,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Time Slot Builder Method
//   Widget _buildTimeSlot(BuildContext context, String time,
//       {bool selected = false}) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: MediaQuery.of(context).size.height * 0.015,
//         horizontal: MediaQuery.of(context).size.width * 0.04,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: selected
//             ? const Color.fromRGBO(14, 190, 127, 1)
//             : const Color.fromRGBO(231, 246, 255, 1),
//       ),
//       child: Text(
//         time,
//         style: GoogleFonts.poppins(
//           fontSize: MediaQuery.of(context).size.width * 0.045,
//           fontWeight: FontWeight.w500,
//           color: selected ? Colors.white : Colors.black,
//         ),
//       ),
//     );
//   }

//   Future<void> dialogBuilder(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           actions: <Widget>[
//             Center(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 15.0, horizontal: 6),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 100,
//                       width: 100,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color.fromRGBO(143, 208, 185, 0.416),
//                       ),
//                       child: const Icon(
//                         size: 60,
//                         Icons.thumb_up_alt_rounded,
//                         color: Color.fromRGBO(14, 190, 127, 1),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         "Thank You !",
//                         style: GoogleFonts.poppins(
//                             fontSize: 28,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         "Your Appointment Successful",
//                         style: GoogleFonts.poppins(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w400,
//                           color: const Color.fromRGBO(103, 114, 148, 1),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Text(
//                       "You booked an appointment with ${widget.doctorName} on February 21, at 02:00 PM",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           color: const Color.fromRGBO(103, 114, 148, 1)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     const PatientHomeScreen()),
//                           );
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(top: 20),
//                           padding: const EdgeInsets.all(10),
//                           alignment: Alignment.center,
//                           width: 300,
//                           decoration: BoxDecoration(
//                             color: const Color.fromRGBO(14, 190, 127, 1),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             "Confirm",
//                             style: GoogleFonts.poppins(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => BookAppointment(
//                                   doctorId: widget.doctorId,
//                                   doctorName: widget.doctorName,
//                                   clinicName: widget.clinicName,
//                                   specialty: widget.specialty,
//                                   doctorImage: widget.doctorImage)));
//                         },
//                         child: Text(
//                           "Edit your appointment",
//                           style: GoogleFonts.poppins(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey,
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:developer';

import 'package:caresync/features/patients/presentation/pages/patient_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SelectTime extends StatefulWidget {
  final String doctorName;
  final String clinicName;
  final String specialty;
  final String doctorImage;
  final String doctorId;
  final String patientName;
  final String number;
  final String selectedDate;

  // Constructor to accept doctor data
  const SelectTime({
    super.key,
    required this.doctorName,
    required this.clinicName,
    required this.specialty,
    required this.doctorImage,
    required this.doctorId,
    required this.patientName,
    required this.number,
    required this.selectedDate,
  });

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Variable to store the selected time slot
  String? selectedTime;

  // Function to handle the selection of a time slot
  void _selectTime(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          padding: EdgeInsets.only(
            top: screenHeight * 0.06,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.00,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
                  child: const Icon(
                    size: 30,
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),),
                  ),
                  SizedBox(width: screenWidth * 0.18),
                  Text(
                    "Select Time",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.02),
                padding: EdgeInsets.all(screenWidth * 0.03),
                height: screenHeight * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      blurRadius: 18,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: screenHeight * 0.12,
                      width: screenHeight * 0.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        widget.doctorImage,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. ${widget.doctorName}",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    size: screenWidth * 0.05,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text(
                                    widget.clinicName,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.local_hospital_rounded,
                                      size: screenWidth * 0.05,
                                      color: Colors.grey),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text(
                                    widget.specialty,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.03),
                child: Center(
                  child: Text(
                    widget.selectedDate,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        child: Text(
                          "Afternoon 7 slots",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: screenWidth * 0.03,
                          mainAxisSpacing: screenHeight * 0.015,
                        ),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          String time = [
                            "1:00 PM",
                            "1:30 PM",
                            "2:00 PM",
                            "2:30 PM",
                            "3:00 PM",
                            "3:30 PM",
                            "4:00 PM"
                          ][index];
                          bool isSelected = time == selectedTime;
                          return GestureDetector(
                            onTap: () => _selectTime(time),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015,
                                horizontal: screenWidth * 0.04,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: isSelected
                                    ? const Color.fromRGBO(14, 190, 127, 1)
                                    : const Color.fromRGBO(231, 246, 255, 1),
                              ),
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Center(
                                  child: Text(
                                    time,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.008),
                        child: Text(
                          "Evening 5 slots",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: screenWidth * 0.03,
                          mainAxisSpacing: screenHeight * 0.015,
                        ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          String time = [
                            "5:00 PM",
                            "5:30 PM",
                            "6:00 PM",
                            "6:30 PM",
                            "7:00 PM"
                          ][index];
                          bool isSelected = time == selectedTime;
                          return GestureDetector(
                            onTap: () => _selectTime(time),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015,
                                horizontal: screenWidth * 0.04,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: isSelected
                                    ? const Color.fromRGBO(14, 190, 127, 1)
                                    : const Color.fromRGBO(231, 246, 255, 1),
                              ),
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Center(
                                  child: Text(
                                    time,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
              //   child: Center(
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         minimumSize: Size(screenWidth * 0.8, screenHeight * 0.07),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         backgroundColor: selectedTime != null
              //             ? const Color.fromRGBO(14, 190, 127, 1)
              //             : Colors.grey,
              //       ),
              //       onPressed: selectedTime != null
              //           ? () {
              //               print("----------------$selectedTime");
              //               dialogBuilder(context);
              //             }
              //           : null,
              //       child: Text(
              //         'Confirm Appointment',
              //         style: GoogleFonts.poppins(
              //           fontSize: screenWidth * 0.05,
              //           fontWeight: FontWeight.w600,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                child: Center(
                  child: GestureDetector(
                    onTap: selectedTime != null
                        ? () {
                            print("----------------$selectedTime");
                            dialogBuilder(context);
                          }
                        : null,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        gradient: selectedTime != null
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF12C2E9), // Light Blue
                                  Color(0xFF3CBA92), // Teal
                                  Color(0xFF0F9B0F), // Green
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: selectedTime == null ? Colors.grey : null,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Confirm Appointment',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(143, 208, 185, 0.416),
                      ),
                      child: Lottie.asset("assets/json/bookAppointment.json")
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Thank You !",
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Your Appointment Successful",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(103, 114, 148, 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "You booked an appointment with Dr. ${widget.doctorName} on ${widget.selectedDate}, at $selectedTime",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(103, 114, 148, 1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          await addAppointment();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PatientHomeScreen()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          width: 300,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(14, 190, 127, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Confirm",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // TextButton(
                    //     onPressed: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => BookAppointment(
                    //               doctorId: widget.doctorId,
                    //               doctorName: widget.doctorName,
                    //               clinicName: widget.clinicName,
                    //               specialty: widget.specialty,
                    //               doctorImage: widget.doctorImage)));
                    //     },
                    //     child: Text(
                    //       "Edit your appointment",
                    //       style: GoogleFonts.poppins(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600,
                    //         color: Colors.grey,
                    //       ),
                    //     )),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> addAppointment() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final patientId = currentUser?.uid ?? '';
    // Store user information in Firestore
    try {
      DocumentReference data = await _firestore
          .collection('CareSync')
          .doc('patients')
          .collection('accounts')
          .doc(patientId)
          .collection('appointments') // Add data to appointments collection
          .add({
        'name': widget.patientName,
        'patientId': patientId,
        'phone': widget.number,
        'date': widget.selectedDate,
        'time': selectedTime,
        'doctorName': widget.doctorName,
        'doctorId': widget.doctorId, // Time selected by the user
        'status': "pending",
      });

      log("Expected patientid  ${data.id}");

      await _firestore
          .collection('CareSync')
          .doc('doctors')
          .collection('accounts')
          .doc(widget.doctorId)
          .collection('appointments')
          .add({
        'appointmentId': data.id,
        'name': widget.patientName,
        'phone': widget.number,
        'date': widget.selectedDate,
        'time': selectedTime,
        'doctorName': widget.doctorName,
        'doctorId': widget.doctorId, // Time selected by the user
        'status': "pending",
        'patientId': patientId,
      });

      // Show a success message and navigate to the Sign In page
      _showSnackbar("Appointment Booked successfully!");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PatientHomeScreen(),
        ),
      );
    } catch (e) {
      _showSnackbar("Failed to book appointment: $e");
    }
  }
}

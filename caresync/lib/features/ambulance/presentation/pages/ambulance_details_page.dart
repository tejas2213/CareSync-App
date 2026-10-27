import 'dart:developer';

import 'package:caresync/features/patients/presentation/pages/patient_home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class AmbulanceDetailsScreen extends StatefulWidget {
  final String ambulanceId;

  const AmbulanceDetailsScreen({
    super.key,
    required this.ambulanceId,
    required String ambulanceType,
  });

  @override
  _AmbulanceDetailsScreenState createState() => _AmbulanceDetailsScreenState();
}

class _AmbulanceDetailsScreenState extends State<AmbulanceDetailsScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TwilioFlutter twilio = TwilioFlutter(
    accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
    authToken: 'YOUR_TWILIO_AUTH_TOKEN',
    twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
  );

  String? ambulanceName;
  String? ambulancePhone;
  String? ambulanceLocation;
  String? ambulanceCharges;

  @override
  void initState() {
    super.initState();
    _fetchAmbulanceDetails();
  }

  Future<void> _fetchAmbulanceDetails() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Ambulances')
          .doc(widget.ambulanceId)
          .get();

      if (document.exists) {
        var data = document.data() as Map<String, dynamic>;
        setState(() {
          ambulanceName = data['name'] ?? 'N/A';
          ambulancePhone = data['phone'] ?? 'N/A';
          ambulanceLocation = data['location'] ?? 'N/A';
          ambulanceCharges = data['charges'] ?? 'N/A';
        });
      } else {
        setState(() {
          ambulanceName = 'No data available';
        });
      }
    } catch (e) {
      setState(() {
        ambulanceName = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.07,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
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
                        SizedBox(width: screenWidth * 0.08),
                        Text(
                          'Ambulance Details',
                          style: TextStyle(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Center(child: Lottie.asset("assets/json/ambulance.json")),
                    ambulanceName == null
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.04),
                            Container(
                              width: screenWidth * 0.9,
                              padding: EdgeInsets.all(screenWidth * 0.05),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(
                                    screenWidth * 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: $ambulanceName',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'Phone: $ambulancePhone',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.045),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'Location: $ambulanceLocation',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.045),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'Charges: $ambulanceCharges',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.045),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _pickupController,
                                    decoration: InputDecoration(
                                      labelText: 'Pickup Location',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                screenWidth * 0.03),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        return 'Please enter pickup location';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  TextFormField(
                                    controller: _dropoffController,
                                    decoration: InputDecoration(
                                      labelText: 'Dropoff Location',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                screenWidth * 0.03),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        return 'Please enter dropoff location';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  
                                const Row(
                                  children: [
                                    Icon(Icons.payment,
                                        color: Color.fromRGBO(14, 190, 127, 1)),
                                    SizedBox(width: 8),
                                    Text(
                                      "Payment Method: Only Cash on Delivery",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _showConfirmationDialog(
                                                  context);
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(
                                              14, 190, 127, 1),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.2,
                                        vertical: screenHeight * 0.02,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                screenWidth * 0.03),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child:
                                                CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                          Color>(
                                                      Colors.white),
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : const Text(
                                            'Book Ambulance',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: const Text('Are you sure you want to book this ambulance?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _bookAmbulance();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  
  Future<void> _bookAmbulance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? patientId = FirebaseAuth.instance.currentUser?.uid;
      DocumentSnapshot patientDoc = await FirebaseFirestore.instance
          .collection('CareSync')
          .doc('patients')
          .collection('accounts')
          .doc(patientId)
          .get();

      String pickupLocation = _pickupController.text;
      String dropoffLocation = _dropoffController.text;

      String patientName = patientDoc['name'] ?? 'N/A';
      String patientPhone = patientDoc['phone'] ?? 'N/A';

      await twilio.sendSMS(
        toNumber: ambulancePhone!,
        messageBody:
            'Ambulance request from $patientName, Phone: $patientPhone, Pickup: $pickupLocation, Dropoff: $dropoffLocation',
      );

      await FirebaseFirestore.instance
          .collection('CareSync')
          .doc('patients')
          .collection('accounts')
          .doc(patientId)
          .collection('ambulanceBookings')
          .add({
        'ambulanceId': widget.ambulanceId,
        'ambulanceName': ambulanceName,
        'pickupLocation': pickupLocation,
        'dropoffLocation': dropoffLocation,
        'status': 'Pending',
        'bookingTime': FieldValue.serverTimestamp(),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ambulance booked successfully!')),
      );
       
      Navigator.pop(context);
      log("Above dialog box");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: <Widget>[
            Center(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 6),
              child: Column(
                children: [
                  Lottie.asset("assets/json/ambulanceBackground.json"),
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
                      "Ambulance booked successfully!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Pay After Service!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PatientHomeScreen()),
                      );
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            )),
          ],
        ),
      );
      log("Above dialog box");

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book ambulance.')),
      );
    }
  }

  
}







// import 'dart:developer';

// import 'package:caresync/features/patients/presentation/pages/patient_home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

// class AmbulanceDetailsScreen extends StatefulWidget {
//   final String ambulanceId;

//   const AmbulanceDetailsScreen({
//     super.key,
//     required this.ambulanceId, required ambulanceType,
//   });

//   @override
//   _AmbulanceDetailsScreenState createState() => _AmbulanceDetailsScreenState();
// }

// class _AmbulanceDetailsScreenState extends State<AmbulanceDetailsScreen> {
//   final TextEditingController _pickupController = TextEditingController();
//   final TextEditingController _dropoffController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   final TwilioFlutter twilio = TwilioFlutter(
//     accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
//     authToken: 'YOUR_TWILIO_AUTH_TOKEN',
//     twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
//   );

//   String? ambulanceName;
//   String? ambulancePhone;
//   String? ambulanceLocation;
//   String? ambulanceCharges;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: screenHeight,
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
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: screenWidth * 0.05,
//                   vertical: screenHeight * 0.07,
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: Container(
//                             height: screenWidth * 0.1,
//                             width: screenWidth * 0.1,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(17),
//                               color: Colors.transparent,
//                               border: Border.all(
//                                 color: const Color.fromRGBO(0, 0, 0, 1),
//                                 width: 1,
//                               ),
//                             ),
//                             child: const Icon(
//                               size: 30,
//                               Icons.arrow_back_ios_new_rounded,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: screenWidth * 0.08),
//                         Text(
//                           'Ambulance Details',
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.07,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: screenHeight * 0.008),
//                     Center(child: Lottie.asset("assets/json/ambulance.json")),
//                     StreamBuilder<DocumentSnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection('Ambulances')
//                           .doc(widget.ambulanceId)
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                         if (!snapshot.hasData || !snapshot.data!.exists) {
//                           return const Center(
//                             child: Text('No data available'),
//                           );
//                         }
//                         var data =
//                             snapshot.data!.data() as Map<String, dynamic>;
//                         String ambulanceName = data['name'] ?? 'N/A';
//                         String ambulancePhone = data['phone'] ?? 'N/A';
//                         String ambulanceLocation = data['location'] ?? 'N/A';
//                         String ambulanceCharges = data['charges'] ?? 'N/A';

//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: screenHeight * 0.04),
//                             Container(
//                               width: screenWidth * 0.9,
//                               padding: EdgeInsets.all(screenWidth * 0.05),
//                               decoration: BoxDecoration(
//                                 color: Colors.black12,
//                                 borderRadius: BorderRadius.circular(
//                                     screenWidth * 0.05),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.white.withOpacity(0.4),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Name: $ambulanceName',
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.05,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenHeight * 0.01),
//                                   Text(
//                                     'Phone: $ambulancePhone',
//                                     style: TextStyle(
//                                         fontSize: screenWidth * 0.045),
//                                   ),
//                                   SizedBox(height: screenHeight * 0.01),
//                                   Text(
//                                     'Location: $ambulanceLocation',
//                                     style: TextStyle(
//                                         fontSize: screenWidth * 0.045),
//                                   ),
//                                   SizedBox(height: screenHeight * 0.01),
//                                   Text(
//                                     'Charges: $ambulanceCharges',
//                                     style: TextStyle(
//                                         fontSize: screenWidth * 0.045),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: screenHeight * 0.03),
//                             Form(
//                               key: _formKey,
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     controller: _pickupController,
//                                     decoration: InputDecoration(
//                                       labelText: 'Pickup Location',
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(
//                                             screenWidth * 0.03),
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null ||
//                                           value.isEmpty) {
//                                         return 'Please enter pickup location';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: screenHeight * 0.02),
//                                   TextFormField(
//                                     controller: _dropoffController,
//                                     decoration: InputDecoration(
//                                       labelText: 'Dropoff Location',
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(
//                                             screenWidth * 0.03),
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value == null ||
//                                           value.isEmpty) {
//                                         return 'Please enter dropoff location';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   SizedBox(height: screenHeight * 0.03),
//                                   const Row(
//                                     children: [
//                                       Icon(Icons.payment,
//                                           color: Color.fromRGBO(
//                                               14, 190, 127, 1)),
//                                       SizedBox(width: 8),
//                                       Text(
//                                         "Payment Method: Only Cash on Delivery",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: screenHeight * 0.02),
//                                   ElevatedButton(
//                                     onPressed: _isLoading
//                                         ? null
//                                         : () {
//                                             if (_formKey.currentState!
//                                                 .validate()) {
//                                               _showConfirmationDialog(
//                                                   context);
//                                             }
//                                           },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           const Color.fromRGBO(
//                                               14, 190, 127, 1),
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: screenWidth * 0.2,
//                                         vertical: screenHeight * 0.02,
//                                       ),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(
//                                                 screenWidth * 0.03),
//                                       ),
//                                     ),
//                                     child: _isLoading
//                                         ? const SizedBox(
//                                             height: 20,
//                                             width: 20,
//                                             child:
//                                                 CircularProgressIndicator(
//                                               valueColor:
//                                                   AlwaysStoppedAnimation<
//                                                           Color>(
//                                                       Colors.white),
//                                               strokeWidth: 2.5,
//                                             ),
//                                           )
//                                         : const Text(
//                                             'Book Ambulance',
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 color: Colors.white),
//                                           ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//  void _showConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Confirm Booking'),
//           content: const Text('Are you sure you want to book this ambulance?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 ;
//                 Navigator.pop(context);
//                 _bookAmbulance();
//               },
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }

  
//   Future<void> _bookAmbulance() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       String? patientId = FirebaseAuth.instance.currentUser?.uid;
//       DocumentSnapshot patientDoc = await FirebaseFirestore.instance
//           .collection('CareSync')
//           .doc('patients')
//           .collection('accounts')
//           .doc(patientId)
//           .get();

//       String pickupLocation = _pickupController.text;
//       String dropoffLocation = _dropoffController.text;

//       String patientName = patientDoc['name'] ?? 'N/A';
//       String patientPhone = patientDoc['phone'] ?? 'N/A';

//       await twilio.sendSMS(
//         toNumber: ambulancePhone!,
//         messageBody:
//             'Ambulance request from $patientName, Phone: $patientPhone, Pickup: $pickupLocation, Dropoff: $dropoffLocation',
//       );

//       await FirebaseFirestore.instance
//           .collection('CareSync')
//           .doc('patients')
//           .collection('accounts')
//           .doc(patientId)
//           .collection('ambulanceBookings')
//           .add({
//         'ambulanceId': widget.ambulanceId,
//         'ambulanceName': ambulanceName,
//         'pickupLocation': pickupLocation,
//         'dropoffLocation': dropoffLocation,
//         'status': 'Pending',
//         'bookingTime': FieldValue.serverTimestamp(),
//       });
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Ambulance booked successfully!')),
//       );
       
//       Navigator.pop(context);
//       log("Above dialog box");
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           actions: <Widget>[
//             Center(
//                 child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 15.0, horizontal: 6),
//               child: Column(
//                 children: [
//                   Lottie.asset("assets/json/ambulanceBackground.json"),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       "Thank You !",
//                       style: GoogleFonts.poppins(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       "Ambulance booked successfully!",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black),
//                     ),
//                   ),
//                    Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       "Pay After Service!",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const PatientHomeScreen()),
//                       );
//                     },
//                     child: const Text("OK"),
//                   ),
//                 ],
//               ),
//             )),
//           ],
//         ),
//       );
//       log("Above dialog box");

//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to book ambulance.')),
//       );
//     }
//   }
// }

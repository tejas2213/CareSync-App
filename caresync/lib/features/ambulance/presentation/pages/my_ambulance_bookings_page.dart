import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAmbulanceBookingsScreen extends StatefulWidget {
  const MyAmbulanceBookingsScreen({super.key});

  @override
  _MyAmbulanceBookingsScreenState createState() =>
      _MyAmbulanceBookingsScreenState();
}

class _MyAmbulanceBookingsScreenState
    extends State<MyAmbulanceBookingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _patientId;

  
  Future<void> _getPatientId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _patientId = user.uid;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    final patientDoc = await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(_patientId) 
        .collection('ambulanceBookings')
        .get();

    if (patientDoc.docs.isEmpty) {
      return [];
    }

    return patientDoc.docs.map((doc) => doc.data()).toList();
  }

  @override
  void initState() {
    super.initState();
    _getPatientId(); 
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(16.0, 60, 16, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 43,
                        width: 43,
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
                    const SizedBox(width: 28),
                    Expanded(
                      child: Text(
                        'My Ambulance Bookings',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                // Bookings list
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchBookings(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(child: Text('Error fetching bookings'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No bookings found'));
                      }

                      List<Map<String, dynamic>> bookings = snapshot.data!;

                      return ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          var booking = bookings[index];

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
                                    'Ambulance: ${booking['ambulanceName']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Pickup: ${booking['pickupLocation']}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dropoff: ${booking['dropoffLocation']}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  
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
        ],
      ),
    );
  }
}

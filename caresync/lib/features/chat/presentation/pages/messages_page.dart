

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_screen_page.dart';

class DoctorListScreen extends StatefulWidget {
  final String patientId; // Pass the patient's ID
  const DoctorListScreen({super.key, required this.patientId});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchDoctors() async {
    final doctorsSnapshot = await _firestore.collection('CareSync/doctors/accounts').get();
    return doctorsSnapshot.docs
        .map((doc) => {"id": doc.id, ...doc.data()})
        .toList();
  }

  void _navigateToChat(Map<String, dynamic> doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatData: {
            "doctorId": doctor['id'],
            "name": doctor['name'],
            "patientId": widget.patientId,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Doctors', style: GoogleFonts.poppins()),
      //   backgroundColor: const Color(0xFF4A49E8),
      // ),
      body: Container(
         padding: EdgeInsets.only(
              right: screenWidth * 0.04,
              left: screenWidth * 0.04,
              top: screenHeight * 0.05,
              bottom: screenHeight * 0.01),
          width: double.infinity,
          height: double.infinity,
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
                            color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
                    child: const Icon(
                      size: 30,
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Center(
                  child: Text(
                    "Chat with doctors",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]
             ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchDoctors(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final doctors = snapshot.data!;
                if (doctors.isEmpty) {
                  return const Center(child: Text('No doctors available.'));
                }
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return Container(
                        height: screenHeight*0.07,
                        width: screenWidth*0.07,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(radius: 30,child: Icon(Icons.person,size:30),),
                          title: Text(doctor['name'], style: GoogleFonts.poppins(fontSize: screenHeight*0.019,
                              fontWeight: FontWeight.w600)),
                          // subtitle: Text(doctor['email'] ?? '', style: GoogleFonts.poppins()),
                          onTap: () => _navigateToChat(doctor),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
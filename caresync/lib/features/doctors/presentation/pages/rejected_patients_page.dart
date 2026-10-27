import 'package:caresync/features/appointments/data/models/doctor_appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RejectedPatientListScreen extends StatefulWidget {
  const RejectedPatientListScreen({super.key});

  @override
  _RejectedPatientListScreenState createState() =>
      _RejectedPatientListScreenState();
}

class _RejectedPatientListScreenState extends State<RejectedPatientListScreen> {
  late Future<List<DrAppointment>> patients;
  List<DrAppointment> upcomingPatientList = [];

  @override
  void initState() {
    super.initState();
    patients = fetchAppointments();
  }

  Future<List<DrAppointment>> fetchAppointments() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final doctorId = currentUser?.uid ?? '';

    List<DrAppointment> appointmentList = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('CareSync')
          .doc('doctors')
          .collection('accounts')
          .doc(doctorId)
          .collection('appointments')
          .get();

      for (var doc in querySnapshot.docs) {
        String doctorName = doc['doctorName'];
        String patientAppId = doc['appointmentId'];
        String name = doc['name'];
        String date = doc['date'];
        String phone = doc['phone'];
        String time = doc['time'];
        String status = doc['status'];
        String appointmentId = doc.id;
        String patientId = doc['patientId'];

        appointmentList.add(DrAppointment(
          patientAppId: patientAppId,
          appointmentId: appointmentId,
          patientId: patientId,
          name: name,
          date: date,
          phone: phone,
          time: time,
          status: status,
        ));
      }

      for (int i = 0; i < appointmentList.length; i++) {
        if (appointmentList[i].status == 'Rejected') {
          upcomingPatientList.add(appointmentList[i]);
        }
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
    return appointmentList;
  }

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
                  'Rejected Patients',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          FutureBuilder<List<DrAppointment>>(
            future: patients,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty ||
                  upcomingPatientList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No Rejected Appointments yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              List<DrAppointment> patientList = snapshot.data!;
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
                        vertical: screenHeight * 0.015,
                      ),
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
                                        screenWidth,
                                      ),
                                      _buildPatientInfo(
                                        Icons.access_time,
                                        'Time: ${patient.time}',
                                        Colors.orange,
                                        screenWidth,
                                      ),
                                      _buildPatientInfo(
                                        Icons.calendar_month,
                                        'Date: ${patient.date}',
                                        Colors.blue,
                                        screenWidth,
                                      ),
                                      SizedBox(height: screenHeight * 0.015),
                                      Text(
                                        "Status : Rejected",
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
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
    IconData icon,
    String info,
    Color color,
    double screenWidth,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: screenWidth * 0.045),
        SizedBox(width: screenWidth * 0.02),
        Text(info, style: TextStyle(fontSize: screenWidth * 0.045)),
      ],
    );
  }
}

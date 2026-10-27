// import 'package:caresync/features/chat/presentation/pages/dp_chat_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PatientListScreen extends StatefulWidget {
//   final String doctorId; // Pass the doctor ID
//   const PatientListScreen({super.key, required this.doctorId});

//   @override
//   State<PatientListScreen> createState() => _PatientListScreenState();
// }

// class _PatientListScreenState extends State<PatientListScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Map<String, dynamic>>> _fetchPatients() async {
//     final chatsSnapshot = await _firestore
//         .collection('chats')
//         .where('doctorId', isEqualTo: widget.doctorId)
//         .get();

//     List<Map<String, dynamic>> patients = [];
//     for (var chat in chatsSnapshot.docs) {
//       final patientId = chat.id.split('_')[0]; // Extract patient ID
//       final patientDoc =
//           await _firestore.doc('CareSync/patients/accounts/$patientId').get();
//       if (patientDoc.exists) {
//         patients.add(patientDoc.data() as Map<String, dynamic>);
//       }
//     }
//     return patients;
//   }

//   void _navigateToChat(Map<String, dynamic> patient) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DoctorChatScreen(
//           doctorId: widget.doctorId,
//           patientId: patient['id'],
//           patientName: patient['name'],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Patients', style: GoogleFonts.poppins()),
//         backgroundColor: const Color(0xFF4A49E8),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _fetchPatients(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final patients = snapshot.data!;
//           if (patients.isEmpty) {
//             return const Center(child: Text('No patients found.'));
//           }
//           return ListView.builder(
//             padding: const EdgeInsets.all(10.0),
//             itemCount: patients.length,
//             itemBuilder: (context, index) {
//               final patient = patients[index];
//               return ListTile(
//                 leading: const CircleAvatar(child: Icon(Icons.person)),
//                 title: Text(patient['name'], style: GoogleFonts.poppins()),
//                 subtitle: Text(patient['email'] ?? '', style: GoogleFonts.poppins()),
//                 onTap: () => _navigateToChat(patient),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:caresync/features/chat/presentation/pages/dp_chat_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PatientListScreen extends StatefulWidget {
//   final String doctorId; // Pass the doctor ID
//   const PatientListScreen({super.key, required this.doctorId});

//   @override
//   State<PatientListScreen> createState() => _PatientListScreenState();
// }

// class _PatientListScreenState extends State<PatientListScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Map<String, dynamic>>> _fetchPatients() async {
//     List<Map<String, dynamic>> patients = [];

//     // Fetching all chats under a specific doctorId
//     final chatsSnapshot = await _firestore
//         .collection('chats')
//         .doc(widget.doctorId)  // Doctor-specific chat collection
//         .collection('messages')
//         .get();

//     // Iterate through each chat document and fetch patient details
//     for (var chat in chatsSnapshot.docs) {
//       final patientId = chat.id.split('_')[0]; // Extract patientId from the chat document ID

//       final patientDoc = await _firestore
//           .doc('CareSync/patients/accounts/$patientId') // Patient's document
//           .get();

//       if (patientDoc.exists) {
//         // Add the patient data to the list
//         patients.add(patientDoc.data() as Map<String, dynamic>);
//       }
//     }

//     return patients;
//   }

//   void _navigateToChat(Map<String, dynamic> patient) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DoctorChatScreen(
//           doctorId: widget.doctorId,
//           patientId: patient['id'],
//           patientName: patient['name'],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Patients', style: GoogleFonts.poppins()),
//         backgroundColor: const Color(0xFF4A49E8),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _fetchPatients(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final patients = snapshot.data!;
//           if (patients.isEmpty) {
//             return const Center(child: Text('No patients found.'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(10.0),
//             itemCount: patients.length,
//             itemBuilder: (context, index) {
//               final patient = patients[index];
//               return ListTile(
//                 leading: const CircleAvatar(child: Icon(Icons.person)),
//                 title: Text(patient['name'], style: GoogleFonts.poppins()),
//                 subtitle: Text(patient['email'] ?? '', style: GoogleFonts.poppins()),
//                 onTap: () => _navigateToChat(patient),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:developer';

// import 'package:caresync/features/chat/presentation/pages/dp_chat_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PatientListScreen extends StatefulWidget {
//   final String doctorId;
//   const PatientListScreen({super.key, required this.doctorId});

//   @override
//   State<PatientListScreen> createState() => _PatientListScreenState();
// }

// class _PatientListScreenState extends State<PatientListScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//    late Future<List<Map<String, dynamic>>> _patientsFuture;

// Stream<List<Map<String, dynamic>>> _streamPatients() async* {
//   try {
//     // Fetching chats from Firestore
//     QuerySnapshot<Map<String, dynamic>> chatsSnapshot = await _firestore
//         .collection('chats')
//         .get();

//     // Loop through chats and log info (if needed)
//     for (var chats in chatsSnapshot.docs) {
//       log("---${chats.id}");
//       List ids = chats.id.split("_");
//       log("-----compare-----${ids.contains(widget.doctorId)}");
//     }

//     List<Map<String, dynamic>> patients = [];

//     // Fetch patient data for each chat
//     for (var chat in chatsSnapshot.docs) {
//       final patientId = chat['patientId'];

//       // Fetching the patient document
//       final patientDoc = await _firestore.doc('CareSync/patients/$patientId').get();
//       if (patientDoc.exists) {
//         // Adding patient data to the list
//         patients.add(patientDoc.data() as Map<String, dynamic>);
//       }
//     }

//     // Yield the patients list as a stream
//     yield patients;

//   } catch (e) {
//     debugPrint("Error fetching patients: $e");
//     yield []; // In case of an error, return an empty list
//   }
// }

//   void _navigateToChat(Map<String, dynamic> patient) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DoctorChatScreen(
//           doctorId: widget.doctorId,
//           patientId: patient['id'] ?? '',
//           patientName: patient['name'] ?? 'Unknown',
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Patients', style: GoogleFonts.poppins()),
//         backgroundColor: const Color(0xFF4A49E8),
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _streamPatients(),
//         builder: (context, snapshot) {

//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final patients = snapshot.data!;
//           if (patients.isEmpty) {
//             return const Center(child: Text('No patients found.'));
//           }
//           return ListView.builder(
//             padding: const EdgeInsets.all(10.0),
//             itemCount: patients.length,
//             itemBuilder: (context, index) {
//               final patient = patients[index];
//               return ListTile(
//                 leading: const CircleAvatar(child: Icon(Icons.person)),
//                 title: Text(
//                   patient['name'] ?? 'Unknown',
//                   style: GoogleFonts.poppins(),
//                 ),
//                 subtitle: Text(
//                   patient['email'] ?? 'No email available',
//                   style: GoogleFonts.poppins(),
//                 ),
//                 onTap: () => _navigateToChat(patient),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:developer';

// import 'package:caresync/features/chat/presentation/pages/dp_chat_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PatientListScreen extends StatefulWidget {
//   final String doctorId;
//   const PatientListScreen({super.key, required this.doctorId});

//   @override
//   State<PatientListScreen> createState() => _PatientListScreenState();
// }

// class _PatientListScreenState extends State<PatientListScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Stream to fetch patients based on the doctorId
//   Stream<List<Map<String, dynamic>>> _streamPatients() async* {
//     try {
//       log("Querying chats collection for doctorId: ${widget.doctorId}");

//       // Fetch all chat documents
//       QuerySnapshot<Map<String, dynamic>> chatsSnapshot = await _firestore.collection('chats').get();

//       log("Fetched ${chatsSnapshot.docs.length} chat(s).");

//       if (chatsSnapshot.docs.isEmpty) {
//         log("No chats found in the collection.");
//         yield [];
//         return;
//       }

//       List<Map<String, dynamic>> patients = [];

//       for (var chat in chatsSnapshot.docs) {
//         final chatData = chat.data();
//         final chatId = chatData['chatId'] ?? '';

//         // Log the chatId for debugging
//         log("Processing chatId: $chatId");

//         if (chatId.contains('_')) {
//           final parts = chatId.split('_');
//           if (parts.length == 2) {
//             final patientId = parts[0]; // Extract `patientId`
//             final doctorId = parts[1]; // Extract `doctorId`

//             log("Extracted patientId: $patientId, doctorId: $doctorId");

//             // Match doctorId with the logged-in doctor's ID
//             if (doctorId == widget.doctorId) {
//               log("Match found for doctorId: $doctorId");

//               // Fetch the patient document
//               final patientDoc =
//                   await _firestore.doc('CareSync/patients/accounts/$patientId').get();
//               if (patientDoc.exists) {
//                 final patientData = patientDoc.data() as Map<String, dynamic>;
//                 patients.add(patientData);
//               } else {
//                 log("No patient document found for patientId: $patientId");
//               }
//             } else {
//               log("Doctor ID mismatch. Skipping chatId: $chatId");
//             }
//           } else {
//             log("Invalid chatId format (expected patientId_doctorId): $chatId");
//           }
//         } else {
//           log("Invalid chatId format (expected patientId_doctorId): $chatId");
//         }
//       }

//       yield patients; // Return the list of patients

//     } catch (e) {
//       log("Error fetching patients: $e");
//       yield []; // Return an empty list on error
//     }
//   }

//   // Navigate to the chat screen with the selected patient
//   void _navigateToChat(Map<String, dynamic> patient) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DoctorChatScreen(
//           doctorId: widget.doctorId,
//           patientId: patient['id'] ?? '',
//           patientName: patient['name'] ?? 'Unknown',
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Patients', style: GoogleFonts.poppins()),
//         backgroundColor: const Color(0xFF4A49E8),
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _streamPatients(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final patients = snapshot.data!;

//           if (patients.isEmpty) {
//             return const Center(child: Text('No patients found.'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(10.0),
//             itemCount: patients.length,
//             itemBuilder: (context, index) {
//               final patient = patients[index];
//               return ListTile(
//                 leading: const CircleAvatar(child: Icon(Icons.person)),
//                 title: Text(
//                   patient['name'] ?? 'Unknown',
//                   style: GoogleFonts.poppins(),
//                 ),
//                 subtitle: Text(
//                   patient['email'] ?? 'No email available',
//                   style: GoogleFonts.poppins(),
//                 ),
//                 onTap: () => _navigateToChat(patient),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:developer';

// import 'package:caresync/features/chat/presentation/pages/dp_chat_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PatientListScreen extends StatefulWidget {
//   final String doctorId;
//   const PatientListScreen({super.key, required this.doctorId});

//   @override
//   State<PatientListScreen> createState() => _PatientListScreenState();
// }

// class _PatientListScreenState extends State<PatientListScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Stream to fetch patients based on the doctorId
//   Stream<List<Map<String, dynamic>>> _streamPatients() async* {
//     try {
//       log("Querying chats collection for doctorId: ${widget.doctorId}");

//       // Fetch all chat documents
//       final chatsSnapshot = await _firestore.collection('chats').get();
//       final List<Map<String, dynamic>> patients = [];

//       if (chatsSnapshot.docs.isEmpty) {
//         log("No chats found in the collection.");
//         yield patients;
//         return;
//       }

//       // Process each chat document
//       final patientFetchTasks = chatsSnapshot.docs.map((chatDoc) async {
//         final chatId = chatDoc.id; // Use the document ID as chatId

//         if (chatId.contains('_')) {
//           final parts = chatId.split('_');
//           if (parts.length == 2) {
//             final patientId = parts[0]; // Extract `patientId`
//             final doctorId = parts[1]; // Extract `doctorId`

//             if (doctorId == widget.doctorId) {
//               log("Match found for doctorId: $doctorId, fetching patientId: $patientId");
//               final patientDoc = await _firestore
//                   .doc('CareSync/patients/accounts/$patientId')
//                   .get();

//               if (patientDoc.exists) {
//                 final patientData = patientDoc.data() as Map<String, dynamic>;
//                 return patientData;
//               } else {
//                 log("No patient document found for patientId: $patientId");
//               }
//             }
//           } else {
//             log("Invalid chatId format (expected patientId_doctorId): $chatId");
//           }
//         } else {
//           log("Invalid chatId format (expected patientId_doctorId): $chatId");
//         }
//         return null;
//       });

//       final fetchedPatients = await Future.wait(patientFetchTasks);
//       patients.addAll(fetchedPatients.whereType<Map<String, dynamic>>());

//       yield patients;
//     } catch (e) {
//       log("Error fetching patients: $e");
//       yield []; // Return an empty list on error
//     }
//   }

//   // Navigate to the chat screen with the selected patient
//   void _navigateToChat(Map<String, dynamic> patient) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DoctorChatScreen(
//           doctorId: widget.doctorId,
//           patientId: patient['id'] ?? '',
//           patientName: patient['name'] ?? 'Unknown',
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Patients', style: GoogleFonts.poppins()),
//         backgroundColor: const Color(0xFF4A49E8),
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _streamPatients(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text('Error loading patients.'));
//           }

//           final patients = snapshot.data ?? [];

//           if (patients.isEmpty) {
//             return const Center(child: Text('No patients found.'));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(10.0),
//             itemCount: patients.length,
//             itemBuilder: (context, index) {
//               final patient = patients[index];
//               return ListTile(
//                 leading: const CircleAvatar(child: Icon(Icons.person)),
//                 title: Text(
//                   patient['name'] ?? 'Unknown',
//                   style: GoogleFonts.poppins(),
//                 ),
//                 subtitle: Text(
//                   patient['email'] ?? 'No email available',
//                   style: GoogleFonts.poppins(),
//                 ),
//                 onTap: () => _navigateToChat(patient),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:caresync/features/chat/presentation/pages/dp_chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientListScreen extends StatefulWidget {
  final String doctorId;
  const PatientListScreen({super.key, required this.doctorId});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  // Stream to fetch patients based on the doctorId
  Stream<List<Map<String, dynamic>>> _streamPatients() async* {
    try {
      log("Querying chats collection for doctorId: ${widget.doctorId}");

      // Fetch all chat documents
      CollectionReference<
          Map<String,
              dynamic>> ref = FirebaseFirestore.instance.collection(
          '/CareSync/doctors/accounts/${widget.doctorId}/appointments/');

      QuerySnapshot<Map<String, dynamic>> chatsSnapshot = await ref.get();

      QuerySnapshot<Map<String, dynamic>> temp = await ref.get();

      log("${temp.docs[0].data()['patientId']}");

      final Set<Map<String, dynamic>> patients = {};

      for (int i = 0; i < temp.docs.length; i++) {
        patients.add({
          'patientId': temp.docs[i].data()['patientId'],
          'name': temp.docs[i].data()['name']
        });
      }

      if (chatsSnapshot.docs.isEmpty) {
        log("No chats found in the collection.");
        yield patients.toList();
        return;
      }

      // Process each chat document
      final patientFetchTasks = chatsSnapshot.docs.map((chatDoc) async {
        final chatId = chatDoc.id; // Use the document ID as chatId

        if (chatId.contains('_')) {
          final parts = chatId.split('_');
          if (parts.length == 2) {
            final patientId = parts[0]; // Extract `patientId`
            final doctorId = parts[1]; // Extract `doctorId`

            if (doctorId == widget.doctorId) {
              log("Match found for doctorId: $doctorId, fetching patientId: $patientId");
              final patientDoc = await FirebaseFirestore.instance
                  .doc('CareSync/patients/accounts/$patientId')
                  .get();

              if (patientDoc.exists) {
                final patientData = patientDoc.data() as Map<String, dynamic>;
                return patientData;
              } else {
                log("No patient document found for patientId: $patientId");
              }
            }
          } else {
            log("Invalid chatId format (expected patientId_doctorId): $chatId");
          }
        } else {
          log("Invalid chatId format (expected patientId_doctorId): $chatId");
        }
        return null;
      });

      final fetchedPatients = await Future.wait(patientFetchTasks);
      patients.addAll(fetchedPatients.whereType<Map<String, dynamic>>());

      yield patients.toList();
    } catch (e) {
      log("Error fetching patients: $e");
      yield []; // Return an empty list on error
    }
  }

  // Navigate to the chat screen with the selected patient
  void _navigateToChat(Map<String, dynamic> patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorChatScreen(
          doctorId: widget.doctorId,
          patientId: patient['patientId'], // Ensure 'id' exists
          patientName: patient['name'] ?? 'Unknown', // Ensure 'name' exists
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
          child: Column(children: [
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
                    "Chat with patients",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              // Watch stream of patients
              stream: _streamPatients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading patients.'));
                }

                final patients = snapshot.data ?? [];

                if (patients.isEmpty) {
                  return const Center(child: Text('No patients found.'));
                }

                return Expanded(
                  child: ListView.builder(
                    // padding: const EdgeInsets.all(10.0),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];
                      // log("${patient['name']}");
                      return Container(
                        height: screenHeight*0.07,
                        width: screenWidth*0.07,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading:
                              const CircleAvatar(radius: 30,child: Icon(Icons.person,size:30),),
                          title: Text(
                            patient['name'] ?? 'Unknown',
                            style: GoogleFonts.poppins(
                              fontSize: screenHeight*0.019,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          // subtitle: Text(
                          //   patient['patientId'] ?? 'No email available',
                          //   style: GoogleFonts.poppins(),
                          // ),
                          onTap: () =>
                              _navigateToChat(patient), // Trigger navigation
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ])),
    );
  }
}

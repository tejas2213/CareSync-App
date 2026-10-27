// import 'package:caresync/features/ambulance/presentation/pages/ambulance_details_page.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; 
// import 'package:google_fonts/google_fonts.dart';

// class AmbulanceListScreen extends StatefulWidget {
//   final String type;

//   const AmbulanceListScreen({super.key, required this.type});

//   @override
//   _AmbulanceListScreenState createState() => _AmbulanceListScreenState();
// }

// class _AmbulanceListScreenState extends State<AmbulanceListScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final List<Map<String, String>> _ambulances = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchAmbulanceData();
//   }

//   Future<void> _fetchAmbulanceData() async {
//     try {
//       QuerySnapshot snapshot = await _firestore
//           .collection('Ambulances')
//           .where('ambulanceType', isEqualTo: widget.type)  
//           .get();

//       setState(() {
//         _ambulances.clear(); 
        
//         for (var doc in snapshot.docs) {
//           Map<String, dynamic> ambulanceData = doc.data() as Map<String, dynamic>;
//           _ambulances.add({
//             'id': doc.id,  
//             'name': ambulanceData['name'] ?? 'N/A',
//             'phone': ambulanceData['phone'] ?? 'N/A',
//             'location': ambulanceData['location'] ?? 'Unknown',
//             'charges': ambulanceData['charges']?.toString() ?? 'N/A',
//             'ambulanceType': widget.type,  
//           });
//         }
//       });
//     } catch (e) {
//       print("Error fetching ambulance data from Firestore: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
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
//           padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.06, screenWidth * 0.04, 0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
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
//                   Text(
//                     'Ambulance List',
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.07,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.1),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.02),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _ambulances.length,
//                   itemBuilder: (context, index) {
//                     Map<String, String> ambulance = _ambulances[index];

//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AmbulanceDetailsScreen(
//                               ambulanceId: ambulance['id']!,
//                               ambulanceType: ambulance['ambulanceType']!,
//                             ),
//                           ),
//                         );
//                       },
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: EdgeInsets.symmetric(
//                           vertical: screenWidth * 0.02,
//                           horizontal: screenWidth * 0.04,
//                         ),
//                         padding: EdgeInsets.all(screenWidth * 0.04),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(screenWidth * 0.03),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               blurRadius: screenWidth * 0.015,
//                               offset: Offset(0, screenWidth * 0.01),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.local_hospital, size: screenWidth * 0.1, color: Colors.redAccent),
//                             SizedBox(width: screenWidth * 0.04),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     ambulance['name']!,
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.045,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenWidth * 0.02),
//                                   Text(
//                                     "Phone No: ${ambulance['phone']}",
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.035,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenWidth * 0.02),
//                                   Text(
//                                     "Location: ${ambulance['location']}",
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.035,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   SizedBox(height: screenWidth * 0.02),
//                                   Text(
//                                     "Charges: \$${ambulance['charges']}",
//                                     style: TextStyle(
//                                       fontSize: screenWidth * 0.035,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:caresync/features/ambulance/presentation/pages/ambulance_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AmbulanceListScreen extends StatelessWidget {
  final String type;

  const AmbulanceListScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
          padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.06, screenWidth * 0.04, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'Ambulance List',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.1),
                ],
              ),
             // SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Ambulances')
                      .where('ambulanceType', isEqualTo: type)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error fetching data"),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No ambulances found"),
                      );
                    }

                    final ambulances = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return {
                        'id': doc.id,
                        'name': data['name'] ?? 'N/A',
                        'phone': data['phone'] ?? 'N/A',
                        'location': data['location'] ?? 'Unknown',
                        'charges': data['charges']?.toString() ?? 'N/A',
                        'ambulanceType': type,
                      };
                    }).toList();

                    return ListView.builder(
                      itemCount: ambulances.length,
                      itemBuilder: (context, index) {
                        final ambulance = ambulances[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AmbulanceDetailsScreen(
                                  ambulanceId: ambulance['id']!,
                                  ambulanceType: ambulance['ambulanceType']!,
                                ),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.03,
                              horizontal: screenWidth * 0.04,
                            ),
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(screenWidth * 0.03),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87.withOpacity(0.4),
                                  blurRadius: screenWidth * 0.015,
                                  offset: Offset(0, screenWidth * 0.01),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.local_hospital, size: screenWidth * 0.1, color: Colors.redAccent),
                                SizedBox(width: screenWidth * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ambulance['name']!,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: screenWidth * 0.02),
                                      Text(
                                        "Phone No: ${ambulance['phone']}",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: screenWidth * 0.02),
                                      Text(
                                        "Location: ${ambulance['location']}",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: screenWidth * 0.02),
                                      Text(
                                        "Charges: \$${ambulance['charges']}",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
    );
  }
}

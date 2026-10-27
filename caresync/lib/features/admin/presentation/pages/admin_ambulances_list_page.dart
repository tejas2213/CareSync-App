// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AmbulancesList extends StatefulWidget {
//   const AmbulancesList({super.key});

//   @override
//   _AmbulancesListState createState() => _AmbulancesListState();
// }

// class _AmbulancesListState extends State<AmbulancesList> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> _ambulancesList = [];
//   bool _isLoading = true; // Loading indicator state

//   @override
//   void initState() {
//     super.initState();
//     _fetchAmbulances();
//   }

//   void _fetchAmbulances() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('Ambulances').get();

//       if (snapshot.docs.isNotEmpty) {
//         List<Map<String, dynamic>> loadedAmbulances = [];
//         for (var doc in snapshot.docs) {
//           loadedAmbulances.add({
//             'id': doc.id,
//             'name': doc['name'],
//             'phone': doc['phone'],
//             'location': doc['location'],
//             'charges': doc['charges'],
//             'ambulanceType': doc['ambulanceType'],
//           });
//         }

//         setState(() {
//           _ambulancesList = loadedAmbulances;
//         });
//       } else {
//         setState(() {
//           _ambulancesList = [];
//         });
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to load ambulances: $error")),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false; // Data loading complete
//       });
//     }
//   }

//   void _deleteAmbulance(String id) async {
//     try {
//       await _firestore.collection('Ambulances').doc(id).delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Ambulance deleted successfully!")),
//       );
//       _fetchAmbulances(); // Refresh the list after deletion
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to delete ambulance: $error")),
//       );
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
//         child: Column(
//           children: [
//             // Custom AppBar
//             Container(
//               padding: EdgeInsets.only(
//                 top: screenHeight * 0.05,
//                 left: screenWidth * 0.04,
//                 right: screenWidth * 0.04,
//                 bottom: screenHeight * 0.02,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       height: screenWidth * 0.1,
//                       width: screenWidth * 0.1,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(17),
//                         color: Colors.transparent,
//                         border: Border.all(
//                           color: const Color.fromRGBO(0, 0, 0, 1),
//                           width: 1,
//                         ),
//                       ),
//                       child: const Icon(
//                         size: 30,
//                         Icons.arrow_back_ios_new_rounded,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     'Ambulances',
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.07,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.09),
//                 ],
//               ),
//             ),

//             // List of Ambulances or Loading Indicator
//             Expanded(
//               child: _isLoading
//                   ? const Center(
//                       child: CircularProgressIndicator()) // Show loader
//                   : _ambulancesList.isEmpty
//                       ? const Center(child: Text("No ambulances available"))
//                       : ListView.builder(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: screenWidth * 0.04),
//                           itemCount: _ambulancesList.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             final ambulance = _ambulancesList[index];
//                             return Padding(
//                               padding:
//                                   EdgeInsets.only(bottom: screenHeight * 0.02),
//                               child: GestureDetector(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black87.withOpacity(0.4),
//                                         blurRadius: screenWidth * 0.015,
//                                         offset: Offset(0, screenWidth * 0.01),
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.circular(
//                                         screenWidth * 0.03),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       const SizedBox(width: 25),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             const SizedBox(height: 15),
//                                             Text(
//                                               "Name: ${ambulance['name'] ?? "Unknown"}",
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.04,
//                                                 color: const Color.fromRGBO(
//                                                     0, 0, 0, 1),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Text(
//                                               "Number: ${ambulance['phone'] ?? "Unknown"}",
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.04,
//                                                 color: const Color.fromRGBO(
//                                                     0, 0, 0, 1),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Text(
//                                               "Location: ${ambulance['location']}",
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.035,
//                                                 height: 1.5,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: const Color.fromRGBO(
//                                                     0, 0, 0, 0.7),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Text(
//                                               "Charges: ${ambulance['charges']}",
//                                               style: GoogleFonts.inter(
//                                                 fontSize: screenWidth * 0.035,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: const Color.fromRGBO(
//                                                     0, 0, 0, 0.7),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 10),
//                                           ],
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(Icons.delete_outlined,
//                                             color: Colors.black, size: 30),
//                                         onPressed: () {
//                                           _deleteAmbulance(ambulance['id']);
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmbulancesList extends StatefulWidget {
  const AmbulancesList({super.key});

  @override
  _AmbulancesListState createState() => _AmbulancesListState();
}

class _AmbulancesListState extends State<AmbulancesList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _ambulancesList = [];
  bool _isLoading = true; // Loading indicator state

  @override
  void initState() {
    super.initState();
    _fetchAmbulances();
  }

  void _fetchAmbulances() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Ambulances').get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> loadedAmbulances = [];
        for (var doc in snapshot.docs) {
          loadedAmbulances.add({
            'id': doc.id,
            'name': doc['name'],
            'phone': doc['phone'],
            'location': doc['location'],
            'charges': doc['charges'],
            'ambulanceType': doc['ambulanceType'],
          });
        }

        setState(() {
          _ambulancesList = loadedAmbulances;
        });
      } else {
        setState(() {
          _ambulancesList = [];
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load ambulances: $error")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Data loading complete
      });
    }
  }

  void _editAmbulance(Map<String, dynamic> ambulance) async {
    TextEditingController nameController =
        TextEditingController(text: ambulance['name']);
    TextEditingController phoneController =
        TextEditingController(text: ambulance['phone']);
    TextEditingController locationController =
        TextEditingController(text: ambulance['location']);
    TextEditingController chargesController =
        TextEditingController(text: ambulance['charges'].toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Ambulance",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
              TextField(
                controller: chargesController,
                decoration: const InputDecoration(labelText: "Charges"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firestore
                    .collection('Ambulances')
                    .doc(ambulance['id'])
                    .update({
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'location': locationController.text,
                  'charges': int.parse(chargesController.text),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ambulance updated successfully!")),
                );
                _fetchAmbulances(); // Refresh the list
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update ambulance: $error")),
                );
              } finally {
                Navigator.pop(context); // Close the dialog
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteAmbulance(String id) async {
    try {
      await _firestore.collection('Ambulances').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ambulance deleted successfully!")),
      );
      _fetchAmbulances(); // Refresh the list after deletion
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete ambulance: $error")),
      );
    }
  }

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
        child: Column(
          children: [
            // Custom AppBar
            Container(
              padding: EdgeInsets.only(
                top: screenHeight * 0.05,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                bottom: screenHeight * 0.02,
              ),
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
                    'Ambulances',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.09),
                ],
              ),
            ),

            // List of Ambulances or Loading Indicator
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator()) // Show loader
                  : _ambulancesList.isEmpty
                      ? const Center(child: Text("No ambulances available"))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          itemCount: _ambulancesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ambulance = _ambulancesList[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                              child: GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow:  [
                                      BoxShadow(
                                        color: Colors.black87.withOpacity(0.4),
                                        blurRadius: screenWidth * 0.015,
                                        offset: Offset(0, screenWidth * 0.01),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 25),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            Text(
                                              "Name: ${ambulance['name'] ?? "Unknown"}",
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.04,
                                                color: const Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Number: ${ambulance['phone'] ?? "Unknown"}",
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.04,
                                                color: const Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Location: ${ambulance['location']}",
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.035,
                                                height: 1.5,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromRGBO(0, 0, 0, 0.7),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Charges: ${ambulance['charges']}",
                                              style: GoogleFonts.inter(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromRGBO(0, 0, 0, 0.7),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, color: Colors.black),
                                        onPressed: () => _editAmbulance(ambulance),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.black),
                                        onPressed: () => _deleteAmbulance(ambulance['id']),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

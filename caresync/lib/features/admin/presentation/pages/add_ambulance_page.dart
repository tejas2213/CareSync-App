// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AddAmbulancePage extends StatefulWidget {
//   const AddAmbulancePage({super.key});

//   @override
//   _AddAmbulancePageState createState() => _AddAmbulancePageState();
// }

// class _AddAmbulancePageState extends State<AddAmbulancePage> {
//   final _ambulanceNameController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _chargesController = TextEditingController();
//   final _phoneController = TextEditingController();
//   String _selectedAmbulanceType = 'Basic Life Support';

//   final List<String> _ambulanceTypes = [
//     'Basic Life Support',
//     'Advanced Life Support',
//     'Patient Transport',
//   ];

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _isLoading = false;
//   bool _isNameValid = true;
//   bool _isLocationValid = true;
//   bool _isPhoneValid = true;
//   bool _isChargesValid = true;

//   void addAmbulance() async {
//     setState(() {
//       _isLoading = true;
//     });

//     String ambulanceName = _ambulanceNameController.text;
//     String phoneNumber = _phoneController.text;
//     String location = _locationController.text;
//     String charges = _chargesController.text;
//     String ambulanceType = _selectedAmbulanceType;

//     bool isValid = true;

//     if (ambulanceName.isEmpty) {
//       _isNameValid = false;
//       isValid = false;
//     } else {
//       _isNameValid = true;
//     }

//     if (location.isEmpty) {
//       _isLocationValid = false;
//       isValid = false;
//     } else {
//       _isLocationValid = true;
//     }

//     if (phoneNumber.isEmpty) {
//       _isPhoneValid = false;
//       isValid = false;
//     } else {
//       _isPhoneValid = true;
//     }

//     if (charges.isEmpty) {
//       _isChargesValid = false;
//       isValid = false;
//     } else {
//       _isChargesValid = true;
//     }

//     if (isValid) {
//       try {
//         await _firestore.collection('Ambulances').add({
//           'name': ambulanceName,
//           'phone': phoneNumber,
//           'location': location,
//           'charges': charges,
//           'ambulanceType': ambulanceType,
//         });

//         setState(() {
//           _isLoading = false;
//         });

//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text("Success"),
//               content: const Text("Ambulance added successfully!"),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text("OK"),
//                 ),
//               ],
//             );
//           },
//         );

//         _ambulanceNameController.clear();
//         _phoneController.clear();
//         _locationController.clear();
//         _chargesController.clear();
//       } catch (error) {
//         setState(() {
//           _isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to add ambulance: $error")));
//       }
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please fill all fields")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Stack(
//         children: [
//           Container(
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
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16.0, 70, 16, 0),
//             child: Column(
//               children: [
//                 // Custom AppBar
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         height: 42,
//                         width: 42,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(17),
//                             color: Colors.transparent,
//                             border: Border.all(
//                                 color: const Color.fromRGBO(0, 0, 0, 1),
//                                 width: 1)),
//                         child: const Icon(
//                           size: 30,
//                           Icons.arrow_back_ios_new_rounded,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'Add Ambulance',
//                       style: GoogleFonts.poppins(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                   ],
//                 ),
//                 const SizedBox(height: 50),
//                 // Form Section
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildTextField(
//                         controller: _ambulanceNameController,
//                         labelText: "Ambulance Name",
//                         icon: Icons.local_hospital,
//                         isValid: _isNameValid,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildTextField(
//                         controller: _phoneController,
//                         labelText: "Phone Number",
//                         icon: Icons.phone,
//                         keyboardType: TextInputType.phone,
//                         isValid: _isPhoneValid,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildTextField(
//                         controller: _locationController,
//                         labelText: "Location",
//                         icon: Icons.location_on,
//                         isValid: _isLocationValid,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildTextField(
//                         controller: _chargesController,
//                         labelText: "Charges",
//                         icon: Icons.attach_money,
//                         keyboardType: TextInputType.number,
//                         isValid: _isChargesValid,
//                       ),
//                       const SizedBox(height: 20),
//                       DropdownButtonFormField<String>(
//                         value: _selectedAmbulanceType,
//                         items: _ambulanceTypes.map((type) {
//                           return DropdownMenuItem<String>(
//                               value: type, child: Text(type));
//                         }).toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedAmbulanceType = newValue!;
//                           });
//                         },
//                         decoration: InputDecoration(
//                           labelText: "Select Ambulance Type",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           prefixIcon: const Icon(Icons.car_repair),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: addAmbulance,
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 40,
//                               vertical: 15,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             backgroundColor:
//                                 const Color.fromRGBO(14, 190, 127, 1),
//                           ),
//                           child: _isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : const Text(
//                                   "Add Ambulance",
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.white),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     IconData? icon,
//     TextInputType keyboardType = TextInputType.text,
//     bool isValid = true,
//   }) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         prefixIcon: icon != null ? Icon(icon) : null,
//         filled: !isValid,
//         fillColor: isValid ? Colors.white : Colors.red[100],
//         errorText: !isValid ? 'This field is required' : null,
//       ),
//       keyboardType: keyboardType,
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAmbulancePage extends StatefulWidget {
  const AddAmbulancePage({super.key});

  @override
  _AddAmbulancePageState createState() => _AddAmbulancePageState();
}

class _AddAmbulancePageState extends State<AddAmbulancePage> {
  final _ambulanceNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _chargesController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedAmbulanceType = 'Basic Life Support';

  final List<String> _ambulanceTypes = [
    'Basic Life Support',
    'Advanced Life Support',
    'Patient Transport',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _isNameValid = true;
  bool _isLocationValid = true;
  bool _isPhoneValid = true;
  bool _isChargesValid = true;

  void addAmbulance() async {
    setState(() {
      _isLoading = true;
    });

    String ambulanceName = _ambulanceNameController.text;
    String phoneNumber = _phoneController.text;
    String location = _locationController.text;
    String charges = _chargesController.text;
    String ambulanceType = _selectedAmbulanceType;

    bool isValid = true;

    if (ambulanceName.isEmpty) {
      _isNameValid = false;
      isValid = false;
    } else {
      _isNameValid = true;
    }

    if (location.isEmpty) {
      _isLocationValid = false;
      isValid = false;
    } else {
      _isLocationValid = true;
    }

    if (phoneNumber.isEmpty) {
      _isPhoneValid = false;
      isValid = false;
    } else {
      _isPhoneValid = true;
    }

    if (charges.isEmpty) {
      _isChargesValid = false;
      isValid = false;
    } else {
      _isChargesValid = true;
    }

    if (isValid) {
      try {
        await _firestore.collection('Ambulances').add({
          'name': ambulanceName,
          'phone': phoneNumber,
          'location': location,
          'charges': charges,
          'ambulanceType': ambulanceType,
        });

        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Ambulance added successfully!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        _ambulanceNameController.clear();
        _phoneController.clear();
        _locationController.clear();
        _chargesController.clear();
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add ambulance: $error")));
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
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
            padding: const EdgeInsets.fromLTRB(16.0, 70, 16, 0),
            child: Column(
              children: [
                // Custom AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 42,
                        width: 42,
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
                    Text(
                      'Add Ambulance',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 50),
                // Form Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _ambulanceNameController,
                        labelText: "Ambulance Name",
                        icon: Icons.local_hospital,
                        isValid: _isNameValid,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _phoneController,
                        labelText: "Phone Number",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        isValid: _isPhoneValid,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _locationController,
                        labelText: "Location",
                        icon: Icons.location_on,
                        isValid: _isLocationValid,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _chargesController,
                        labelText: "Charges",
                        icon: Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        isValid: _isChargesValid,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedAmbulanceType,
                        items: _ambulanceTypes.map((type) {
                          return DropdownMenuItem<String>(
                              value: type, child: Text(type));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedAmbulanceType = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Select Ambulance Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.car_repair),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: addAmbulance,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                const Color.fromRGBO(14, 190, 127, 1),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Add Ambulance",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // StreamBuilder for ambulance list
                      // Expanded(
                      //   child: StreamBuilder<QuerySnapshot>(
                      //     stream:
                      //         _firestore.collection('Ambulances').snapshots(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return const Center(
                      //           child: CircularProgressIndicator(),
                      //         );
                      //       }

                      //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      //         return const Center(
                      //           child: Text("No ambulances available."),
                      //         );
                      //       }

                      //       final ambulances = snapshot.data!.docs;

                      //       return ListView.builder(
                      //         itemCount: ambulances.length,
                      //         itemBuilder: (context, index) {
                      //           final ambulanceData = ambulances[index].data()
                      //               as Map<String, dynamic>;

                      //           return ListTile(
                      //             leading: const Icon(Icons.local_hospital),
                      //             title: Text(ambulanceData['name'] ?? "N/A"),
                      //             subtitle: Text(
                      //                 "Type: ${ambulanceData['ambulanceType'] ?? "N/A"}\nCharges: ${ambulanceData['charges'] ?? "N/A"}"),
                      //             isThreeLine: true,
                      //           );
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool isValid = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        errorText: isValid ? null : "This field is required",
      ),
    );
  }
}

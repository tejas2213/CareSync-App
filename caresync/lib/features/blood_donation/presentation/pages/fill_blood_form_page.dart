import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:caresync/features/patients/presentation/pages/patient_home_page.dart';

class Bloodgroup extends StatefulWidget {
  const Bloodgroup({super.key});

  @override
  _BloodgroupState createState() => _BloodgroupState();
}

class _BloodgroupState extends State<Bloodgroup> {
  final _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;
  String? _selectedBloodGroup;

  final List<String> _bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(
            right: screenWidth * 0.04,
            left: screenWidth * 0.04,
            top: screenHeight * 0.04,
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
                  onTap: () => Navigator.pop(context),
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
                SizedBox(width: screenWidth * 0.14),
                Center(
                  child: Text(
                    "Search Blood",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FadeInUp(
                  child: Stack(
                    children: [
                      // Positioned(
                      //   top: 100,
                      //   left: 0,
                      //   right: 0,
                      //   child: Opacity(
                      //     opacity: 0.5,
                      //     child: Image.asset(
                      //       'assets/gif/Blood Drop.gif',
                      //       width: 700,
                      //       height: 700,
                      //       fit: BoxFit.contain,
                      //     ),
                      //   ),
                      // ),
                      Container(
                        height: screenHeight * 0.899,
                        padding: const EdgeInsets.all(2.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // const SizedBox(height: 10),

                              // const SizedBox(height: 10),
                              Lottie.asset("assets/json/searchBlood.json",
                                  height: 230, width: 230),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // border: Border.all(color: Colors.black87),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          // contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                          labelText: "Name:",
                                          labelStyle: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade600),
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your name";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _numberController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          // contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                          labelText: "Number:",
                                          labelStyle: GoogleFonts.poppins(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          prefixIcon: const Icon(Icons.phone,
                                              color: Colors.grey),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your number";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: "E-mail:",
                                          labelStyle: GoogleFonts.poppins(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          } else if (!RegExp(
                                                  r'^[^@]+@[^@]+\.[^@]+')
                                              .hasMatch(value)) {
                                            return 'Enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _ageController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: "Age:",
                                          labelStyle: GoogleFonts.poppins(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.calendar_today,
                                            color: Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your age";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      DropdownButtonFormField<String>(
                                        value:
                                            null, // You can set a default value if needed
                                        items: ['Female', 'Male']
                                            .map((gender) =>
                                                DropdownMenuItem<String>(
                                                  value: gender,
                                                  child: Text(
                                                    gender,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          _selectedGender = value ??
                                              ''; // Update the controller with selected value
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Gender:",
                                          labelStyle: GoogleFonts.poppins(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.people,
                                            color: Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please select your gender";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                          labelText: "Address:",
                                          labelStyle: GoogleFonts.poppins(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your address";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      // DropdownButtonFormField<String>(
                                      //   decoration: InputDecoration(
                                      //     labelText: "Select Your Blood Group",
                                      //     labelStyle: GoogleFonts.poppins(
                                      //       color: Colors.black,
                                      //       fontSize: 16,
                                      //       fontWeight: FontWeight.w600,
                                      //     ),
                                      //     prefixIcon:
                                      //         const Icon(Icons.bloodtype),
                                      //     filled: true,
                                      //     fillColor: Colors.transparent,
                                      //     border: OutlineInputBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(12),
                                      //     ),
                                      //   ),
                                      //   style: GoogleFonts.poppins(
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.w500,
                                      //     color: Colors.black,
                                      //   ),
                                      //   value: _selectedBloodGroup,
                                      //   items: _bloodGroups.map((bloodGroup) {
                                      //     return DropdownMenuItem(
                                      //       value: bloodGroup,
                                      //       child: Text(bloodGroup),
                                      //     );
                                      //   }).toList(),
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       _selectedBloodGroup = value;
                                      //     });
                                      //   },
                                      //   validator: (value) {
                                      //     if (value == null || value.isEmpty) {
                                      //       return "Please select a blood group";
                                      //     }
                                      //     return null;
                                      //   },
                                      // ),
                                      DropdownButtonFormField<String>(
                                        value: _selectedBloodGroup,
                                        items: _bloodGroups.map((bloodGroup) {
                                          return DropdownMenuItem(
                                            value: bloodGroup,
                                            child: Text(bloodGroup),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedBloodGroup = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Select Your Blood Group",
                                          labelStyle: GoogleFonts.poppins(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          prefixIcon: const Icon(
                                              Icons.bloodtype,
                                              color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please select a blood group";
                                          }
                                          return null;
                                        },
                                      ),

                                      const SizedBox(height: 20),
                                      Center(
                                        child: ElevatedButton(
                                          // onPressed: () {
                                          //   dialogBuilder(context);

                                          //   addToFirebase();
                                          // },
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              dialogBuilder(context);
                                              await addToFirebase();
                                              // Navigator.pushReplacement(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const PatientHomeScreen()),
                                              // );
                                            } else {
                                              // Optionally add feedback like a SnackBar to notify the user
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please fill all fields correctly")),
                                              );
                                            }
                                          },

                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            shadowColor:
                                                Colors.red.withOpacity(0.5),
                                            elevation: 10,
                                          ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF4C4C),
                                                  Color(0xFFFF0000),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                stops: [0.3, 1],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              // boxShadow: [
                                              //   BoxShadow(
                                              //     color: Colors.red
                                              //         .withOpacity(0.009),
                                              //     offset: const Offset(0, 4),
                                              //     blurRadius: 8,
                                              //   ),
                                              // ],
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 24),
                                              child: Text(
                                                "Submit",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToFirebase() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    final patientId = currentUser?.uid ?? '';

    log("Data filled by Patient Id :- $patientId");

    dynamic data = await firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection("search blood")
        .add({
      'name': _nameController.text.trim(),
      'recipientId': patientId,
      'role': 'recipient',
      'phone': _numberController.text.trim(),
      'email': _emailController.text.trim(),
      'age': _ageController.text.trim(),
      'gender': _selectedGender,
      'address': _addressController.text.trim(),
      'blood group': _selectedBloodGroup,
      'createdAt': DateTime.now(),
      'status': 'pending',
      'donorId': '',
      'donorName' : '',
      'donorRole': ''
    });

    dynamic currentBloodFormId = data.id;
    log("Current form id : $currentBloodFormId");
    // Store user information in Firestore
    await firestore.collection('blood finder').add({
      'name': _nameController.text.trim(),
      'recipientFormId': currentBloodFormId,
      'recipientId': patientId,
      'role': 'recipient',
      'phone': _numberController.text.trim(),
      'email': _emailController.text.trim(),
      'age': _ageController.text.trim(),
      'gender': _selectedGender,
      'address': _addressController.text.trim(),
      'blood group': _selectedBloodGroup,
      'createdAt': DateTime.now(),
      'status': 'pending',
      'donorId': '',
      'donorName' : '',
      'donorRole': ''
    });

    log("Data added succeddfully");
    _nameController.clear();
    _numberController.clear();
    _emailController.clear();
    _ageController.clear();
    _addressController.clear();
    _selectedBloodGroup = null;
    _selectedGender = null;
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
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(143, 208, 185, 0.416),
                        ),
                        child: Lottie.asset("assets/json/bloodConfirm.json")),
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
                        "We will notify you shortly",
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
                      "Required blood : $_selectedBloodGroup",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(103, 114, 148, 1)),
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
                      child:  Text("OK",style:GoogleFonts.poppins(color:Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool _isEditable = false; // To track if the fields should be editable
  bool _isLoading = false; // To track loading state for save button
  bool _isImageSelected = false; // Track if image has been selected
  File? _profileImage; // The profile image file
  String _imageUrl = ''; // To store the Firebase Storage image URL

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  // Future<void> _loadPatientData() async {
  //   try {
  //     User? user = _auth.currentUser;
  //     if (user != null) {
  //       // Fetch patient data from Firestore
  //       DocumentSnapshot snapshot = await _firestore
  //           .collection('CareSync')
  //           .doc('patients')
  //           .collection('accounts')
  //           .doc(user.uid)
  //           .get();

  //       if (snapshot.exists) {
  //         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

  //         // Update the controllers with the fetched data
  //         _nameController.text = data['name'] ?? '';
  //         _phoneController.text = data['phone'] ?? '';
  //         _emailController.text = data['email'] ?? '';
  //         _genderController.text = data['gender'] ?? '';
  //         _dobController.text = data['dob'] ?? '';
  //         _imageUrl =
  //             data['profileImage'] ?? ''; // Get image URL from Firestore
  //       }
  //     }
  //   } catch (e) {
  //     print('Error fetching patient data: $e');
  //   }
  // }

  Future<void> _loadPatientData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Fetch patient data from Firestore
        DocumentSnapshot snapshot = await _firestore
            .collection('CareSync')
            .doc('patients')
            .collection('accounts')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          // Update the controllers with the fetched data
          setState(() {
            _nameController.text = data['name'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _emailController.text = data['email'] ?? '';
            _genderController.text = data['gender'] ?? '';
            _dobController.text = data['dob'] ?? '';
            _imageUrl =
                data['profileImage'] ?? ''; // Get image URL from Firestore
          });
        }
      }
    } catch (e) {
      print('Error fetching patient data: $e');
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String imageUrl =
            _imageUrl; // Use existing image URL if no new image is selected

        if (_profileImage != null) {
          // If the user has selected a new profile image, upload it to Firebase Storage
          final storageRef =
              _storage.ref().child('CareSync/${user.uid}/profile.jpg');
          await storageRef.putFile(_profileImage!); // Upload the file
          imageUrl = await storageRef
              .getDownloadURL(); // Get the URL of the uploaded image
        }

        // Update Firestore with the new data, including the image URL
        await _firestore
            .collection('CareSync')
            .doc('patients')
            .collection('accounts')
            .doc(user.uid)
            .update({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'gender': _genderController.text,
          'dob': _dobController.text,
          'profileImage': imageUrl, // Save the new image URL
        });

        // Success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Changes saved successfully!")),
        );
      }
    } catch (e) {
      // Handle any errors that occur during saving
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving changes")),
      );
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
        _isEditable = false; // Hide the save button after saving
      });
    }
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Function to pick image from device
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _isImageSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.topCenter,
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
          padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.01, 16.0, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Custom AppBar
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
                                color: const Color.fromRGBO(0, 0, 0, 1),
                                width: 1)),
                        child: const Icon(
                          size: 30,
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.37),
                    Expanded(
                      child: Text(
                        "Profile",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.1),
                  ],
                ),

                // Profile picture with edit icon
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: screenWidth * 0.1,
                          backgroundImage: _isImageSelected
                              ? FileImage(_profileImage!)
                              : (_imageUrl.isNotEmpty
                                  ? NetworkImage(_imageUrl)
                                  : null),
                          child: !_isImageSelected && _imageUrl.isEmpty
                              ? const Icon(Icons.camera_alt,
                                  size: 30, color: Colors.white)
                              : null,
                        )),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isEditable = !_isEditable;
                          });
                        },
                        child: Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: screenWidth * 0.05,
                            color: const Color.fromRGBO(14, 190, 127, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),

                // TextFields for user input with custom styling
                _buildTextField(_nameController, "Name", Icons.person),
                _buildTextField(_phoneController, "Phone Number", Icons.phone),
                _buildTextField(_emailController, "Email", Icons.email),
                _buildTextField(_genderController, "Gender", Icons.male),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      _dobController,
                      "Date of Birth",
                      Icons.calendar_today,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Save changes button
                _isEditable
                    ? ElevatedButton(
                        onPressed: _isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(14, 190, 127, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Save Changes",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build text fields with customized styles
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        readOnly: !_isEditable,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
          ),
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();

  bool _isEditable = false;
  bool _isLoading = false;

  File? _selectedImage;
  String? _profileImageUrl;

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await _firestore
            .collection('CareSync')
            .doc('doctors')
            .collection('accounts')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

          // Update controllers

          fullNameController.text = data['name'] ?? '';
          phoneController.text = data['phone'] ?? '';
          emailController.text = data['email'] ?? '';
          qualificationController.text = data['qualification'] ?? '';
          specializationController.text = data['specialization'] ?? '';
          dobController.text = data['dob'] ?? '';
          _profileImageUrl = data['imageUrl'];
          imageUrl = data['imageUrl'];
        }
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
    setState(() {
      imageUrl != null && imageUrl!.isNotEmpty;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String filePath = 'CareSync/${user.uid}/profile.jpg';
        TaskSnapshot snapshot = await _storage.ref(filePath).putFile(imageFile);
        return await snapshot.ref.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
    return null;
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? imageUrl;
        if (_selectedImage != null) {
          imageUrl = await _uploadImage(_selectedImage!);
        }

        await _firestore
            .collection('CareSync')
            .doc('doctors')
            .collection('accounts')
            .doc(user.uid)
            .update({
          'name': fullNameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'qualification': qualificationController.text,
          'specialization': specializationController.text,
          'dob': dobController.text,
          'profileImage': imageUrl ?? _profileImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Changes saved successfully!")),
        );

        setState(() {
          _profileImageUrl = imageUrl ?? _profileImageUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving changes")),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isEditable = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
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
          padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.05, 16.0, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile header and back button
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
                    SizedBox(width: screenWidth * 0.25),
                    Center(
                      child: Text(
                        "Profile",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Profile Image with Edit Icon
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: screenWidth * 0.1,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) // Display picked image
                            : (imageUrl != null && imageUrl!.isNotEmpty
                                ? NetworkImage(
                                    imageUrl!) // Display image from Firestore
                                : null), // Fallback to default
                        child: (_selectedImage == null &&
                                (imageUrl == null || imageUrl!.isEmpty))
                            ? Icon(Icons.person,
                                size: screenWidth * 0.1, color: Colors.grey)
                            : null, // Display default icon if no image
                      ),
                    ),
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
                          width: screenWidth * 0.06,
                          height: screenWidth * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: screenWidth * 0.04,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Text Fields
                _buildTextField("Full Name", fullNameController),
                const SizedBox(
                  height: 10,
                ),
                _buildTextField("Phone Number", phoneController),
                const SizedBox(
                  height: 10,
                ),
                _buildTextField("Email", emailController, readOnly: true),
                const SizedBox(
                  height: 10,
                ),
                _buildTextField("Qualification", qualificationController),
                const SizedBox(
                  height: 10,
                ),
                _buildTextField("Specialization", specializationController),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: _buildTextField(
                    "Date of Birth",
                    dobController,
                  ),
                ),

                const SizedBox(height: 20),

                // Save Changes Button or Loading Spinner
                _isLoading
                    ? const CircularProgressIndicator()
                    : _isEditable
                        ? ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.3,
                                  vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor:
                                  const Color.fromRGBO(14, 190, 127, 1),
                            ),
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly || !_isEditable,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

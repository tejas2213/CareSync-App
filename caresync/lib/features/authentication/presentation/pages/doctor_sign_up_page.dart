import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:caresync/features/authentication/presentation/pages/doctor_sign_in_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class DoctorSignUpPage extends StatefulWidget {
  const DoctorSignUpPage({super.key});

  @override
  State createState() => _DoctorSignUpPageState();
}

class _DoctorSignUpPageState extends State {
  final _doctorformKey = GlobalKey<FormState>();
  final TextEditingController _dnameController = TextEditingController();
  final TextEditingController _dphoneController = TextEditingController();
  final TextEditingController _demailController = TextEditingController();
  final TextEditingController _dpasswordController = TextEditingController();
  final TextEditingController _dspecializationController =
      TextEditingController();
  final TextEditingController _dclinicController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _dselectedGender;
  String? _dselectedSpecialization;
  bool _isLoading = false;

  File? _selectedImage;
  String? _profileImageUrl;
  bool _isEditable = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
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

  Future<void> _signUp() async {
    if (_doctorformKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Create a new user with Firebase Authentication
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _demailController.text.trim(),
          password: _dpasswordController.text.trim(),
        );

        String? imageUrl;
      if (_selectedImage != null) {
        // Upload image to Firebase Storage and get the URL
        imageUrl = await _uploadImage(_selectedImage!);
        if (imageUrl == null) {
          throw Exception('Image upload failed');
        }
      }

        // Store user information in Firestore
        await _firestore
            .collection('CareSync')
            .doc('doctors')
            .collection('accounts')
            .doc(userCredential.user!.uid)
            .set({
              'imageUrl' : imageUrl, 
          'name': _dnameController.text.trim(),
          'role': 'doctors',
          'phone': _dphoneController.text.trim(),
          'email': _demailController.text.trim(),
          'gender': _dselectedGender,
          'specialization': _dselectedSpecialization,
          'cliniclocation': _dclinicController.text.trim(),
          'createdAt': DateTime.now(),
        });

        // Show a success message and navigate to the Sign In page
        _showSnackbar("Account created successfully!");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DoctorSignInPage(),
          ),
        );
      } catch (e) {
        _showSnackbar("Failed to create account: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Container(
        height: screenHeight,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, screenHeight * 0.02, 20, 0),
            child: Form(
              key: _doctorformKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInUp(
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 28 : 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  FadeInUp(
                    child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: screenWidth * 0.1,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : _profileImageUrl != null
                                  ? NetworkImage(_profileImageUrl!)
                                  : null,
                          child: _profileImageUrl == null && _selectedImage == null
                              ? Icon(Icons.person, size: screenWidth * 0.1,color:Colors.white)
                              : null,
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
                  ),
                  FadeInUp(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      child: TextFormField(
                        controller: _dnameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: 'Enter your name',
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  FadeInUp(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.013),
                      child: TextFormField(
                        controller: _dphoneController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone),
                          labelText: "Phone Number",
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.length != 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  FadeInUp(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.013),
                      child: TextFormField(
                        controller: _demailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'Enter your email',
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  FadeInUp(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      child: DropdownButtonFormField<String>(
                        value: _dselectedGender,
                        hint: const Text("Select Gender"),
                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("Male")),
                          DropdownMenuItem(value: "Female", child: Text("Female")),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.male_outlined),
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _dselectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  FadeInUp(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      child: DropdownButtonFormField<String>(
                        value: _dselectedSpecialization,
                        hint: const Text("Select Specialization"),
                        items: const [
                          DropdownMenuItem(
                              value: "Cardiology", child: Text("Cardiology")),
                          DropdownMenuItem(
                              value: "Dermatology", child: Text("Dermatology")),
                          DropdownMenuItem(
                              value: "General Medicine", child: Text("General Medicine")),
                          DropdownMenuItem(
                              value: "Gynecology", child: Text("Gynecology")),
                          DropdownMenuItem(
                              value: "Odontology", child: Text("Odontology")),
                          DropdownMenuItem(
                              value: "Oncology", child: Text("Oncology")),
                          DropdownMenuItem(
                              value: "Ophthalmology",child: Text("Ophthalmology")),
                          DropdownMenuItem(
                              value: "Orthopedics", child: Text("Orthopedics")),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _dselectedSpecialization = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your specialization';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  FadeInUp(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      child: TextFormField(
                        controller: _dclinicController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          labelText: 'Enter your Clinic Location',
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your clinic location';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  FadeInUp(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      child: TextFormField(
                        controller: _dpasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: _togglePasswordVisibility,
                          ),
                          labelText: 'Enter your password',
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  FadeInUp(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromRGBO(14, 190, 127, 1),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  FadeInUp(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text("Already have an account? ",style:GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DoctorSignInPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }
}

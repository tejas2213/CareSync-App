import 'dart:io';
import 'package:caresync/features/admin/presentation/pages/add_categories_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({super.key});

  @override
  _AddStoreScreenState createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _profileImage;
  bool _isImageSelected = false;
  bool _isLoading = false;  
  String? _lastAddedStoreName;
  String? _lastAddedStoreId;

  final Set<String> _invalidFields = {};

  final CollectionReference _medicalStoresRef =
      FirebaseFirestore.instance.collection('Medical Stores');

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

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'CareSync/medical_stores/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image upload failed: $e')));
      return null;
    }
  }

  bool _isPhoneNumberValid(String phone) {
    final regex = RegExp(r'^\+91\d{10}$');
    return regex.hasMatch(phone);
  }

  void _saveStore() async {
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();
    String phone = _phoneController.text.trim();

    // Validate fields and show red border if necessary
    if (name.isEmpty || address.isEmpty || phone.isEmpty) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    if (!_isPhoneNumberValid(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Phone number must be 10 digits and start with +91")));
      return;
    }

    setState(() {
      _isLoading = true;  
    });

    String? imageUrl;
    if (_isImageSelected && _profileImage != null) {
      imageUrl = await _uploadImage(_profileImage!);
      if (imageUrl == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    try {
      final newStoreRef = _medicalStoresRef.doc();
      String storeId = newStoreRef.id;
      
      await newStoreRef.set({
        'name': name,
        'phone': phone,
        'address': address,
        'image_url': imageUrl ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isLoading = false;  // Hide the progress indicator
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Medical Store added successfully!"),
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

      // Clear text fields and reset state
      _nameController.clear();
      _phoneController.clear();
      _addressController.clear();
      setState(() {
        _profileImage = null;
        _isImageSelected = false;
        _lastAddedStoreName = name;
        _lastAddedStoreId = storeId;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add medical store: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            child: Column(
              children: [
                Row(
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
                              width: 1)),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                      ),
                    ),
                    Text(
                      'Add Medical Store',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.09),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: screenWidth * 0.1,
                    backgroundImage: _isImageSelected && _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: !_isImageSelected
                        ? const Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Store Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Store Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(14, 190, 127, 1),
                  ),
                  child: GestureDetector(
                    onTap: _saveStore,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Add Store',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_lastAddedStoreName != null &&
                    _lastAddedStoreId != null) ...[
                  const Divider(),
                  const SizedBox(height: 15,),
                  Text(
                    'Store Added: $_lastAddedStoreName',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15,),
                  const Divider(),
                  const SizedBox(height: 15,),
                  Container(
                    alignment: Alignment.center,
                    width: 160,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(14, 190, 127, 1),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCategoriesScreen(
                          storeId: _lastAddedStoreId!,
                          storeName: _lastAddedStoreName!,
                        ),
                      ),
                    );
                      },
                      child: const Text(
                        'Add Categories',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

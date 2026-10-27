import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';

// To format date and time
import 'package:url_launcher/url_launcher.dart';

class AllRecords extends StatefulWidget {
  const AllRecords({super.key});

  @override
  State<AllRecords> createState() => _AllRecordsState();
}

class _AllRecordsState extends State<AllRecords> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _selectedFile;
  File? _selectedImage;
  final String _customName = '';
  final TextEditingController _nameController = TextEditingController();
  bool _isUploading = false; // Track if the app is uploading

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _deleteRecord(String recordId, String fileUrl) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final patientId = currentUser?.uid ?? '';

    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();

      await _firestore
          .collection('CareSync')
          .doc('patients')
          .collection('accounts')
          .doc(patientId)
          .collection('medical_records')
          .doc(recordId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete record: $e')),
      );
    }
  }

  Future<void> _uploadFileOrImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final patientId = currentUser?.uid ?? '';

    if (_selectedFile == null && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file or image.')),
      );
      return;
    }

    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a name.')),
      );
      return;
    }

    setState(() {
      _isUploading = true; // Start the upload process
    });

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      File? fileToUpload = _selectedFile ?? _selectedImage;
      String type = _selectedFile != null ? 'file' : 'image';

      Reference ref =
          _storage.ref().child('CareSync/medical_records/$patientId/$fileName');

      // Upload the file/image
      UploadTask uploadTask = ref.putFile(fileToUpload!);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save metadata to Firestore
      await _firestore
          .collection('CareSync')
          .doc('patients')
          .collection('accounts')
          .doc(patientId)
          .collection("medical_records")
          .add({
        'type': type,
        'file_name': _nameController.text,
        'url': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploaded successfully!')),
      );

      // Reset state
      setState(() {
        _selectedFile = null;
        _selectedImage = null;
        _nameController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false; // End the upload process
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final currentUser = FirebaseAuth.instance.currentUser;
    final patientId = currentUser?.uid ?? '';

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
          padding: EdgeInsets.only(
            top: screenHeight * 0.06,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
          ),
          child: Column(
            children: [
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
                        border: Border.all(color: Colors.black,width: 1)
                      ),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.09),
                  Text(
                    "All Records",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('CareSync')
                      .doc('patients')
                      .collection('accounts')
                      .doc(patientId)
                      .collection('medical_records')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/json/record.json",height:180,width:180),
                            const SizedBox(height:20),
                            Text(
                              "No records found.",
                              style: GoogleFonts.poppins(
                                  fontSize: 20, color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }

                    final records = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        final isImage = record['type'] == 'image';
                        final fileName = record['file_name'];
                        final fileUrl = record['url'];
                        // final timestamp =
                        // (record['timestamp']).toDate();
                        // final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(timestamp);

                        // return Container(
                        //   child: ListTile(
                        //     leading: isImage
                        //         ? Image.network(
                        //             fileUrl,
                        //             width: 50,
                        //             height: 50,
                        //             fit: BoxFit.cover,
                        //           )
                        //         : const Icon(Icons.insert_drive_file,
                        //             size: 50, color: Colors.blue),
                        //     title: Text(fileName),
                        //     subtitle: Text('Uploaded on: $formattedDate'),
                        //     onTap: () {
                        //       _openFile(fileUrl);
                        //     },
                        //   ),
                        // );
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                    0.3), // Shadow color with opacity
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // Shadow position
                              ),
                            ],
                            border: Border.all(
                              color: Colors
                                  .grey.shade300, // Optional: Add a border
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: isImage
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      fileUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.insert_drive_file,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                            title: Text(
                              fileName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteRecord(record.id, fileUrl);
                              },
                            ),
                            onTap: () {
                              _openFile(fileUrl);
                            },
                          ),

                          // child: ListTile(
                          //   leading: isImage
                          //       ? ClipRRect(
                          //           borderRadius: BorderRadius.circular(
                          //               8), // Rounded corners for images
                          //           child: Image.network(
                          //             fileUrl,
                          //             width: 50,
                          //             height: 50,
                          //             fit: BoxFit.cover,
                          //           ),
                          //         )
                          //       : const Icon(
                          //           Icons.insert_drive_file,
                          //           size: 50,
                          //           color: Colors.blue,
                          //         ),
                          //   title: Text(
                          //     fileName,
                          //     style: const TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.black87,
                          //     ),
                          //   ),

                          //   onTap: () {
                          //     _openFile(fileUrl);
                          //   },
                          // ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(context),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 30, color: Color.fromRGBO(14, 190, 127, 1),),
      ),
    );
  }

  Future<void> _openFile(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Adjust for the keyboard
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  height: 5,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Add a record",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.file_copy_rounded),
                    labelText: 'Enter image/file name',
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Icon(Icons.photo, size: 25, color: Colors.grey[600]),
                      const SizedBox(width: 14),
                      Text(
                        "Upload from gallery",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: _pickFile,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf,
                          size: 25, color: Colors.grey[600]),
                      const SizedBox(width: 14),
                      Text(
                        "Upload files",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _uploadFileOrImage();
                  Navigator.pop(context); // Close the bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

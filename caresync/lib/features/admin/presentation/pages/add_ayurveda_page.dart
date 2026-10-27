// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';

// class AddItemScreen extends StatefulWidget {
//   const AddItemScreen({super.key});

//   @override
//   _AddItemScreenState createState() => _AddItemScreenState();
// }

// class _AddItemScreenState extends State<AddItemScreen> {
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   File? _selectedImage;
//   bool _isLoading = false;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _storeData() async {
//     if (_formKey.currentState!.validate() && _selectedImage != null) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         // Upload image to Firebase Storage
//         final storageRef = FirebaseStorage.instance
//             .ref()
//             .child('CareSync/ayurveda/${DateTime.now().toIso8601String()}');
//         final uploadTask = await storageRef.putFile(_selectedImage!);
//         final imageUrl = await uploadTask.ref.getDownloadURL();

//         // Store data in Firestore
//         await FirebaseFirestore.instance.collection('Ayurveda').add({
//           'name': _nameController.text.trim(),
//           'description': _descriptionController.text.trim(),
//           'image': imageUrl,
//           'createdAt': FieldValue.serverTimestamp(),
//         });

//         // Clear the form
//         _nameController.clear();
//         _descriptionController.clear();
//         setState(() {
//           _selectedImage = null;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Item added successfully!')));
//       } catch (e) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Error: $e')));
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } else if (_selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please select an image.')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0.0, 0.3, 0.7, 1.0],
//                 colors: [
//                   Color.fromRGBO(97, 206, 255, 220),
//                   Colors.white,
//                   Colors.white,
//                   Color.fromRGBO(14, 190, 126, 220),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         height: screenWidth * 0.1,
//                         width: screenWidth * 0.1,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(17),
//                           color: Colors.white,
//                         ),
//                         child: const Icon(
//                           size: 30,
//                           Icons.arrow_back_ios_new_rounded,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'Add Ayurveda Items',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.06,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.09),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Form(
//                   key: _formKey,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Center(
//                           child: GestureDetector(
//                             onTap: _pickImage,
//                             child: CircleAvatar(
//                               radius: 50,
//                               backgroundColor: Colors.grey[200],
//                               backgroundImage: _selectedImage != null
//                                   ? FileImage(_selectedImage!)
//                                   : null,
//                               child: _selectedImage == null
//                                   ? Icon(Icons.add_a_photo,
//                                       size: 35, color: Colors.grey[700])
//                                   : null,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 40),
//                         TextFormField(
//                           controller: _nameController,
//                           decoration: const InputDecoration(
//                             labelText: 'Name',
//                             border: OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return 'Please enter a name';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 25),
//                         TextFormField(
//                           controller: _descriptionController,
//                           decoration: const InputDecoration(
//                             labelText: 'Description',
//                             border: OutlineInputBorder(),
//                           ),
//                           maxLines: 3,
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return 'Please enter a description';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         Center(
//                           child: Container(
//                             alignment: Alignment.center,
//                             width: 150,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: const Color.fromRGBO(14, 190, 127, 1),
//                             ),
//                             child: GestureDetector(
//                               onTap: _isLoading ? null : _storeData,
//                               child: _isLoading
//                                   ? const SizedBox(
//                                       height: 20,
//                                       width: 20,
//                                       child: CircularProgressIndicator(
//                                           color: Colors.white, strokeWidth: 2),
//                                     )
//                                   : const Text(
//                                     'Add Item',
//                                     style: TextStyle(color: Colors.white, fontSize: 18),
//                                   ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _storeData() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an image.')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('CareSync/ayurveda/${DateTime.now().toIso8601String()}');
        final uploadTask = await storageRef.putFile(_selectedImage!);
        final imageUrl = await uploadTask.ref.getDownloadURL();

        // Store data in Firestore
        await FirebaseFirestore.instance.collection('Ayurveda').add({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'image': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Clear the form
        _nameController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedImage = null;
        });

        // Show success dialog
        _showDialog('Item added successfully!');
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to show dialog
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
     //resizeToAvoidBottomInset: false,
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
                      'Add Ayurveda Items',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.09),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : null,
                              child: _selectedImage == null
                                  ? Icon(Icons.add_a_photo,
                                      size: 35, color: Colors.grey[700])
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromRGBO(14, 190, 127, 1),
                            ),
                            child: GestureDetector(
                              onTap: _isLoading ? null : _storeData,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Add Item',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
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
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AyurvedaListScreen extends StatefulWidget {
//   const AyurvedaListScreen({super.key});

//   @override
//   State<AyurvedaListScreen> createState() => _AyurvedaListScreenState();
// }

// class _AyurvedaListScreenState extends State<AyurvedaListScreen> {
//   List<DocumentSnapshot> _items = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchItems();
//   }

//   Future<void> _fetchItems() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('Ayurveda')
//           .orderBy('createdAt', descending: true)
//           .get();

//       setState(() {
//         _items = querySnapshot.docs;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _deleteItem(BuildContext context, String documentId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Ayurveda')
//           .doc(documentId)
//           .delete();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Item deleted successfully.')),
//       );

//       setState(() {
//         _items.removeWhere((item) => item.id == documentId);
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting item: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text(
//       //     'Ayurveda Items',
//       //     style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
//       //   ),
//       //   backgroundColor: const Color.fromRGBO(14, 190, 126, 1),
//       // ),
//       body: Stack(
//         children: [
//           Container(
//              decoration: const BoxDecoration(
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
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
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
//                           color: Colors.transparent,
//                           border: Border.all(
//                               color: const Color.fromRGBO(0, 0, 0, 1),
//                               width: 1)),
//                       child: const Icon(
//                         size: 30,
//                         Icons.arrow_back_ios_new_rounded,
//                         color: Colors.black,
//                       ),
//                       ),
//                     ),
//                     const SizedBox(width: 22,),
//                     Text(
//                       'Add Ayurveda Items',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.06,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 _isLoading
//                     ? const Expanded(
//                         child: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       )
//                     : _items.isEmpty
//                         ? const Expanded(
//                             child: Center(
//                               child: Text(
//                                 'No items found.',
//                                 style:
//                                     TextStyle(fontSize: 18, color: Colors.grey),
//                               ),
//                             ),
//                           )
//                         : Expanded(
//                             child: ListView.builder(
//                               itemCount: _items.length,
//                               itemBuilder: (context, index) {
//                                 final item = _items[index];
//                                 final itemName = item['name'] as String;
//                                 final imageUrl = item['image'] as String;
//                                 final documentId = item.id;

//                                 return Card(
//                                   margin: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 8),
//                                   elevation: 5,
//                                   child: ListTile(
//                                     leading: imageUrl.isNotEmpty
//                                         ? CircleAvatar(
//                                             backgroundImage:
//                                                 NetworkImage(imageUrl),
//                                           )
//                                         : const CircleAvatar(
//                                             child: Icon(Icons.image),
//                                           ),
//                                     title: Text(
//                                       itemName,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     trailing: IconButton(
//                                       icon: const Icon(Icons.delete,
//                                           color: Colors.red),
//                                       onPressed: () async {
//                                         final confirm = await showDialog<bool>(
//                                           context: context,
//                                           builder: (context) => AlertDialog(
//                                             title: const Text('Delete Item'),
//                                             content: const Text(
//                                                 'Are you sure you want to delete this item?'),
//                                             actions: [
//                                               TextButton(
//                                                 onPressed: () => Navigator.pop(
//                                                     context, false),
//                                                 child: const Text('Cancel'),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () => Navigator.pop(
//                                                     context, true),
//                                                 child: const Text('Delete'),
//                                               ),
//                                             ],
//                                           ),
//                                         );

//                                         if (confirm == true) {
//                                           await _deleteItem(
//                                               context, documentId);
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AyurvedaListScreen extends StatefulWidget {
  const AyurvedaListScreen({super.key});

  @override
  State<AyurvedaListScreen> createState() => _AyurvedaListScreenState();
}

class _AyurvedaListScreenState extends State<AyurvedaListScreen> {
  List<DocumentSnapshot> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Ayurveda')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        _items = querySnapshot.docs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Ayurveda')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully.')),
      );

      setState(() {
        _items.removeWhere((item) => item.id == documentId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item: $e')),
      );
    }
  }

  Future<void> _editItem(
    BuildContext context,
    String documentId,
    String currentName,
    String currentImage,
    String currentDescription,
  ) async {
    final nameController = TextEditingController(text: currentName);
    final descriptionController = TextEditingController(text: currentDescription);
    File? selectedImage;
    String updatedImageUrl = currentImage;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      selectedImage = File(pickedFile.path);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image selected!')),
                      );
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Select Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        // If a new image is selected, update the image URL (Assume upload to Firebase Storage here).
        if (selectedImage != null) {
          // TODO: Upload the image to Firebase Storage and get the URL.
          updatedImageUrl = 'https://example.com/updated-image-url'; // Replace with actual URL.
        }

        // Update Firestore with the new details.
        await FirebaseFirestore.instance.collection('Ayurveda').doc(documentId).update({
          'name': nameController.text,
          'description': descriptionController.text,
          'image': updatedImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item updated successfully.')),
        );

        _fetchItems(); // Refresh the list to show the updated data.
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating item: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(width: 22),
                    Text(
                      'Ayurveda Items',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                _isLoading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _items.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text(
                                'No items found.',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                final itemName = item['name'] as String;
                                final imageUrl = item['image'] as String;
                                final description =
                                    item['description'] as String? ?? '';
                                final documentId = item.id;

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  elevation: 5,
                                  child: ListTile(
                                    leading: imageUrl.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(imageUrl),
                                          )
                                        : const CircleAvatar(
                                            child: Icon(Icons.image),
                                          ),
                                    title: Text(
                                      itemName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      description.isNotEmpty
                                          ? description
                                          : 'No description available.',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined,
                                              color: Colors.black),
                                          onPressed: () => _editItem(
                                            context,
                                            documentId,
                                            itemName,
                                            imageUrl,
                                            description,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.black),
                                          onPressed: () async {
                                            final confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                title: const Text('Delete Item'),
                                                content: const Text(
                                                    'Are you sure you want to delete this item?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child:
                                                        const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              await _deleteItem(
                                                  context, documentId);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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

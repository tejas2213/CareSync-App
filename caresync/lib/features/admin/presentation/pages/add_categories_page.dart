import 'package:caresync/features/admin/presentation/pages/admin_products_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCategoriesScreen extends StatefulWidget {
  final String storeId;
  final String storeName;

  const AddCategoriesScreen({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  @override
  _ManageCategoriesScreenState createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<AddCategoriesScreen> {
  final List<String> categoryNames = [
    "Cough & Cold",
    "Orthopaedics",
    "Pain Relief",
    "Skin Care",
    "Ayurvedic",
    "Vitamins",
    "Baby Care",
    "Fitness",
    "First Aid",
    "General Discomfort",
  ];

  Set<String> selectedCategories = {};
  Map<String, String?> selectedCategoryImages = {};

  bool _isSaving = false;

  void _navigateToManageProducts(BuildContext context, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          //category: categoryName,
          storeId: widget.storeId, categoryName: categoryName,
        ),
      ),
    );
  }

  Future<void> _saveSelectedCategories() async {
    setState(() {
      _isSaving = true;
    });
    final CollectionReference storeCategories = FirebaseFirestore.instance
        .collection('Medical Stores')
        .doc(widget.storeId)
        .collection('categories');

    try {
      for (var categoryName in selectedCategories) {
        String imageUrl = '';

        if (selectedCategoryImages[categoryName] != null) {
          try {
            String filePath = selectedCategoryImages[categoryName]!;
            String fileName =
                'CareSync/medical_stores/categories/${widget.storeId}/$categoryName/${DateTime.now().millisecondsSinceEpoch}.jpg';

            final UploadTask uploadTask =
                FirebaseStorage.instance.ref(fileName).putFile(File(filePath));

            final TaskSnapshot snapshot = await uploadTask;
            imageUrl = await snapshot.ref.getDownloadURL();
          } catch (e) {
            print('Error uploading image for $categoryName: $e');
          }
        }

        await storeCategories.doc(categoryName).set({
          'name': categoryName,
          'image_url': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selected categories saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving categories: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _pickImage(String categoryName) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedCategoryImages[categoryName] = image.path;
      });
    }
  }

  Future<void> _openAddCategoryDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await _pickImage(name);
                  setState(() {
                    categoryNames.add(name);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name added successfully!')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category name is required!')),
                  );
                }
              },
              child: const Text('Add'),
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
                      'Categories',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.09),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: categoryNames.length,
                    itemBuilder: (context, index) {
                      final category = categoryNames[index];
                      return ListTile(
                        leading: GestureDetector(
                          onTap: () => _pickImage(category),
                          child: Container(
                            color: Colors.white,
                            width: 50,
                            height: 50,
                            child: selectedCategoryImages[category] != null
                                ? Image.file(
                                    File(selectedCategoryImages[category]!),
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.add_a_photo, size: 30),
                          ),
                        ),
                        title: Text(category),
                        trailing: Checkbox(
                          value: selectedCategories.contains(category),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                selectedCategories.add(category);
                              } else {
                                selectedCategories.remove(category);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          _navigateToManageProducts(context, category);
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 5),
                  child: ElevatedButton.icon(
                    
                    onPressed: _isSaving
                        ? null
                        : () async {
                            if (selectedCategories.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please select categories first!')),
                              );
                            } else {
                              await _saveSelectedCategories();
                            }
                          },

                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Save Selected Categories',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10, 16, 40),
                  child: ElevatedButton.icon(
                    onPressed: () => _openAddCategoryDialog(context),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add More Categories',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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

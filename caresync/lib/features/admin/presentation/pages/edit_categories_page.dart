import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class EditStoreScreen extends StatefulWidget {
  final String storeId;
  final String storeName;

  const EditStoreScreen(
      {required this.storeId, required this.storeName, super.key});

  @override
  _EditStoreScreenState createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStoreDetails();
  }

  // Load store details
  Future<void> _loadStoreDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Medical Stores')
          .doc(widget.storeId)
          .get();

      if (snapshot.exists) {
        _nameController.text = snapshot['name'] ?? '';
        _addressController.text = snapshot['address'] ?? '';
        _phoneController.text = snapshot['phone'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load store details: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save updated store details
  Future<void> _saveStoreDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Medical Stores')
          .doc(widget.storeId)
          .update({
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store details updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update store details: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Edit a category or product
  Future<void> _editItem({
    required String id,
    required String name,
    required String collection,
    required String subCollection,
    required String itemType,
  }) async {
    final controller = TextEditingController(text: name);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $itemType'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Enter new $itemType name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (subCollection.isEmpty) {
                  // Update category
                  await FirebaseFirestore.instance
                      .collection('Medical Stores')
                      .doc(widget.storeId)
                      .collection(collection)
                      .doc(id)
                      .update({'name': controller.text.trim()});
                } else {
                  // Update product
                  await FirebaseFirestore.instance
                      .collection('Medical Stores')
                      .doc(widget.storeId)
                      .collection(collection)
                      .doc(subCollection)
                      .collection('products')
                      .doc(id)
                      .update({'name': controller.text.trim()});
                }
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$itemType updated successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update $itemType: $e')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Delete a category or product
  Future<void> _deleteItem({
    required String id,
    required String collection,
    required String subCollection,
    required String itemType,
  }) async {
    try {
      if (subCollection.isEmpty) {
        // Delete category
        await FirebaseFirestore.instance
            .collection('Medical Stores')
            .doc(widget.storeId)
            .collection(collection)
            .doc(id)
            .delete();
      } else {
        // Delete product
        await FirebaseFirestore.instance
            .collection('Medical Stores')
            .doc(widget.storeId)
            .collection(collection)
            .doc(subCollection)
            .collection('products')
            .doc(id)
            .delete();
      }
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$itemType deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete $itemType: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Edit Store - ${widget.storeName}'),
      //   backgroundColor: Colors.teal,
      // ),
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
                      'Edit Store',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.09),
                  ],
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Store Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the store name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _addressController,
                          decoration:
                              const InputDecoration(labelText: 'Address'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the address';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _saveStoreDetails,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                              foregroundColor: Colors.white, 
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10), 
                            ),
                            child: const Text('Save'),
                          ),
                        ),
                        //const SizedBox(height: 2),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Medical Stores')
                                .doc(widget.storeId)
                                .collection('categories')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text('No categories found.'));
                              }

                              final categories = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  final categoryId = category.id;

                                  return ExpansionTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(category['name']),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  ),
                                              onPressed: () => _editItem(
                                                id: categoryId,
                                                name: category['name'],
                                                collection: 'categories',
                                                subCollection: '',
                                                itemType: 'Category',
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  ),
                                              onPressed: () => _deleteItem(
                                                id: categoryId,
                                                collection: 'categories',
                                                subCollection: '',
                                                itemType: 'Category',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Medical Stores')
                                            .doc(widget.storeId)
                                            .collection('categories')
                                            .doc(categoryId)
                                            .collection('products')
                                            .snapshots(),
                                        builder: (context, productSnapshot) {
                                          if (productSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          if (!productSnapshot.hasData ||
                                              productSnapshot
                                                  .data!.docs.isEmpty) {
                                            return const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('No products found.'),
                                            );
                                          }

                                          final products =
                                              productSnapshot.data!.docs;

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: products.length,
                                            itemBuilder: (context, index) {
                                              final product = products[index];

                                              return ListTile(
                                                title: Text(product['name']),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.edit,
                                                          ),
                                                      onPressed: () =>
                                                          _editItem(
                                                        id: product.id,
                                                        name: product['name'],
                                                        collection:
                                                            'categories',
                                                        subCollection:
                                                            categoryId,
                                                        itemType: 'Product',
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete,
                                                         ),
                                                      onPressed: () =>
                                                          _deleteItem(
                                                        id: product.id,
                                                        collection:
                                                            'categories',
                                                        subCollection:
                                                            categoryId,
                                                        itemType: 'Product',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
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
        ],
      ),
    );
  }
}

// import 'package:caresync/features/admin/presentation/pages/edit_categories_page.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:caresync/features/admin/presentation/pages/add_categories_page.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MedicalStoresListScreen extends StatefulWidget {
//   const MedicalStoresListScreen({super.key});

//   @override
//   _MedicalStoresListScreenState createState() =>
//       _MedicalStoresListScreenState();
// }

// class _MedicalStoresListScreenState extends State<MedicalStoresListScreen> {
//   final CollectionReference _medicalStoresRef =
//       FirebaseFirestore.instance.collection('Medical Stores');
//   List<QueryDocumentSnapshot> _medicalStores = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadMedicalStores();
//   }

//   // Function to load medical stores from Firestore
//   Future<void> _loadMedicalStores() async {
//     try {
//       QuerySnapshot snapshot =
//           await _medicalStoresRef.orderBy('timestamp', descending: true).get();
//       setState(() {
//         _medicalStores = snapshot.docs;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load stores: $e')),
//       );
//     }
//   }

//   // Function to delete a medical store
//   Future<void> _deleteStore(String storeId) async {
//     try {
//       await _medicalStoresRef.doc(storeId).delete();
//       setState(() {
//         _medicalStores.removeWhere((store) => store.id == storeId);
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Store deleted successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete store: $e')),
//       );
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
//                           Icons.arrow_back_ios_new_rounded,
//                           size: 30,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'Medical Stores List',
//                       style: GoogleFonts.poppins(
//                         fontSize: screenWidth * 0.06,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(width: screenWidth * 0.09),
//                   ],
//                 ),
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : _medicalStores.isEmpty
//                         ? const Center(
//                             child: Text('No Medical Stores Found'),
//                           )
//                         : Expanded(
//                             child: ListView.builder(
//                               itemCount: _medicalStores.length,
//                               itemBuilder: (context, index) {
//                                 final store = _medicalStores[index];

//                                 return Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black87.withOpacity(0.6),
//                                         offset: const Offset(0, 4),
//                                         blurRadius: 6.0,
//                                         spreadRadius: 0.1,
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   margin: const EdgeInsets.all(8),
//                                   child: ListTile(
//                                     leading: CircleAvatar(
//                                       backgroundImage: store['image_url'] != ''
//                                           ? NetworkImage(store['image_url'])
//                                           : null,
//                                       child: store['image_url'] == ''
//                                           ? const Icon(Icons.store,
//                                               color: Colors.white)
//                                           : null,
//                                     ),
//                                     title: Text(store['name']),
//                                     subtitle: Text(store['address']),
//                                     trailing: IconButton(
//                                       icon: const Icon(Icons.delete,
//                                           color: Colors.red),
//                                       onPressed: () {
//                                         // Show a confirmation dialog before deleting
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) => AlertDialog(
//                                             title: const Text('Delete Store'),
//                                             content: const Text(
//                                                 'Are you sure you want to delete this store?'),
//                                             actions: [
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: const Text('Cancel'),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                   _deleteStore(store.id);
//                                                 },
//                                                 child: const Text(
//                                                   'Delete',
//                                                   style: TextStyle(
//                                                       color: Colors.red),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ManageCategoriesScreenn(
//                                             storeId: store.id,
//                                             storeName: store['name'],
//                                           ),
//                                         ),
//                                       );
//                                     },
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
import 'package:caresync/features/admin/presentation/pages/edit_categories_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


class MedicalStoresListScreen extends StatefulWidget {
  const MedicalStoresListScreen({super.key});

  @override
  _MedicalStoresListScreenState createState() =>
      _MedicalStoresListScreenState();
}

class _MedicalStoresListScreenState extends State<MedicalStoresListScreen> {
  final CollectionReference _medicalStoresRef =
      FirebaseFirestore.instance.collection('Medical Stores');
  List<QueryDocumentSnapshot> _medicalStores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicalStores();
  }

  // Function to load medical stores from Firestore
  Future<void> _loadMedicalStores() async {
    try {
      QuerySnapshot snapshot =
          await _medicalStoresRef.orderBy('timestamp', descending: true).get();
      setState(() {
        _medicalStores = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load stores: $e')),
      );
    }
  }

  // Function to delete a medical store
  Future<void> _deleteStore(String storeId) async {
    try {
      await _medicalStoresRef.doc(storeId).delete();
      setState(() {
        _medicalStores.removeWhere((store) => store.id == storeId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete store: $e')),
      );
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
                      'Medical Stores List',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.09),
                  ],
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _medicalStores.isEmpty
                        ? const Center(
                            child: Text('No Medical Stores Found'),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _medicalStores.length,
                              itemBuilder: (context, index) {
                                final store = _medicalStores[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black87.withOpacity(0.6),
                                        offset: const Offset(0, 4),
                                        blurRadius: 6.0,
                                        spreadRadius: 0.1,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: store['image_url'] != ''
                                          ? NetworkImage(store['image_url'])
                                          : null,
                                      child: store['image_url'] == ''
                                          ? const Icon(Icons.store,
                                              color: Colors.white)
                                          : null,
                                    ),
                                    title: Text(store['name']),
                                    subtitle: Text(store['address']),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              ),
                                          onPressed: () {
                                            // Navigate to edit store screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditStoreScreen(
                                                  storeId: store.id,
                                                  storeName: store['name'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              ),
                                          onPressed: () {
                                            // Show a confirmation dialog before deleting
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                title:
                                                    const Text('Delete Store'),
                                                content: const Text(
                                                    'Are you sure you want to delete this store?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _deleteStore(store.id);
                                                    },
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    // onTap: () {
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           ManageCategoriesScreenn(
                                    //         storeId: store.id,
                                    //         storeName: store['name'],
                                    //       ),
                                    //     ),
                                    //   );
                                    // },
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

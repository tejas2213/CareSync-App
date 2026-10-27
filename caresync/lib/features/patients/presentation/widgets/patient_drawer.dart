// import 'package:caresync/features/appointments/presentation/pages/my_appointments_page.dart';
// import 'package:caresync/features/blood_donation/presentation/pages/my_blood_page.dart';
// import 'package:caresync/features/onboarding/presentation/pages/landing_page.dart';
// import 'package:caresync/features/medical_records/presentation/pages/medical_record_upload_page.dart';
// import 'package:caresync/features/ambulance/presentation/pages/my_ambulance_bookings_page.dart';
// import 'package:caresync/features/pharmacy/presentation/pages/cart_page.dart';
// import 'package:caresync/features/pharmacy/presentation/pages/orders_page.dart';
// import 'package:caresync/features/patients/presentation/pages/patient_profile_page.dart';
// import 'package:caresync/features/pharmacy/presentation/pages/wishlist_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AppDrawer extends StatefulWidget {
//   const AppDrawer({
//     super.key,
//   });

//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer>
//     with SingleTickerProviderStateMixin {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   String patientId = '';
//   String storeId = '';
//   int selectedIndex = -1;
//   late AnimationController _controller;
//   String _patientName = '';

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..forward();
//     _loadPatientData();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // Future<void> _loadPatientData() async {
//   //   try {
//   //     User? user = _auth.currentUser;
//   //     if (user != null) {
//   //       // Store patientId
//   //       patientId = user.uid;

//   //       // Fetch patient data from Firestore
//   //       DocumentSnapshot snapshot = await _firestore
//   //           .collection('CareSync')
//   //           .doc('patients')
//   //           .collection('accounts')
//   //           .doc(patientId)
//   //           .get();

//   //       if (snapshot.exists) {
//   //         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//   //         setState(() {
//   //           _patientName = data['name'];
//   //           storeId = data['storeId'] ?? ''; // Ensure 'storeId' exists in Firestore
//   //         });
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching patient data: $e');
//   //   }
//   // }
//   Future<void> _loadPatientData() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         // Store patientId
//         patientId = user.uid;

//         // Fetch patient data from Firestore
//         DocumentSnapshot snapshot = await _firestore
//             .collection('CareSync')
//             .doc('patients')
//             .collection('accounts')
//             .doc(patientId)
//             .get();

//         if (snapshot.exists) {
//           Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//           setState(() {
//             _patientName = data['name'];
//             storeId = data['storeId'] ?? '';
//             _profilePicUrl = data['profileImage'] ?? '';
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching patient data: $e');
//     }
//   }

//   String _profilePicUrl = '';

//   void _onItemTapped(int index, BuildContext context, Widget page) {
//     setState(() {
//       selectedIndex = index;
//     });
//     Navigator.push(context, MaterialPageRoute(builder: (context) => page));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return Container(
//             //color: const Color(0xFFE0F7FA),
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0.0, 0.3, 0.7, 1.0],
//                 colors: [
//                   Color.fromRGBO(97, 206, 255, 1),
//                   Colors.white,
//                   Colors.white,
//                   Color.fromRGBO(14, 190, 126, 1),
//                 ],
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16.0, 70, 16, 0),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     const PatientProfilePage()),
//                           );
//                         },
//                         child: CircleAvatar(
//                           radius: 30,
//                           backgroundColor: Colors.grey[400],
//                           backgroundImage: _profilePicUrl.isNotEmpty
//                               ? NetworkImage(
//                                   _profilePicUrl)
//                               : null,
//                           child: _profilePicUrl.isEmpty
//                               ? const Icon(Icons.person,
//                                   size: 40,
//                                   color:
//                                       Colors.grey)
//                               : null,
//                         ),
//                       ),

//                       const SizedBox(width: 10),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(_patientName,
//                               style: GoogleFonts.lato(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 _buildDrawerItem(Icons.calendar_today, 'My Appointments',
//                     context, const MyAppointments(), 0),
//                 _buildDrawerItem(
//                     Icons.list,
//                     'My Orders',
//                     context,
//                     OrdersPage(
//                       patientId: patientId,
//                     ),
//                     1),
//                 _buildDrawerItem(
//                     Icons.shopping_cart,
//                     'My Cart',
//                     context,
//                     Cart(
//                       patientId: patientId,
//                       storeId: storeId,
//                       onProductChanged: () {},
//                     ),
//                     2),
//                 _buildDrawerItem(
//                     Icons.favorite,
//                     'Wishlist',
//                     context,
//                     Wishlist(
//                       patientId: patientId,
//                       onProductChanged: () {},
//                     ),
//                     3),
//                 _buildDrawerItem(Icons.medical_services, 'Medical Records',
//                     context, const RecordScreen1(), 4),
//                 _buildDrawerItem(Icons.collections_bookmark, 'My Bookings',
//                     context, const MyAmbulanceBookingsScreen(), 5),
//                 _buildDrawerItem(Icons.water_drop_rounded,
//                     'My Blood Requirements', context, const MyBloodReq(), 6),
//                 //const Divider(),
//                 // ListTile(
//                 //   leading: AnimatedContainer(
//                 //     duration: const Duration(milliseconds: 500),
//                 //     decoration: BoxDecoration(
//                 //       shape: BoxShape.circle,
//                 //       color: widget.isDarkMode
//                 //           ? Colors.grey[800]
//                 //           : Colors.yellow[700],
//                 //     ),
//                 //     padding: const EdgeInsets.all(8),
//                 //     child: Icon(
//                 //         widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
//                 //         color: widget.isDarkMode ? Colors.amber : Colors.blue),
//                 //   ),
//                 //   title:
//                 //       Text('Dark Mode', style: GoogleFonts.lato(fontSize: 16)),
//                 //   trailing: Switch(
//                 //     value: widget.isDarkMode,
//                 //     onChanged: (_) => widget.toggleTheme(),
//                 //   ),
//                 // ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.logout),
//                   title: Text('Logout', style: GoogleFonts.lato(fontSize: 16)),
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text(
//                             'Log Out',
//                             style: GoogleFonts.lato(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           content: Text(
//                             'Are you sure you want to logout?',
//                             style: GoogleFonts.lato(fontSize: 16),
//                           ),
//                           actions: <Widget>[
//                             TextButton(
//                               child: const Text(
//                                 'Cancel',
//                                 style: TextStyle(color: Colors.green),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                             TextButton(
//                               onPressed: () async {
//                                 Navigator.of(context).pop();
//                                 SharedPreferences prefs =
//                                     await SharedPreferences.getInstance();
//                                 //await prefs.clear(); // Clear all saved data
//                                 await prefs.setBool('isLoggedIn', false);
//                                 Navigator.of(context).pushReplacement(
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const LandingPage()));
//                               },
//                               child: const Text(
//                                 'Ok',
//                                 style: TextStyle(color: Colors.green),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDrawerItem(IconData icon, String title, BuildContext context,
//       Widget page, int index) {
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: selectedIndex == index
//             ? const Color.fromRGBO(14, 190, 127, 1)
//             : Colors.black,
//       ),
//       title: Text(
//         title,
//         style: GoogleFonts.lato(
//           fontSize: 16,
//           color: selectedIndex == index
//               ? const Color.fromRGBO(14, 190, 127, 1)
//               : Colors.black,
//         ),
//       ),
//       onTap: () => _onItemTapped(index, context, page),
//     );
//   }
// }



import 'package:caresync/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:caresync/features/blood_donation/presentation/pages/my_blood_page.dart';
import 'package:caresync/features/onboarding/presentation/pages/landing_page.dart';
import 'package:caresync/features/medical_records/presentation/pages/medical_record_upload_page.dart';
import 'package:caresync/features/ambulance/presentation/pages/my_ambulance_bookings_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/cart_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/orders_page.dart';
import 'package:caresync/features/patients/presentation/pages/patient_profile_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/wishlist_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
  });

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String patientId = '';
  String storeId = '';
  int selectedIndex = -1;
  late AnimationController _controller;
  String _patientName = '';
  String _profilePicUrl = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    _loadPatientData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPatientData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        patientId = user.uid;
      }
    } catch (e) {
      print('Error fetching patient data: $e');
    }
  }

  void _onItemTapped(int index, BuildContext context, Widget page) {
    setState(() {
      selectedIndex = index;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('CareSync')
                      .doc('patients')
                      .collection('accounts')
                      .doc(patientId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: Text('No data available'));
                    }

                    var data = snapshot.data?.data() as Map<String, dynamic>;
                    _patientName = data['name'] ?? 'Unknown';
                    _profilePicUrl = data['profileImage'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 70, 16, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PatientProfilePage()),
                              );
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[400],
                              backgroundImage: _profilePicUrl.isNotEmpty
                                  ? NetworkImage(_profilePicUrl)
                                  : null,
                              child: _profilePicUrl.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _patientName,
                                style: GoogleFonts.lato(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(Icons.calendar_today, 'My Appointments',
                    context, const MyAppointments(), 0),
                _buildDrawerItem(
                    Icons.list,
                    'My Orders',
                    context,
                    OrdersPage(
                      patientId: patientId,
                    ),
                    1),
                _buildDrawerItem(
                    Icons.shopping_cart,
                    'My Cart',
                    context,
                    Cart(
                      patientId: patientId,
                      storeId: storeId,
                      onProductChanged: () {},
                    ),
                    2),
                _buildDrawerItem(
                    Icons.favorite,
                    'Wishlist',
                    context,
                    Wishlist(
                      patientId: patientId,
                      onProductChanged: () {},
                    ),
                    3),
                _buildDrawerItem(Icons.medical_services, 'Medical Records',
                    context, const RecordScreen1(), 4),
                _buildDrawerItem(Icons.collections_bookmark, 'My Bookings',
                    context, const MyAmbulanceBookingsScreen(), 5),
                _buildDrawerItem(Icons.water_drop_rounded,
                    'My Blood Requirements', context, const MyBloodReq(), 6),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text('Logout', style: GoogleFonts.lato(fontSize: 16)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Log Out',
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Are you sure you want to logout?',
                            style: GoogleFonts.lato(fontSize: 16),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('isLoggedIn', false);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LandingPage()));
                              },
                              child: const Text(
                                'Ok',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context,
      Widget page, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: selectedIndex == index
            ? const Color.fromRGBO(14, 190, 127, 1)
            : Colors.black,
      ),
      title: Text(
        title,
        style: GoogleFonts.lato(
          fontSize: 16,
          color: selectedIndex == index
              ? const Color.fromRGBO(14, 190, 127, 1)
              : Colors.black,
        ),
      ),
      onTap: () => _onItemTapped(index, context, page),
    );
  }
}

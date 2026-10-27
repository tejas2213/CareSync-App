import 'package:caresync/features/onboarding/presentation/pages/landing_page.dart';
import 'package:caresync/features/admin/presentation/pages/add_ambulance_page.dart';
import 'package:caresync/features/admin/presentation/pages/add_ayurveda_page.dart';
import 'package:caresync/features/admin/presentation/pages/add_store_page.dart';
import 'package:caresync/features/admin/presentation/pages/admin_ambulances_list_page.dart';
import 'package:caresync/features/admin/presentation/pages/admin_ayurveda_list_page.dart';
import 'package:caresync/features/admin/presentation/pages/admin_store_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isDrawerOpen = false;

  String _adminName = '';

  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Fetch patient data from Firestore
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('CareSync').doc('admin').get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          setState(() {
            _adminName = data['name'] ?? 'Admin';
          });
        }
      }
    } catch (e) {
      print('Error fetching admin data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
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

          SingleChildScrollView(
            child: Column(
              children: [
                // Custom AppBar
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isDrawerOpen = !isDrawerOpen;
                          });
                        },
                        child: const Icon(Icons.menu,
                            size: 30, color: Colors.black),
                      ),
                      const Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
            
                Column(
                  //mainAxisAlignment: MainAxisAlignment.s,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MedicalStoresListScreen()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(20),
                        height: 120,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.teal[200],
                          gradient: LinearGradient(
                            colors: [Colors.teal[300]!, Colors.teal[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.local_hospital,
                                size: 40, color: Colors.white),
                            Text(
                              "Medical Stores",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AmbulancesList()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(20),
                        height: 120,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.teal[200],
                          gradient: LinearGradient(
                            colors: [Colors.teal[300]!, Colors.teal[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.local_shipping,
                                size: 40, color: Colors.white),
                            Text(
                              "Ambulances",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AyurvedaListScreen()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(20),
                        height: 120,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.teal[200],
                          gradient: LinearGradient(
                            colors: [Colors.teal[300]!, Colors.teal[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.spa, size: 40, color: Colors.white),
                            Text(
                              "Ayurveda",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (isDrawerOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  isDrawerOpen = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),

          // Custom Drawer Content
          if (isDrawerOpen)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 250,
                color: const Color.fromRGBO(14, 190, 126, 220),
                child: Column(
                  children: [
                    const DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.admin_panel_settings,
                              size: 60, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            "CareSync",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddStoreScreen()),
                        );
                        setState(() => isDrawerOpen = false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.local_hospital, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Add Medical Store",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddAmbulancePage()),
                        );
                        setState(() => isDrawerOpen = false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.local_shipping, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Add Ambulance",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddItemScreen()),
                        );
                        setState(() => isDrawerOpen = false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.spa, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Add Ayurveda",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     SharedPreferences prefs =
                    //       await SharedPreferences.getInstance();
                    //       await prefs.clear();

                    //     Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const LandingPage()),
                    //       (route) => false,
                    //     );
                    //     setState(() => isDrawerOpen = false);
                    //   },
                    //   child: const Padding(
                    //     padding: EdgeInsets.symmetric(
                    //         vertical: 10.0, horizontal: 16.0),
                    //     child: Row(
                    //       children: [
                    //         Icon(Icons.logout, color: Colors.white),
                    //         SizedBox(width: 10),
                    //         Text(
                    //           "Logout",
                    //           style:
                    //               TextStyle(color: Colors.white, fontSize: 18),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    GestureDetector(
                      onTap: () async {
                        // Show confirmation dialog
                        bool? confirmLogout = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm Logout"),
                              content: const Text(
                                  "Are you sure you want to logout?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false); // Cancel
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true); // Confirm
                                  },
                                  child: const Text("Logout"),
                                ),
                              ],
                            );
                          },
                        );

                        // If user confirms logout
                        if (confirmLogout == true) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs
                              .clear(); // Clear shared preferences (log out)

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LandingPage()),
                            (route) =>
                                false, // Remove all routes to ensure the user cannot go back
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Logout",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
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

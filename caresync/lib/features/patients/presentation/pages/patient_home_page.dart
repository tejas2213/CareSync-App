import 'package:caresync/features/ayurveda/presentation/pages/ayurveda_page.dart';
import 'package:caresync/features/blood_donation/presentation/pages/blood_card_page.dart';
import 'package:caresync/features/blood_donation/presentation/pages/fill_blood_form_page.dart';
import 'package:caresync/features/doctor_speciality/presentation/pages/specialisation_page.dart';
import 'package:caresync/features/ambulance/presentation/pages/ambulance_home_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/cart_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/medical_store_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/orders_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/wishlist_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caresync/features/chat/presentation/pages/messages_page.dart';
import 'package:caresync/features/patients/presentation/widgets/patient_drawer.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String patientId = '';
  String storeId = '';
  int _selectedIndex = 0;
  bool isDarkMode = false;
  String _patientName = '';
  late AnimationController _controller;

  final List<Widget> _gridPages = [
    const DoctorCategories(),
    const MedicalStore(),
    const AyurvedaGridScreen(),
    const AmbulanceBookingHome(),
  ];

  final List<String> imageList = [
    "assets/jpg/HomeScreen/Doctors.jpg",
    "assets/jpg/HomeScreen/Pharmacy.jpg",
    "assets/jpg/HomeScreen/Ayurveda.jpg",
    "assets/jpg/HomeScreen/Ambulance.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _loadPatientData();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
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

        DocumentSnapshot snapshot = await _firestore
            .collection('CareSync')
            .doc('patients')
            .collection('accounts')
            .doc(patientId)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          setState(() {
            _patientName = data['name'];
            storeId = data['storeId'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching patient data: $e');
    }
  }

  ThemeData _getTheme() {
    return isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: const Color.fromRGBO(14, 190, 127, 1),
            scaffoldBackgroundColor: Colors.grey[900],
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _getBottomNavPage(index),
        ),
      );
    }
  }

  Widget _getBottomNavPage(int index) {
    switch (index) {
      case 1:
        return Wishlist(
          patientId: patientId,
          onProductChanged: () {},
        );
      case 2:
        return Cart(
          patientId: patientId,
          storeId: storeId,
          onProductChanged: () {},
        );
      case 3:
        return OrdersPage(patientId: patientId);
      default:
        return const PatientHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: const AppDrawer(
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
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
              );
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, height * 0.06, 0, 0),
            child: Column(
              children: [
                _buildAppBar(width),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildWelcomeSection(width, height),
                        Container(
                          decoration: const BoxDecoration(
                            //color: Colors.white10.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                          //height: height * 0.529,
                          child: GridView.builder(
                            shrinkWrap: true,
                            //physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 30,
                            ),
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => _gridPages[index],
                                    ),
                                  );
                                },
                                child: _buildGridItem(index, imageList[index]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Bloodgroup()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  offset: const Offset(0, 2),
                                  blurRadius: 6.0,
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                              border: Border.all(
                                color: Colors.white10,
                                width: 2.0,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                              child: Container(
                                height: 160,
                                width: 180,
                                decoration: BoxDecoration(
                                  color: Colors.white10.withOpacity(0.3),
                                ),
                                child: Image.asset(
                                  "assets/jpg/HomeScreen/Blood Finder.jpg",
                                  fit: BoxFit.cover,
                                ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MedicalStore()),
          );
        },
        tooltip: 'Pharmacy',
        child: const Icon(Icons.local_pharmacy_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              index: 0,
            ),
            _buildBottomNavItem(
              icon: Icons.favorite_border,
              label: 'Wishlist',
              index: 1,
            ),
            const SizedBox(width: 40),
            _buildBottomNavItem(
              icon: Icons.shopping_cart_outlined,
              label: 'Cart',
              index: 2,
            ),
            _buildBottomNavItem(
              icon: Icons.list,
              label: 'Orders',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
      {required IconData icon, required String label, required int index}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index
                ? const Color.fromRGBO(14, 190, 127, 1)
                : Colors.black87,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index
                  ? const Color.fromRGBO(14, 190, 127, 1)
                  : Colors.black87,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 32,
                color: Colors.black87,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        const SizedBox(
          width: 90,
        ),
        Text(
          'CareSync',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.water_drop_rounded,
            size: 36,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BloodDetails()),
            );
          },
        ),
        ///message
        IconButton(
          icon: const Icon(
            Icons.chat_outlined,
            size: 32,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DoctorListScreen(patientId: patientId,),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(double width, double height) {
    return Container(
      alignment: Alignment.center,
      width: width * 0.9,
      height: height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/gif/PatientHomeScreen.jpg',
              width: width * 0.9,
              height: height * 0.6,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, $_patientName!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ' How can we assist you today?',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(int index, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1.5,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

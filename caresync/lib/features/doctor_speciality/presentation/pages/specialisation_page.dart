import 'dart:developer';

import 'package:caresync/features/doctor_speciality/presentation/pages/doctors_list_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DoctorCategories extends StatefulWidget {
  const DoctorCategories({super.key});

  @override
  State<DoctorCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<DoctorCategories> {
  void navigateToCategory(BuildContext context, Widget categoryScreen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => categoryScreen,
      ),
    );
  }

  List<String> drSpecializations = [
    "Cardiology",
    "Dermatology",
    "General Medicine",
    "Gynecology",
    "Odontology",
    "Oncology",
    "Ophthalmology",
    "Orthopedics",
  ];

  List<Map<String, dynamic>> carouselImages = [
    {
      'image': "assets/json/4.json",
      'route': const DoctorListScreen(drSpeciality: "Cardiology",selectedIndex: 0)
    },
    {
      'image': "assets/json/2.json",
      'route': const DoctorListScreen(drSpeciality: "Dermatology",selectedIndex: 1)
    },
    {
      'image': "assets/json/3.json",
      'route': const DoctorListScreen(drSpeciality: "General Medicine",selectedIndex: 2)
    },
    {
      'image': "assets/json/4.json",
      'route': const DoctorListScreen(drSpeciality: "Gynecology",selectedIndex: 3)
    },
    {
      'image': "assets/json/5.json",
      'route': const DoctorListScreen(drSpeciality: "Odontology",selectedIndex: 4)
    },
    {
      'image': "assets/json/6.json",
      'route': const DoctorListScreen(drSpeciality: "Oncology",selectedIndex: 5)
    },
    {
      'image': "assets/json/7.json",
      'route': const DoctorListScreen(drSpeciality: "Ophthalmology",selectedIndex: 6)
    },
    {
      'image': "assets/json/8.json",
      'route': const DoctorListScreen(drSpeciality: "Orthopedics",selectedIndex: 7)
    },
  ];

  List<Map<String, dynamic>> drSpecialisation = [
    {
      'image':
          "assets/svg/specialisation/Cardiology Specialties Button # 4.svg",
      'route': const DoctorListScreen(drSpeciality: "Cardiology",selectedIndex: 0)
    },
    {
      'image':
          "assets/svg/specialisation/Dermatology Specialties Button # 3.svg",
      'route': const DoctorListScreen(drSpeciality: "Dermatology",selectedIndex: 1)
    },
    {
      'image': "assets/svg/specialisation/Specialties Button # 1 (1).svg",
      'route': const DoctorListScreen(drSpeciality: "General Medicine",selectedIndex: 2)
    },
    {
      'image':
          "assets/svg/specialisation/Gynecology Specialties Button # 10.svg",
      'route': const DoctorListScreen(drSpeciality: "Gynecology",selectedIndex: 3)
    },
    {
      'image':
          "assets/svg/specialisation/Odontology Specialties Button # 12.svg",
      'route': const DoctorListScreen(drSpeciality: "Odontology",selectedIndex: 4)
    },
    {
      'image': "assets/svg/specialisation/Oncology Specialties Button # 11.svg",
      'route': const DoctorListScreen(drSpeciality: "Oncology",selectedIndex: 5)
    },
    {
      'image':
          "assets/svg/specialisation/Ophtamology Specialties Button # 2.svg",
      'route': const DoctorListScreen(drSpeciality: "Ophthalmology",selectedIndex: 6)
    },
    {
      'image':
          "assets/svg/specialisation/Orthopedics Specialties Button # 13.svg",
      'route': const DoctorListScreen(drSpeciality: "Orthopedics",selectedIndex: 7)
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double carouselHeight = screenWidth * 0.4;
    int crossAxisCount = screenWidth < 600 ? 2 : 3;
    double categoryImageSize = screenWidth * 0.6;

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
                            color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
                    child: const Icon(
                      size: 30,
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Text(
                      'Doctor Categories',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.05),
                CarouselSlider(
                  options: CarouselOptions(
                    height: carouselHeight,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: carouselImages.map((imageData) {
                    log(imageData['image']);
                    return GestureDetector(
                      onTap: () {
                        // navigateToCategory(context, imageData['route']);
                      },
                      child: Container(
                        width: screenWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Lottie.asset(
                            imageData['image']
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: screenWidth * 0.07),
                const Text(
                  'Book By Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: drSpecialisation.length,
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: "loc-doctor-${drSpecialisation[index]['image']}",
                        child: GestureDetector(
                          onTap: () {
                            navigateToCategory(
                                context, drSpecialisation[index]['route']);
                          },
                          child: Container(
                            child: Center(
                              child: SvgPicture.asset(
                                drSpecialisation[index]['image'],
                                width: categoryImageSize,
                                height: categoryImageSize,
                              ),
                            ),
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

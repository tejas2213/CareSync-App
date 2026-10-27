import 'package:caresync/features/medical_records/presentation/pages/all_records_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecordScreen1 extends StatefulWidget {
  const RecordScreen1({super.key});

  @override
  State<RecordScreen1> createState() => _RecordScreen1State();
}

class _RecordScreen1State extends State<RecordScreen1> {
  @override
  Widget build(BuildContext context) {
    // Retrieve screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      ///MEDICAL RECORD SCREEN
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
            bottom: screenHeight * 0.00,
          ),
          child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ///ICON - BACK
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
                    ),),
                    ),
                    SizedBox(width: screenWidth * 0.14),

                    ///TEXT
                    Text(
                      "Medical Records",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                    height: 250,
                    width: 250,
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(143, 208, 185, 0.416),
                    ),
                    child: SvgPicture.asset("assets/svg/record.svg")),
                Text(
                  "Add a Medical Record.",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height:20),
                Text(
                  "A detailed health history helps a doctor diagnose you btter.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(103, 114, 148, 1),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const AllRecords()),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            width: 300,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(14, 190, 127, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Add a record",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),
              ]),
        ),
      ),
    );
  }
}

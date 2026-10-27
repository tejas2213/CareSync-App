// import 'package:animate_do/animate_do.dart';
// import 'package:caresync/features/authentication/presentation/pages/admin_sign_in_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:caresync/features/authentication/presentation/pages/doctor_sign_in_page.dart';
// import 'package:caresync/features/authentication/presentation/pages/patient_sign_in_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:math';

// class LandingPage extends StatefulWidget {
//   const LandingPage({super.key});

//   @override
//   State<LandingPage> createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _zoomAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize AnimationController
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     )..repeat();

//     // Zoom Animation for images below the logo
//     _zoomAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.4, 0.6, curve: Curves.easeInOut),
//       ),
//     );
//   }

//   Future<void> _saveUserType(String userType) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userType', userType); // Save user type
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
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
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.center, // Center the Stack's children
//               children: [
//                 // Circular lines behind images
//                 CustomPaint(
//                   size: Size(200, 200), // Size of the circular lines
//                   painter: CircularLinesPainter(),
//                 ),
//                 // Rotating outer images in circular avatars
//                 RotationTransition(
//                   turns: _controller,
//                   child: SizedBox(
//                     height: 250, // Increase the height of the container
//                     width: 250, // Increase the width of the container
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: List.generate(4, (index) {
//                         final angle =
//                             index * 90.0; // Spacing images 90 degrees apart
//                         return _buildRotatingImage(
//                           angle: angle,
//                           imagePath: "assets/png/doctor.png",
//                         );
//                       }),
//                     ),
//                   ),
//                 ),
//                 // Center Logo (Fixed in center)
//                 Image.asset(
//                   "assets/png/images/logo.png",
//                   height: 100,
//                   width: 100,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 40),
//             Text(
//               "Stay healthy with us...",
//               style: GoogleFonts.poppins(
//                 fontSize: 26,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               "You are a",
//               style: GoogleFonts.poppins(
//                 fontSize: 28,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 30),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildGradientButton(
//                   context: context,
//                   text: "Patient",
//                   onTap: () async {
//                     await _saveUserType('patient');
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                         builder: (context) => const PatientSignInPage()));
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 _buildGradientButton(
//                   context: context,
//                   text: "Doctor",
//                   onTap: () async {
//                     await _saveUserType('doctor');
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                         builder: (context) => const DoctorSignInPage()));
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 _buildGradientButton(
//                   context: context,
//                   text: "Admin",
//                   onTap: () async {
//                     await _saveUserType('admin');
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                         builder: (context) => const AdminSignInPage()));
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Method to build a rotating image in a circular avatar
//   // Widget _buildRotatingImage({required double angle, required String imagePath}) {
//   //   return AnimatedBuilder(
//   //     animation: _controller,
//   //     builder: (context, child) {
//   //       final double rotationAngle = (_controller.value * 360 + angle) % 360;
//   //       final isZoomed = (rotationAngle - 0).abs() < 15.0 ||
//   //           (rotationAngle - 360).abs() < 15.0; // Image below the logo

//   //       return Transform.translate(
//   //         offset: _calculatePosition(rotationAngle),
//   //         child: Transform.scale(
//   //           scale: isZoomed ? _zoomAnimation.value : 1.0,
//   //           child: child,
//   //         ),
//   //       );
//   //     },
//   //     child: Transform.rotate(
//   //       angle: angle * (3.14159 / 180),
//   //       child: CircleAvatar(
//   //         radius: 40,
//   //         backgroundImage: AssetImage(imagePath),
//   //         backgroundColor: Colors.transparent, // Transparent background for avatar
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Method to build a rotating image in a circular avatar
// // Widget _buildRotatingImage({required double angle, required String imagePath}) {
// //   return AnimatedBuilder(
// //     animation: _controller,
// //     builder: (context, child) {
// //       final double rotationAngle = (_controller.value * 360 + angle) % 360;
// //       final isZoomed = (rotationAngle - 0).abs() < 15.0 ||
// //           (rotationAngle - 360).abs() < 15.0; // Image below the logo

// //       return Transform.translate(
// //         offset: _calculatePosition(rotationAngle),
// //         child: Transform.scale(
// //           scale: isZoomed ? _zoomAnimation.value : 1.0,
// //           child: child,
// //         ),
// //       );
// //     },
// //     child: CircleAvatar(
// //       radius: 40,
// //       backgroundImage: AssetImage(imagePath),
// //       backgroundColor: Colors.transparent, // Transparent background for avatar
// //     ),
// //   );
// // }

// // Method to build a rotating image in a circular avatar
//   Widget _buildRotatingImage(
//       {required double angle, required String imagePath}) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final double rotationAngle = (_controller.value * 90 + angle) % 360;

//         return Transform.translate(
//           offset: _calculatePosition(rotationAngle),
//           child: child, // No rotation applied to the content
//         );
//       },
//       child: CircleAvatar(
//         radius: 40,
//         backgroundImage: AssetImage(imagePath),
//         backgroundColor:
//             Colors.transparent, // Transparent background for avatar
//       ),
//     );
//   }

//   // Calculate the position of each image in the circle (polar coordinates)
//   Offset _calculatePosition(double angle) {
//     final radius =
//         120.0; // Increased the radius to move images further from the center
//     final radians = angle * (pi / 180); // Convert angle to radians
//     final x = radius * cos(radians); // X position
//     final y = radius * sin(radians); // Y position
//     return Offset(x, y);
//   }

//   // // Gradient button for options
//   // Widget _buildGradientButton(
//   //     {required BuildContext context,
//   //     required String text,
//   //     required VoidCallback onTap}) {
//   //   return FadeInUp(
//   //     child: GestureDetector(
//   //       onTap: onTap,
//   //       child: Container(
//   //         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//   //         decoration: BoxDecoration(
//   //           gradient: const LinearGradient(
//   //             colors: [
//   //               Color.fromRGBO(14, 190, 126, 1),
//   //               Color.fromRGBO(97, 206, 255, 1),
//   //             ],
//   //             begin: Alignment.topLeft,
//   //             end: Alignment.bottomRight,
//   //           ),
//   //           borderRadius: BorderRadius.circular(30),
//   //           boxShadow: const [
//   //             BoxShadow(
//   //               color: Colors.black26,
//   //               offset: Offset(2, 4),
//   //               blurRadius: 6,
//   //             ),
//   //           ],
//   //         ),
//   //         child: Text(
//   //           text,
//   //           style: GoogleFonts.poppins(
//   //             fontSize: 22,
//   //             fontWeight: FontWeight.w500,
//   //             color: Colors.white,
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Gradient button for options with zoom-in effect
// Widget _buildGradientButton({
//   required BuildContext context,
//   required String text,
//   required VoidCallback onTap,
// }) {
//   return TweenAnimationBuilder(
//     tween: Tween<double>(begin: 0.8, end: 1.0), // Zoom-in effect
//     duration: const Duration(milliseconds: 500), // Animation duration
//     curve: Curves.easeOut,
//     builder: (context, scale, child) {
//       return Transform.scale(
//         scale: scale,
//         child: FadeInUp(
//           child: GestureDetector(
//             onTap: onTap,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [
//                     Color.fromRGBO(14, 190, 126, 1),
//                     Color.fromRGBO(97, 206, 255, 1),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     offset: Offset(2, 4),
//                     blurRadius: 6,
//                   ),
//                 ],
//               ),
//               child: Text(
//                 text,
//                 style: GoogleFonts.poppins(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// }

// // CustomPainter to draw circular lines behind rotating images (without the inner circle)
// class CircularLinesPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.grey.withOpacity(0.6) // Color of the circular lines
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 1.5;

//     // Draw outer circular lines
//     canvas.drawCircle(center, radius, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }


import 'package:animate_do/animate_do.dart';
import 'package:caresync/features/authentication/presentation/pages/admin_sign_in_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caresync/features/authentication/presentation/pages/doctor_sign_in_page.dart';
import 'package:caresync/features/authentication/presentation/pages/patient_sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  

  @override
  void initState() {
    super.initState();

  }

  Future<void> _saveUserType(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType); // Save user type
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Center(
              child: Lottie.asset("assets/json/landingPage.json")
            ),
            const SizedBox(height: 40),
            FadeInUp(
              child: Text(
                "Stay healthy with us...",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              child: Text(
                "You are a",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInUp(
                  child: _buildGradientButton(
                    context: context,
                    text: "Patient",
                    onTap: () async {
                      await _saveUserType('patient');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const PatientSignInPage()));
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  child: _buildGradientButton(
                    context: context,
                    text: "Doctor",
                    onTap: () async {
                      await _saveUserType('doctor');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const DoctorSignInPage()));
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FadeInUp(
                  child: _buildGradientButton(
                    context: context,
                    text: "Admin",
                    onTap: () async {
                      await _saveUserType('admin');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const AdminSignInPage()));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Gradient button for options with zoom-in effect
  Widget _buildGradientButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0), // Zoom-in effect
      duration: const Duration(milliseconds: 500), // Animation duration
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: FadeInUp(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromRGBO(14, 190, 126, 1),
                      Color.fromRGBO(97, 206, 255, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


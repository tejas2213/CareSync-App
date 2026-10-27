// import 'package:caresync/features/authentication/presentation/pages/admin_sign_in_page.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:caresync/features/onboarding/presentation/pages/landing_page.dart';
// import 'package:caresync/features/authentication/presentation/pages/patient_sign_in_page.dart';
// import 'package:caresync/features/authentication/presentation/pages/doctor_sign_in_page.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userType = prefs.getString('userType'); // Check stored user type

//     Future.delayed(const Duration(seconds: 5), () {
//       if (userType == 'patient') {
//         // Redirect to Patient Home Screen
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const PatientSignInPage()));
//       } else if (userType == 'doctor') {
//         // Redirect to Doctor Home Screen
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const DoctorSignInPage()));
//       } else if (userType == 'admin') {
//         // Redirect to Admin Home Screen
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const AdminSignInPage()));
//       } else {
//         // Redirect to Landing Page
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const LandingPage()));
//       }
//     });
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           stops: [0.0, 0.3, 0.7, 1.0],
//           colors: [
//             Color.fromRGBO(97, 206, 255, 220),
//             Colors.white,
//             Colors.white,
//             Color.fromRGBO(14, 190, 126, 220),
//           ],
//         )),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("assets/png/images/logo.png"),
//             Text(
//               "CareSync",
//               style: GoogleFonts.poppins(
//                 fontSize: 45,
//                 fontWeight: FontWeight.w400,
//                 color: const Color.fromRGBO(14, 190, 126, 1),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:avatar_glow/avatar_glow.dart'; // Import for AvatarGlow
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caresync/features/onboarding/presentation/pages/landing_page.dart';
import 'package:caresync/features/authentication/presentation/pages/patient_sign_in_page.dart';
import 'package:caresync/features/authentication/presentation/pages/doctor_sign_in_page.dart';
import 'package:caresync/features/authentication/presentation/pages/admin_sign_in_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _checkLoginStatus();

    // Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Repeats animation back and forth
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString('userType'); // Check stored user type

    Future.delayed(const Duration(seconds: 5), () {
      if (userType == 'patient') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const PatientSignInPage()));
      } else if (userType == 'doctor') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DoctorSignInPage()));
      } else if (userType == 'admin') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminSignInPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LandingPage()));
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
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
            AvatarGlow(
              endRadius: 120.0, // Size of the glow
              glowColor: const Color.fromRGBO(14, 190, 126, 1),
              duration: const Duration(milliseconds: 2000), // Glow animation speed
              repeat: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  // Zoom effect using scale
                  return Transform.scale(
                    scale: 1 + (_controller.value * 0.2), // Adjust zoom intensity
                    child: child,
                  );
                },
                child: Image.asset(
                  "assets/png/images/logo.png",
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Text(
              "CareSync",
              style: GoogleFonts.poppins(
                fontSize: 45,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(14, 190, 126, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

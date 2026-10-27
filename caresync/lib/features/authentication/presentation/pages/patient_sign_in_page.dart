import 'package:animate_do/animate_do.dart';
import 'package:caresync/features/onboarding/presentation/pages/landing_page.dart';
import 'package:caresync/features/authentication/presentation/pages/patient_sign_up_page.dart';
import 'package:caresync/features/patients/presentation/pages/patient_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientSignInPage extends StatefulWidget {
  const PatientSignInPage({super.key});

  @override
  State createState() => _PatientSignInPageState();
}

class _PatientSignInPageState extends State {
  final _patientformKey = GlobalKey<FormState>();
  final TextEditingController _phoneEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PatientHomeScreen()),
      );
    }
  }

  // Future<void> _signIn() async {
  //   if (_patientformKey.currentState!.validate()) {
  //     try {
  //       final email = _phoneEmailController.text.trim();
  //       final password = _passwordController.text.trim();

  //       final UserCredential userCredential =
  //           await _auth.signInWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );

  //       final User? user = userCredential.user;

  //       if (user != null) {
  //         final DocumentSnapshot snapshot = await _firestore
  //             .collection('CareSync')
  //             .doc('patients')
  //             .collection('accounts')
  //             .doc(user.uid)
  //             .get();

  //         if (snapshot.exists) {
  //           final SharedPreferences prefs =
  //               await SharedPreferences.getInstance();
  //           await prefs.setBool('isLoggedIn', true);

  //           Navigator.of(context).pushReplacement(
  //             MaterialPageRoute(
  //                 builder: (context) => const PatientHomeScreen()),
  //           );
  //         } else {
  //           _auth.signOut();
  //           _showSnackbar(
  //               "This account is not registered as a patient. Please check your credentials.");
  //         }
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'user-not-found') {
  //         _showSnackbar(
  //             "No patient account found. Please create a new account to get started.");
  //       } else if (e.code == 'wrong-password') {
  //         _showSnackbar("Incorrect password. Please try again.");
  //       } else {
  //         _showSnackbar("Sign-in failed: ${e.message}");
  //       }
  //     } catch (e) {
  //       _showSnackbar("Sign-in failed: ${e.toString()}");
  //     }
  //   }
  // }

  Future<void> _signIn() async {
    if (_patientformKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _phoneEmailController.text.trim();
        final password = _passwordController.text.trim();

        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;

        if (user != null) {
          final DocumentSnapshot snapshot = await _firestore
              .collection('CareSync')
              .doc('patients')
              .collection('accounts')
              .doc(user.uid)
              .get();

          if (snapshot.exists) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const PatientHomeScreen()),
            );
          } else {
            _auth.signOut();
            _showSnackbar(
                "This account is not registered as a patient. Please check your credentials.");
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _showSnackbar(
              "No patient account found. Please create a new account to get started.");
        } else if (e.code == 'wrong-password') {
          _showSnackbar("Incorrect password. Please try again.");
        } else {
          _showSnackbar("Sign-in failed: ${e.message}");
        }
      } catch (e) {
        _showSnackbar("Sign-in failed: ${e.toString()}");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    final email = _phoneEmailController.text.trim();
    if (email.isEmpty) {
      _showSnackbar('Please enter your email to reset password.');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackbar('Password reset email sent. Check your inbox.');
    } catch (e) {
      _showSnackbar('Failed to send reset email: ${e.toString()}');
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     if (googleUser == null) {
  //       _showSnackbar("Google Sign-In canceled");
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     if (userCredential.user != null) {
  //       final user = userCredential.user;

  //       final DocumentSnapshot snapshot = await _firestore
  //           .collection('CareSync')
  //           .doc('patients')
  //           .collection('accounts')
  //           .doc(user!.uid)
  //           .get();

  //       if (snapshot.exists) {
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => const PatientHomeScreen()),
  //         );
  //       } else {
  //         _auth.signOut();
  //         _showSnackbar(
  //             "This account is not registered as a patient. Please use a patient account.");
  //       }
  //     }
  //   } catch (e) {
  //     _showSnackbar("Google Sign-In error: ${e.toString()}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double paddingHorizontal = screenWidth * 0.05;
    double paddingVertical = screenHeight * 0.15;
    double fontSizeTitle = screenWidth * 0.08;
    double fontSizeButton = screenWidth * 0.04;
    double iconSize = screenWidth * 0.07;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight,
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
          padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LandingPage()));
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
              Padding(
                padding: EdgeInsets.fromLTRB(paddingHorizontal, paddingVertical,
                    paddingHorizontal, paddingHorizontal),
                child: Form(
                  key: _patientformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeInUp(
                        child: Text(
                          'Patient',
                          style: GoogleFonts.poppins(
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FadeInUp(
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.poppins(
                              fontSize: 30, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      FadeInUp(
                        child: TextFormField(
                          controller: _phoneEmailController,
                          decoration: InputDecoration(
                            labelText: 'Enter your email',
                            prefixIcon: Icon(Icons.email, size: iconSize),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      FadeInUp(
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Enter your password',
                            prefixIcon: Icon(Icons.lock, size: iconSize),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: iconSize,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      FadeInUp(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _sendPasswordResetEmail,
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: Color.fromRGBO(14, 190, 127, 1)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      FadeInUp(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(14, 190, 127, 1),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: screenHeight * 0.03,
                                  width: screenHeight * 0.03,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: fontSizeButton,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      FadeInUp(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PatientSignUpPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(14, 190, 127, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      // FadeInUp(
                      //   child: Row(
                      //     children: [
                      //       const Expanded(child: Divider()),
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: screenWidth * 0.02),
                      //         child: const Text('OR'),
                      //       ),
                      //       const Expanded(child: Divider()),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: screenHeight * 0.04),
                      // FadeInUp(
                      //   child: Center(
                      //     child: ElevatedButton.icon(
                      //       onPressed: signInWithGoogle,
                      //       label: Text(
                      //         'Sign In with Google',
                      //         style: TextStyle(fontSize: fontSizeButton),
                      //       ),
                      //       icon: Image.asset("assets/png/GoogleIcon.png",
                      //           width: iconSize),
                      //       style: ElevatedButton.styleFrom(
                      //         foregroundColor: Colors.black,
                      //         backgroundColor: Colors.white,
                      //         padding: EdgeInsets.symmetric(
                      //           vertical: screenHeight * 0.02,
                      //           horizontal: screenWidth * 0.1,
                      //         ),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           side: const BorderSide(color: Colors.grey),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInPatient({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      final snap = await _firestore
          .collection('CareSync')
          .doc('patients')
          .collection('accounts')
          .doc(user.uid)
          .get();

      if (!snap.exists) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'not-registered-patient',
          message:
              'This account is not registered as a patient. Please check your credentials.',
        );
      }
      await persistUserType('patient');
    }
    return credential;
  }

  Future<UserCredential> signInDoctor({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      final snap = await _firestore
          .collection('CareSync')
          .doc('doctors')
          .collection('accounts')
          .doc(user.uid)
          .get();

      if (!snap.exists) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'not-registered-doctor',
          message:
              'This account is not registered as a doctor. Please check your credentials.',
        );
      }
      await persistUserType('doctor');
    }
    return credential;
  }

  Future<UserCredential> signInAdmin({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final adminDoc = await _firestore.collection('CareSync').doc('admin').get();
    if (adminDoc.exists) {
      final adminData = adminDoc.data();
      if (adminData?['email'] != email) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'incorrect-admin-credentials',
          message:
              'Incorrect admin credentials. Please check your email and password.',
        );
      }
    } else {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'admin-not-found',
        message: 'Admin account does not exist.',
      );
    }

    await persistUserType('admin');
    return credential;
  }

  Future<UserCredential> signUpPatient({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      await _firestore
          .collection('CareSync')
          .doc('patients')
          .collection('accounts')
          .doc(user.uid)
          .set({
        'name': name,
        'role': 'patient',
        'phone': phone,
        'email': email,
        'gender': gender,
        'createdAt': DateTime.now(),
      });
    }
    return credential;
  }

  Future<UserCredential> signUpDoctor({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender,
    required String specialization,
    required String clinicLocation,
    File? imageFile,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String? imageUrl;
    if (imageFile != null) {
      final storageRef = _storage
          .ref()
          .child('doctor_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final snapshot = await storageRef.putFile(imageFile);
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    final user = credential.user;
    if (user != null) {
      await _firestore
          .collection('CareSync')
          .doc('doctors')
          .collection('accounts')
          .doc(user.uid)
          .set({
        'imageUrl': imageUrl,
        'name': name,
        'role': 'doctors',
        'phone': phone,
        'email': email,
        'gender': gender,
        'specialization': specialization,
        'cliniclocation': clinicLocation,
        'createdAt': DateTime.now(),
      });
    }
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userType');
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> persistUserType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userType', type);
  }

  Future<String?> getPersistedUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userType');
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

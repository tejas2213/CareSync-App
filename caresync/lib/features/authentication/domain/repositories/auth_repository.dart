import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;

  Future<UserCredential> signInPatient({
    required String email,
    required String password,
  });

  Future<UserCredential> signInDoctor({
    required String email,
    required String password,
  });

  Future<UserCredential> signInAdmin({
    required String email,
    required String password,
  });

  Future<UserCredential> signUpPatient({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender,
  });

  Future<UserCredential> signUpDoctor({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender,
    required String specialization,
    required String clinicLocation,
    File? imageFile,
  });

  Future<void> signOut();
  Future<String?> sendPasswordResetEmail(String email);
  Future<String?> getPersistedUserType();
  Future<void> persistUserType(String type);
  Future<bool> isUserLoggedIn();
}

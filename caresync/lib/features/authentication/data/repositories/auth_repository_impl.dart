import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  User? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<UserCredential> signInPatient({
    required String email,
    required String password,
  }) =>
      _remoteDataSource.signInPatient(email: email, password: password);

  @override
  Future<UserCredential> signInDoctor({
    required String email,
    required String password,
  }) =>
      _remoteDataSource.signInDoctor(email: email, password: password);

  @override
  Future<UserCredential> signInAdmin({
    required String email,
    required String password,
  }) =>
      _remoteDataSource.signInAdmin(email: email, password: password);

  @override
  Future<UserCredential> signUpPatient({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender,
  }) =>
      _remoteDataSource.signUpPatient(
        name: name,
        phone: phone,
        email: email,
        password: password,
        gender: gender,
      );

  @override
  Future<UserCredential> signUpDoctor({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender,
    required String specialization,
    required String clinicLocation,
    File? imageFile,
  }) =>
      _remoteDataSource.signUpDoctor(
        name: name,
        phone: phone,
        email: email,
        password: password,
        gender: gender,
        specialization: specialization,
        clinicLocation: clinicLocation,
        imageFile: imageFile,
      );

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<String?> sendPasswordResetEmail(String email) =>
      _remoteDataSource.sendPasswordResetEmail(email);

  @override
  Future<String?> getPersistedUserType() =>
      _remoteDataSource.getPersistedUserType();

  @override
  Future<void> persistUserType(String type) =>
      _remoteDataSource.persistUserType(type);

  @override
  Future<bool> isUserLoggedIn() => _remoteDataSource.isUserLoggedIn();
}

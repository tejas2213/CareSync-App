import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class PatientsRemoteDataSource {
  Stream<Map<String, dynamic>?> streamPatientProfile(String patientId);
  Future<Map<String, dynamic>?> getPatientProfile(String patientId);
  Future<void> updatePatientProfile({
    required String patientId,
    required Map<String, dynamic> data,
    File? imageFile,
  });
}

class PatientsRemoteDataSourceImpl implements PatientsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  PatientsRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  DocumentReference<Map<String, dynamic>> _patientDoc(String patientId) {
    return _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId);
  }

  @override
  Stream<Map<String, dynamic>?> streamPatientProfile(String patientId) {
    return _patientDoc(patientId).snapshots().map((doc) => doc.data());
  }

  @override
  Future<Map<String, dynamic>?> getPatientProfile(String patientId) async {
    final doc = await _patientDoc(patientId).get();
    return doc.data();
  }

  @override
  Future<void> updatePatientProfile({
    required String patientId,
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    final updateData = Map<String, dynamic>.from(data);
    if (imageFile != null) {
      final storageRef =
          _storage.ref().child('CareSync/$patientId/profile.jpg');
      await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();
      updateData['profileImage'] = downloadUrl;
    }

    await _patientDoc(patientId).update(updateData);
  }
}

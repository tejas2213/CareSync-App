import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:caresync/features/medical_records/data/models/medical_record_model.dart';

abstract class MedicalRecordsRemoteDataSource {
  Stream<List<MedicalRecordModel>> streamMedicalRecords(String patientId);
  Future<void> uploadMedicalRecord({
    required String patientId,
    required File file,
    required String fileName,
    required String type,
  });
  Future<void> deleteMedicalRecord({
    required String patientId,
    required String recordId,
    required String fileUrl,
  });
}

class MedicalRecordsRemoteDataSourceImpl
    implements MedicalRecordsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  MedicalRecordsRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  @override
  Stream<List<MedicalRecordModel>> streamMedicalRecords(String patientId) {
    return _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('medical_records')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MedicalRecordModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<void> uploadMedicalRecord({
    required String patientId,
    required File file,
    required String fileName,
    required String type,
  }) async {
    final String timestampStr =
        DateTime.now().millisecondsSinceEpoch.toString();
    final Reference ref = _storage
        .ref()
        .child('CareSync/medical_records/$patientId/$timestampStr');

    final UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();

    await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('medical_records')
        .add({
      'type': type,
      'file_name': fileName,
      'url': downloadUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteMedicalRecord({
    required String patientId,
    required String recordId,
    required String fileUrl,
  }) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (_) {
      // Storage file might already be deleted or URL invalid, still delete Firestore document
    }

    await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('medical_records')
        .doc(recordId)
        .delete();
  }
}

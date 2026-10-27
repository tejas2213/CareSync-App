import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:caresync/features/appointments/data/models/doctor_appointment_model.dart';

abstract class DoctorsRemoteDataSource {
  Stream<Map<String, dynamic>?> streamDoctorProfile(String doctorId);
  Future<Map<String, dynamic>?> getDoctorProfile(String doctorId);
  Future<void> updateDoctorProfile({
    required String doctorId,
    required Map<String, dynamic> data,
    File? imageFile,
  });
  Stream<List<DrAppointment>> streamDoctorAppointments(String doctorId);
  Future<void> updateAppointmentStatus({
    required String doctorId,
    required String appointmentId,
    required String patientId,
    required String patientAppId,
    required String status,
  });
}

class DoctorsRemoteDataSourceImpl implements DoctorsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  DoctorsRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  @override
  Stream<Map<String, dynamic>?> streamDoctorProfile(String doctorId) {
    return _firestore
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .doc(doctorId)
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null);
  }

  @override
  Future<Map<String, dynamic>?> getDoctorProfile(String doctorId) async {
    final doc = await _firestore
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .doc(doctorId)
        .get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Future<void> updateDoctorProfile({
    required String doctorId,
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    final Map<String, dynamic> updateData = Map.from(data);

    if (imageFile != null) {
      final String filePath = 'CareSync/$doctorId/profile.jpg';
      final TaskSnapshot snapshot =
          await _storage.ref(filePath).putFile(imageFile);
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      updateData['profileImage'] = downloadUrl;
      updateData['imageUrl'] = downloadUrl;
    }

    await _firestore
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .doc(doctorId)
        .update(updateData);
  }

  @override
  Stream<List<DrAppointment>> streamDoctorAppointments(String doctorId) {
    return _firestore
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .doc(doctorId)
        .collection('appointments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return DrAppointment(
          patientAppId: data['appointmentId']?.toString() ?? '',
          appointmentId: doc.id,
          patientId: data['patientId']?.toString() ?? '',
          name: data['name']?.toString() ?? 'Unknown',
          date: data['date']?.toString() ?? '',
          phone: data['phone']?.toString() ?? '',
          time: data['time']?.toString() ?? '',
          status: data['status']?.toString() ?? 'pending',
        );
      }).toList();
    });
  }

  @override
  Future<void> updateAppointmentStatus({
    required String doctorId,
    required String appointmentId,
    required String patientId,
    required String patientAppId,
    required String status,
  }) async {
    await _firestore
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .doc(doctorId)
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': status});

    if (patientId.isNotEmpty && patientAppId.isNotEmpty) {
      try {
        await _firestore
            .collection('CareSync')
            .doc('patients')
            .collection('accounts')
            .doc(patientId)
            .collection('appointments')
            .doc(patientAppId)
            .update({'status': status});
      } catch (_) {}
    }
  }
}

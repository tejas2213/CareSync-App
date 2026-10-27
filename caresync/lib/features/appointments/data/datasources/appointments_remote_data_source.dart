import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/appointment_model.dart';

class AppointmentsRemoteDataSource {
  final FirebaseFirestore _firestore;

  AppointmentsRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<MyAppointment>> getPatientAppointmentsStream(String patientId) {
    return _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('appointments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MyAppointment(
          doctorId: doc.id,
          name: data['name'] ?? 'Unknown',
          doctorName: data['doctorName'] ?? 'Unknown',
          date: data['date'] ?? 'Unknown',
          phone: data['phone'] ?? 'Unknown',
          time: data['time'] ?? 'Unknown',
          status: data['status'] ?? 'Unknown',
          appointmentId: doc.id,
        );
      }).toList();
    });
  }

  Future<void> bookAppointment({
    required String patientId,
    required String doctorId,
    required String doctorName,
    required String patientName,
    required String patientPhone,
    required String date,
    required String time,
  }) async {
    final patientAppRef = await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('appointments')
        .add({
      'name': patientName,
      'patientId': patientId,
      'phone': patientPhone,
      'date': date,
      'time': time,
      'doctorName': doctorName,
      'doctorId': doctorId,
      'status': 'pending',
    });

    await _firestore
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .doc(doctorId)
        .collection('appointments')
        .add({
      'appointmentId': patientAppRef.id,
      'name': patientName,
      'phone': patientPhone,
      'date': date,
      'time': time,
      'doctorName': doctorName,
      'doctorId': doctorId,
      'status': 'pending',
      'patientId': patientId,
    });
  }
}

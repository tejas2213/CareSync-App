import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class AmbulanceRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AmbulanceRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getAmbulancesStream() {
    return _firestore.collection('Ambulances').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAmbulancesByTypeStream(
      String type) {
    return _firestore
        .collection('Ambulances')
        .where('ambulanceType', isEqualTo: type)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getAmbulanceDetails(String ambulanceId) async {
    final doc =
        await _firestore.collection('Ambulances').doc(ambulanceId).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getPatientBookings(
      String patientId) async {
    final snapshot = await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('ambulanceBookings')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> bookAmbulance({
    required String? patientId,
    required String ambulanceId,
    required String ambulanceName,
    required String? ambulancePhone,
    required String pickupLocation,
    required String dropoffLocation,
  }) async {
    final uid = patientId ?? _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User is not logged in.');
    }

    final patientDoc = await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(uid)
        .get();

    final patientName = patientDoc.data()?['name'] ?? 'N/A';
    final patientPhone = patientDoc.data()?['phone'] ?? 'N/A';

    if (ambulancePhone != null && ambulancePhone.isNotEmpty) {
      try {
        final twilio = TwilioFlutter(
          accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
          authToken: 'YOUR_TWILIO_AUTH_TOKEN',
          twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
        );
        await twilio.sendSMS(
          toNumber: ambulancePhone,
          messageBody:
              'Ambulance request from $patientName, Phone: $patientPhone, Pickup: $pickupLocation, Dropoff: $dropoffLocation',
        );
      } catch (_) {}
    }

    await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(uid)
        .collection('ambulanceBookings')
        .add({
      'ambulanceId': ambulanceId,
      'ambulanceName': ambulanceName,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'status': 'Pending',
      'bookingTime': FieldValue.serverTimestamp(),
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caresync/features/blood_donation/data/models/blood_form_model.dart';

abstract class BloodDonationRemoteDataSource {
  Stream<List<BloodDetail>> streamPendingBloodRequests(
      {required String currentUserId});
  Stream<List<BloodDetail>> streamMyBloodRequests(
      {required String currentUserId});
  Future<void> submitBloodRequest({
    required String patientId,
    required String name,
    required String phone,
    required String email,
    required String age,
    required String? gender,
    required String address,
    required String? bloodGroup,
  });
  Future<void> acceptBloodRequest({
    required String recipientId,
    required String recipientFormId,
    required String uniId,
    required String donorId,
  });
}

class BloodDonationRemoteDataSourceImpl
    implements BloodDonationRemoteDataSource {
  final FirebaseFirestore _firestore;

  BloodDonationRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<BloodDetail>> streamPendingBloodRequests(
      {required String currentUserId}) {
    return _firestore.collection('blood finder').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) {
            final data = doc.data();
            final recipientId = data['recipientId']?.toString() ?? '';
            final status = data['status']?.toString() ?? '';
            return currentUserId != recipientId &&
                status.toLowerCase() == 'pending';
          })
          .map((doc) => BloodDetail.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Stream<List<BloodDetail>> streamMyBloodRequests(
      {required String currentUserId}) {
    return _firestore.collection('blood finder').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) {
            final data = doc.data();
            final recipientId = data['recipientId']?.toString() ?? '';
            return currentUserId == recipientId;
          })
          .map((doc) => BloodDetail.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> submitBloodRequest({
    required String patientId,
    required String name,
    required String phone,
    required String email,
    required String age,
    required String? gender,
    required String address,
    required String? bloodGroup,
  }) async {
    final docRef = await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(patientId)
        .collection('search blood')
        .add({
      'name': name,
      'recipientId': patientId,
      'role': 'recipient',
      'phone': phone,
      'email': email,
      'age': age,
      'gender': gender,
      'address': address,
      'blood group': bloodGroup,
      'createdAt': DateTime.now(),
      'status': 'pending',
      'donorId': '',
      'donorName': '',
      'donorRole': '',
    });

    final currentBloodFormId = docRef.id;

    await _firestore.collection('blood finder').add({
      'name': name,
      'recipientFormId': currentBloodFormId,
      'recipientId': patientId,
      'role': 'recipient',
      'phone': phone,
      'email': email,
      'age': age,
      'gender': gender,
      'address': address,
      'blood group': bloodGroup,
      'createdAt': DateTime.now(),
      'status': 'pending',
      'donorId': '',
      'donorName': '',
      'donorRole': '',
    });
  }

  @override
  Future<void> acceptBloodRequest({
    required String recipientId,
    required String recipientFormId,
    required String uniId,
    required String donorId,
  }) async {
    String? donorName;
    String donorRole = 'patients';

    try {
      final patientSnap =
          await _firestore.doc('CareSync/patients/accounts/$donorId').get();
      if (patientSnap.exists && patientSnap.data() != null) {
        donorName = patientSnap.get('name')?.toString();
      }
    } catch (_) {}

    if (donorName == null) {
      try {
        final docSnap =
            await _firestore.doc('CareSync/doctors/accounts/$donorId').get();
        if (docSnap.exists && docSnap.data() != null) {
          donorName = docSnap.get('name')?.toString();
          donorRole = 'doctors';
        }
      } catch (_) {}
    }

    donorName ??= 'Anonymous Donor';

    await _firestore
        .collection('CareSync')
        .doc('patients')
        .collection('accounts')
        .doc(recipientId)
        .collection('search blood')
        .doc(recipientFormId)
        .update({
      'status': 'Accepted',
      'donorId': donorId,
      'donorName': donorName,
      'donorRole': donorRole,
    });

    await _firestore.collection('blood finder').doc(uniId).update({
      'status': 'Accepted',
      'donorId': donorId,
      'donorName': donorName,
      'donorRole': donorRole,
    });
  }
}

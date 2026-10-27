import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:caresync/features/doctor_speciality/data/models/doctor_model.dart';

abstract class DoctorSpecialityRemoteDataSource {
  Stream<List<Doctor>> streamDoctors();
}

class DoctorSpecialityRemoteDataSourceImpl
    implements DoctorSpecialityRemoteDataSource {
  final FirebaseFirestore _firestore;

  DoctorSpecialityRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Doctor>> streamDoctors() {
    return _firestore
        .collection('CareSync')
        .doc('doctors')
        .collection('accounts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList());
  }
}

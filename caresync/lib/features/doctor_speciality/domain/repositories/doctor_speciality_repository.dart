import 'package:caresync/features/doctor_speciality/data/models/doctor_model.dart';

abstract class DoctorSpecialityRepository {
  Stream<List<Doctor>> streamDoctors();
  Stream<List<Doctor>> streamDoctorsBySpeciality(String speciality);
}

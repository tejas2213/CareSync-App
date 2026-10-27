import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caresync/features/doctor_speciality/data/models/doctor_model.dart';
import 'package:caresync/features/doctor_speciality/data/repositories/doctor_speciality_repository_impl.dart';
import 'package:caresync/features/doctor_speciality/domain/repositories/doctor_speciality_repository.dart';

final doctorSpecialityRepositoryProvider =
    Provider<DoctorSpecialityRepository>((ref) {
  return DoctorSpecialityRepositoryImpl();
});

final allDoctorsStreamProvider =
    StreamProvider.autoDispose<List<Doctor>>((ref) {
  final repository = ref.watch(doctorSpecialityRepositoryProvider);
  return repository.streamDoctors();
});

final doctorsBySpecialityStreamProvider =
    StreamProvider.autoDispose.family<List<Doctor>, String>((ref, speciality) {
  final repository = ref.watch(doctorSpecialityRepositoryProvider);
  return repository.streamDoctorsBySpeciality(speciality);
});

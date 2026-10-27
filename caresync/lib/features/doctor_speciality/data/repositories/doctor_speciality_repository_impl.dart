import 'package:caresync/features/doctor_speciality/data/datasources/doctor_speciality_remote_data_source.dart';
import 'package:caresync/features/doctor_speciality/data/models/doctor_model.dart';
import 'package:caresync/features/doctor_speciality/domain/repositories/doctor_speciality_repository.dart';

class DoctorSpecialityRepositoryImpl implements DoctorSpecialityRepository {
  final DoctorSpecialityRemoteDataSource _remoteDataSource;

  DoctorSpecialityRepositoryImpl(
      {DoctorSpecialityRemoteDataSource? remoteDataSource})
      : _remoteDataSource =
            remoteDataSource ?? DoctorSpecialityRemoteDataSourceImpl();

  @override
  Stream<List<Doctor>> streamDoctors() {
    return _remoteDataSource.streamDoctors();
  }

  @override
  Stream<List<Doctor>> streamDoctorsBySpeciality(String speciality) {
    return _remoteDataSource.streamDoctors().map((doctors) => doctors
        .where((doctor) =>
            doctor.specialization.toLowerCase() == speciality.toLowerCase())
        .toList());
  }
}

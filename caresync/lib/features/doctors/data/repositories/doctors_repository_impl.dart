import 'dart:io';
import 'package:caresync/features/appointments/data/models/doctor_appointment_model.dart';
import 'package:caresync/features/doctors/data/datasources/doctors_remote_data_source.dart';
import 'package:caresync/features/doctors/domain/repositories/doctors_repository.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  final DoctorsRemoteDataSource _remoteDataSource;

  DoctorsRepositoryImpl({DoctorsRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? DoctorsRemoteDataSourceImpl();

  @override
  Stream<Map<String, dynamic>?> streamDoctorProfile(String doctorId) {
    return _remoteDataSource.streamDoctorProfile(doctorId);
  }

  @override
  Future<Map<String, dynamic>?> getDoctorProfile(String doctorId) {
    return _remoteDataSource.getDoctorProfile(doctorId);
  }

  @override
  Future<void> updateDoctorProfile({
    required String doctorId,
    required Map<String, dynamic> data,
    File? imageFile,
  }) {
    return _remoteDataSource.updateDoctorProfile(
      doctorId: doctorId,
      data: data,
      imageFile: imageFile,
    );
  }

  @override
  Stream<List<DrAppointment>> streamDoctorAppointments(String doctorId) {
    return _remoteDataSource.streamDoctorAppointments(doctorId);
  }

  @override
  Future<void> updateAppointmentStatus({
    required String doctorId,
    required String appointmentId,
    required String patientId,
    required String patientAppId,
    required String status,
  }) {
    return _remoteDataSource.updateAppointmentStatus(
      doctorId: doctorId,
      appointmentId: appointmentId,
      patientId: patientId,
      patientAppId: patientAppId,
      status: status,
    );
  }
}

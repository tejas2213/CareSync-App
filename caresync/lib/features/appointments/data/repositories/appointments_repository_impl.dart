import '../../data/models/appointment_model.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointments_remote_data_source.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource _remoteDataSource;

  AppointmentsRepositoryImpl({AppointmentsRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AppointmentsRemoteDataSource();

  @override
  Stream<List<MyAppointment>> getPatientAppointmentsStream(String patientId) =>
      _remoteDataSource.getPatientAppointmentsStream(patientId);

  @override
  Future<void> bookAppointment({
    required String patientId,
    required String doctorId,
    required String doctorName,
    required String patientName,
    required String patientPhone,
    required String date,
    required String time,
  }) =>
      _remoteDataSource.bookAppointment(
        patientId: patientId,
        doctorId: doctorId,
        doctorName: doctorName,
        patientName: patientName,
        patientPhone: patientPhone,
        date: date,
        time: time,
      );
}

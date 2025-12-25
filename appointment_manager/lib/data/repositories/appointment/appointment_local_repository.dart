import 'package:appointment_manager/data/repositories/appointment/appointment_repository.dart';
import 'package:appointment_manager/domain/models/appointment_model.dart';
import 'package:hive/hive.dart';

class AppointmentLocalRepository extends AppointmentRepository {
  final Box<AppointmentModel> _box = Hive.box<AppointmentModel>('appointments');

  List<AppointmentModel> getAllAppointments() {
    return _box.values.toList();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    await _box.put(appointment.id, appointment);
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    await appointment.save();
  }

  Future<void> deleteAppointment(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}

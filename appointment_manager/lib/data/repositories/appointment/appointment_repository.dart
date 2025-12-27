import 'package:appointment_manager/data/services/api_services/appointment_api_service.dart';
import 'package:appointment_manager/data/services/local_services/local_db_service.dart';
import 'package:appointment_manager/domain/models/appointment_model.dart';
import 'package:appointment_manager/utils/connectivity_utils.dart';

class AppointmentRepository {
  final AppointmentApiService _remote = AppointmentApiService();
  final LocalDbService _local = LocalDbService();
  final ConnectivityService _connectivity = ConnectivityService();

  Future<void> initialSync() async {
    final online = await _connectivity.isOnline;
    if (!online) return;

    await syncPendingAppointments();
    await fetchRemoteToLocal();
  }

  List<AppointmentModel> getAllAppointments() {
    return _local.getAllAppointments();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    appointment.isSynced = false;
    await _local.addAppointment(appointment);

    if (await _connectivity.isOnline) {
      try {
        await _remote.createAppointment(appointment);
        appointment.isSynced = true;
        await _local.updateAppointment(appointment);
      } catch (_) {
        // keep pending
      }
    }
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    appointment.isSynced = false;
    await _local.updateAppointment(appointment);

    if (await _connectivity.isOnline) {
      try {
        await _remote.updateAppointment(appointment);
        appointment.isSynced = true;
        await _local.updateAppointment(appointment);
      } catch (_) {}
    }
  }

  Future<void> deleteAppointment(String id) async {
    await _local.deleteAppointment(id);

    if (await _connectivity.isOnline) {
      try {
        await _remote.deleteAppointment(id);
      } catch (_) {}
    }
  }

  Future<void> syncPendingAppointments() async {
    final pending = _local.getAllAppointments().where((e) => !e.isSynced);

    for (final a in pending) {
      try {
        await _remote.createAppointment(a);
        a.isSynced = true;
        await _local.updateAppointment(a);
      } catch (_) {}
    }
  }

  Future<void> fetchRemoteToLocal() async {
    final remoteList = await _remote.fetchAppointments();

    await _local.clearAll();
    for (final a in remoteList) {
      await _local.addAppointment(a);
    }
  }

  Future<void> clearAll() async {
    await _local.clearAll();
  }
}

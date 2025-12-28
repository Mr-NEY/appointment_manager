import 'package:appointment_manager/data/services/api_services/appointment_api_service.dart';
import 'package:appointment_manager/data/services/local_services/local_db_service.dart';
import 'package:appointment_manager/domain/models/appointment_filter_model.dart';
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

  List<AppointmentModel> searchAppointments(String keyword) {
    final all = _local.getAllAppointments();

    if (keyword.isEmpty) return all;

    final lower = keyword.toLowerCase();

    return all
        .where(
          (a) =>
              a.title.toLowerCase().contains(lower) ||
              a.customerName.toLowerCase().contains(lower) ||
              a.company.toLowerCase().contains(lower),
        )
        .toList();
  }

  List<AppointmentModel> filterByDate(AppointmentDateFilter filter) {
    final all = _local.getAllAppointments();
    final now = DateTime.now();

    return all.where((a) {
      final date = a.dateTime;

      switch (filter.type) {
        case DateFilter.today:
          return _isSameDay(date, now);

        case DateFilter.upcoming:
          return date.isAfter(now);

        case DateFilter.past:
          return date.isBefore(now);

        case DateFilter.custom:
          if (filter.fromDate != null && filter.toDate != null) {
            final from = DateTime(
              filter.fromDate!.year,
              filter.fromDate!.month,
              filter.fromDate!.day,
            );

            final to = DateTime(
              filter.toDate!.year,
              filter.toDate!.month,
              filter.toDate!.day,
              23,
              59,
              59,
            );

            return date.isAfter(from.subtract(const Duration(seconds: 1))) &&
                date.isBefore(to.add(const Duration(seconds: 1)));
          }
          return true;

        case DateFilter.all:
          return true;
      }
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

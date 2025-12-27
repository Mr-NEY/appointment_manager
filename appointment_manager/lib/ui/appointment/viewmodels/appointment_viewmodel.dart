import 'package:appointment_manager/data/repositories/appointment/appointment_repository.dart';
import 'package:appointment_manager/domain/models/appointment_model.dart';
import 'package:appointment_manager/utils/connectivity_utils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AppointmentViewModel extends ChangeNotifier {
  final AppointmentRepository _repo = AppointmentRepository();
  final ConnectivityService _connectivity = ConnectivityService();

  List<AppointmentModel> appointments = [];
  bool isOnline = false;

  AppointmentViewModel() {
    _init();
  }

  Future<void> _init() async {
    isOnline = await _connectivity.isOnline;
    await _repo.initialSync();
    _listenConnectivity();
    loadAppointments();
  }

  void _listenConnectivity() {
    _connectivity.onConnectivityChanged.listen((online) async {
      isOnline = online;

      if (online) {
        await _repo.syncPendingAppointments();
        await _repo.fetchRemoteToLocal();
      }

      loadAppointments();
      notifyListeners();
    });
  }

  void loadAppointments() {
    appointments = _repo.getAllAppointments();
    notifyListeners();
  }

  Future<void> addAppointment({
    required String title,
    required String customerName,
    required String company,
    required String description,
    required DateTime dateTime,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final appointment = AppointmentModel(
      id: const Uuid().v4(),
      title: title,
      customerName: customerName,
      company: company,
      description: description,
      dateTime: dateTime,
      latitude: latitude,
      longitude: longitude,
      address: address,
      isSynced: false,
    );

    await _repo.addAppointment(appointment);
    loadAppointments();
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    await _repo.updateAppointment(appointment);
    loadAppointments();
  }

  Future<void> deleteAppointment(String id) async {
    await _repo.deleteAppointment(id);
    loadAppointments();
  }
}

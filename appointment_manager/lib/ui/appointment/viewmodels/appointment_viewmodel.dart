import 'package:appointment_manager/data/repositories/appointment/appointment_local_repository.dart';
import 'package:appointment_manager/domain/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AppointmentViewmodel extends ChangeNotifier {
  final AppointmentLocalRepository _repo = AppointmentLocalRepository();

  List<AppointmentModel> appointments = [];

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

  Future<void> updateAppointment({
    required String id,
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
      id: id,
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

  Future<void> deleteAppointment(String id) async {
    await _repo.deleteAppointment(id);
    loadAppointments();
  }
}

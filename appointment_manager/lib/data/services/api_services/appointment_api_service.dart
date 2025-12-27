import 'package:appointment_manager/domain/models/appointment_model.dart';
import 'package:dio/dio.dart';

class AppointmentApiService {
  static const baseURL = "http://192.168.100.116:3001";
  final Dio _dio;

  AppointmentApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseURL,
          headers: {"Content-Type": "application/json"},
        ),
      );

  Future<List<AppointmentModel>> fetchAppointments() async {
    final res = await _dio.get("/appointments");
    return (res.data as List).map((e) => AppointmentModel.fromMap(e)).toList();
  }

  Future<void> createAppointment(AppointmentModel a) async {
    await _dio.post("/appointments", data: a.toJson());
  }

  Future<void> updateAppointment(AppointmentModel a) async {
    await _dio.put("/appointments/${a.id}", data: a.toJson());
  }

  Future<void> deleteAppointment(String id) async {
    await _dio.delete("/appointments/$id");
  }
}

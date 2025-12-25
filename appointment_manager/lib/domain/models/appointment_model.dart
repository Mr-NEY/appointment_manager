import 'package:hive/hive.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 0)
class AppointmentModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String customerName;

  @HiveField(3)
  String company;

  @HiveField(4)
  String description;

  @HiveField(5)
  DateTime dateTime;

  @HiveField(6)
  double latitude;

  @HiveField(7)
  double longitude;

  @HiveField(8)
  String address;

  @HiveField(9)
  bool isSynced;
  AppointmentModel({
    required this.id,
    required this.title,
    required this.customerName,
    required this.company,
    required this.description,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isSynced,
  });

  AppointmentModel copyWith({
    String? id,
    String? title,
    String? customerName,
    String? company,
    String? description,
    DateTime? dateTime,
    double? latitude,
    double? longitude,
    String? address,
    bool? isSynced,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      customerName: customerName ?? this.customerName,
      company: company ?? this.company,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'customerName': customerName,
      'company': company,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'isSynced': isSynced,
    };
  }  
}

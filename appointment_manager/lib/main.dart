import 'package:appointment_manager/ui/appointment/widgets/add_edit_appointment_screen.dart';
import 'package:appointment_manager/ui/appointment/widgets/appointment_details_screen.dart';
import 'package:appointment_manager/ui/appointment/widgets/appointment_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apppointment Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (_) => const AppointmentListScreen(),
        '/add-edit': (_) => const AddEditAppointmentScreen(),
        '/detail': (_) => const AppointmentDetailsScreen(),
      },
    );
  }
}




import 'package:appointment_manager/domain/models/appointment_model.dart';
import 'package:appointment_manager/ui/appointment/viewmodels/appointment_viewmodel.dart';
import 'package:appointment_manager/ui/appointment/widgets/add_edit_appointment_screen.dart';
import 'package:appointment_manager/ui/appointment/widgets/appointment_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AppointmentModelAdapter());
  await Hive.openBox<AppointmentModel>('appointments');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentViewmodel()),
      ],
      child: const MyApp(),
    ),
  );
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
      },
    );
  }
}

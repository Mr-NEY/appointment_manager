import 'package:appointment_manager/domain/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final AppointmentModel appointment;
  const AppointmentDetailScreen({super.key, required this.appointment});
  
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'yyyy-MM-dd hh:mm a',
    ).format(appointment.dateTime);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/add-edit');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // TODO: delete logic
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(title: Text('Title'), subtitle: Text(appointment.title)),
            ListTile(
              title: Text('Customer'),
              subtitle: Text(appointment.customerName),
            ),
            ListTile(
              title: Text('Company'),
              subtitle: Text(appointment.company),
            ),
            ListTile(title: Text('Date & Time'), subtitle: Text(formattedDate)),
            ListTile(
              title: Text('Location'),
              subtitle: Text(appointment.address),
            ),
          ],
        ),
      ),
    );
  }
}


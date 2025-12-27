import 'package:appointment_manager/domain/models/appointment_model.dart';
import 'package:appointment_manager/ui/appointment/viewmodels/appointment_viewmodel.dart';
import 'package:appointment_manager/ui/appointment/widgets/appointment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentViewModel>().loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentViewmodel = context.watch<AppointmentViewModel>();
    List<AppointmentModel> appointments = appointmentViewmodel.appointments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              // TODO: open filter dialog
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-edit');
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by title, customer, company',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // TODO: search logic
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(appointments[index].title),
                        SizedBox(width: 8),
                        Icon(
                          appointments[index].isSynced
                              ? Icons.cloud_done
                              : Icons.cloud_off,
                          color: appointments[index].isSynced
                              ? Colors.green
                              : Colors.red,
                          size: 10,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "${appointments[index].customerName} - ${appointments[index].company}",
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      final appointment = appointments[index];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AppointmentDetailScreen(appointment: appointment),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

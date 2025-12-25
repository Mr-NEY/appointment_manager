import 'package:appointment_manager/ui/appointment/viewmodels/appointment_viewmodel.dart';
import 'package:appointment_manager/ui/appointment/widgets/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditAppointmentScreen extends StatefulWidget {
  const AddEditAppointmentScreen({super.key});

  @override
  State<AddEditAppointmentScreen> createState() =>
      _AddEditAppointmentScreenState();
}

class _AddEditAppointmentScreenState extends State<AddEditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final customerNameController = TextEditingController();
  final companyController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate;
  double? latitude;
  double? longitude;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8),
              _buildTextField('Title', controllerName: titleController),
              _buildTextField(
                'Customer Name',
                controllerName: customerNameController,
              ),
              _buildTextField('Company', controllerName: companyController),
              _buildTextField(
                'Description',
                maxLines: 3,
                controllerName: descriptionController,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  selectedDate == null
                      ? 'Select Date & Time'
                      : selectedDate.toString(),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: Text(
                  latitude == null ? 'Pick Location' : 'Location Selected',
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapPickerScreen()),
                  );
                  if (result != null) {
                    setState(() {
                      latitude = result.latitude;
                      longitude = result.longitude;
                      address = result.address;
                    });
                  }
                },
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveAppointment,
                child: const Text('Save Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    int maxLines = 1,
    required TextEditingController controllerName,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        autofocus: false,
        maxLines: maxLines,
        controller: controllerName,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select Date and Time')));
        return;
      }
      if (latitude == null && longitude == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please pick a location')));
        return;
      } else {
        context.read<AppointmentViewmodel>().addAppointment(
          title: titleController.text.trim(),
          customerName: customerNameController.text.trim(),
          company: companyController.text.trim(),
          description: descriptionController.text.trim(),
          dateTime: selectedDate!,
          latitude: latitude!,
          longitude: longitude!,
          address: address!,
        );
        Navigator.pop(context);
      }
    }
  }
}

import 'package:appointment_manager/domain/models/appointment_filter_model.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final AppointmentDateFilter currentFilter;

  const FilterDialog({
    required this.currentFilter,
    super.key,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late DateFilter _selectedType;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.currentFilter.type;
    fromDate = widget.currentFilter.fromDate;
    toDate = widget.currentFilter.toDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Appointments'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _radio(DateFilter.all, 'All'),
            _radio(DateFilter.today, 'Today'),
            _radio(DateFilter.upcoming, 'Upcoming'),
            _radio(DateFilter.past, 'Past'),
            _radio(DateFilter.custom, 'Custom date range'),

            if (_selectedType == DateFilter.custom) ...[
              const SizedBox(height: 12),
              _dateTile(
                label: 'From date',
                date: fromDate,
                onTap: () => _pickFromDate(context),
              ),
              _dateTile(
                label: 'To date',
                date: toDate,
                onTap: () => _pickToDate(context),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              AppointmentDateFilter(
                type: _selectedType,
                fromDate: fromDate,
                toDate: toDate,
              ),
            );
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _radio(DateFilter type, String label) {
    return RadioListTile<DateFilter>(
      value: type,
      groupValue: _selectedType,
      title: Text(label),
      onChanged: (value) {
        setState(() {
          _selectedType = value!;
        });
      },
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(label),
      subtitle: Text(
        date == null
            ? 'Select date'
            : '${date.year}-${date.month}-${date.day}',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: onTap,
    );
  }

  Future<void> _pickFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: toDate ?? DateTime(2100),
    );

    if (picked != null) {
      setState(() => fromDate = picked);
    }
  }

  Future<void> _pickToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? fromDate ?? DateTime.now(),
      firstDate: fromDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => toDate = picked);
    }
  }
}

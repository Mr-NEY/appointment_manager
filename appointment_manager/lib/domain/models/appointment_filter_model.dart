
enum DateFilter { all, today, upcoming, past, custom }

class AppointmentDateFilter {
  final DateFilter type;
  final DateTime? fromDate;
  final DateTime? toDate;

  const AppointmentDateFilter({
    this.type = DateFilter.all,
    this.fromDate,
    this.toDate,
  });
}


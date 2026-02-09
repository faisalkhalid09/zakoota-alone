/// Mock data for Cases and Appointments
class CasesMockData {
  static final List<Appointment> appointments = [
    Appointment(
      id: 'A001',
      lawyerId: 'L001',
      lawyerName: 'Adv. Sarah Ahmed',
      consultationType: 'Corporate Consultation',
      date: DateTime(2026, 2, 12, 10, 0),
      endTime: DateTime(2026, 2, 12, 11, 0),
      status: AppointmentStatus.confirmed,
    ),
    Appointment(
      id: 'A002',
      lawyerId: 'L003',
      lawyerName: 'Adv. Hassan Ali',
      consultationType: 'Criminal Defense',
      date: DateTime(2026, 2, 15, 14, 0),
      endTime: DateTime(2026, 2, 15, 15, 0),
      status: AppointmentStatus.pending,
    ),
    Appointment(
      id: 'A003',
      lawyerId: 'L002',
      lawyerName: 'Adv. Fatima Khan',
      consultationType: 'Family Law Consultation',
      date: DateTime(2026, 2, 8, 9, 0),
      endTime: DateTime(2026, 2, 8, 10, 0),
      status: AppointmentStatus.confirmed,
    ),
  ];

  static final List<LegalCase> cases = [
    LegalCase(
      id: 'C205',
      title: 'Property Dispute',
      description: 'Inheritance property claim case',
      status: LegalCaseStatus.inCourt,
      assignedLawyerId: 'L004',
      assignedLawyerName: 'Adv. Ali Khan',
      filedDate: DateTime(2025, 11, 20),
      nextHearing: DateTime(2026, 2, 18),
    ),
    LegalCase(
      id: 'C187',
      title: 'Contract Breach',
      description: 'Business contract violation dispute',
      status: LegalCaseStatus.underReview,
      assignedLawyerId: 'L001',
      assignedLawyerName: 'Adv. Sarah Ahmed',
      filedDate: DateTime(2026, 1, 5),
      nextHearing: DateTime(2026, 2, 22),
    ),
  ];
}

/// Appointment Model
class Appointment {
  final String id;
  final String lawyerId;
  final String lawyerName;
  final String consultationType;
  final DateTime date;
  final DateTime endTime;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.lawyerId,
    required this.lawyerName,
    required this.consultationType,
    required this.date,
    required this.endTime,
    required this.status,
  });
}

enum AppointmentStatus {
  confirmed,
  pending,
  cancelled,
  completed,
}

/// Legal Case Model
class LegalCase {
  final String id;
  final String title;
  final String description;
  final LegalCaseStatus status;
  final String assignedLawyerId;
  final String assignedLawyerName;
  final DateTime filedDate;
  final DateTime? nextHearing;

  LegalCase({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedLawyerId,
    required this.assignedLawyerName,
    required this.filedDate,
    this.nextHearing,
  });
}

enum LegalCaseStatus {
  underReview,
  inCourt,
  settled,
  closed,
}

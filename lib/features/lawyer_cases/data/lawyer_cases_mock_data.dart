import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

enum CaseStatusType { urgent, onTrack, done }

class LawyerCase {
  final String id;
  final String title;
  final String clientName;
  final String category; // Family Law, Criminal, etc.
  final String nextHearing;
  final CaseStatusType status;
  final String statusLabel;

  LawyerCase({
    required this.id,
    required this.title,
    required this.clientName,
    required this.category,
    required this.nextHearing,
    required this.status,
    required this.statusLabel,
  });

  Color get statusColor {
    switch (status) {
      case CaseStatusType.urgent:
        return AppColors.secondary; // Gold
      case CaseStatusType.onTrack:
        return AppColors.primary; // Blue/Navy
      case CaseStatusType.done:
        return AppColors.success; // Green
    }
  }
}

class Consultation {
  final String id;
  final String clientName;
  final String topic;
  final String time;
  final bool isConfirmed;
  final DateTime date;

  Consultation({
    required this.id,
    required this.clientName,
    required this.topic,
    required this.time,
    required this.isConfirmed,
    required this.date,
  });
}

class LawyerCasesMockData {
  static List<LawyerCase> activeCases = [
    LawyerCase(
      id: '#204',
      title: 'Custody Battle - Ali vs Ayesha',
      clientName: 'Ali Khan',
      category: 'Family Law',
      nextHearing: '12 Feb, 2024 at High Court',
      status: CaseStatusType.urgent,
      statusLabel: 'Hearing Tomorrow',
    ),
    LawyerCase(
      id: '#207',
      title: 'Property Dispute in DHA Ph-6',
      clientName: 'Saad Rafique',
      category: 'Property Law',
      nextHearing: '18 Feb, 2024 at Civil Court',
      status: CaseStatusType.onTrack,
      statusLabel: 'Evidence Submission',
    ),
    LawyerCase(
      id: '#210',
      title: 'Corporate Merger Contract Review',
      clientName: 'TechSolutions Inc.',
      category: 'Corporate',
      nextHearing: 'Deadline: 25 Feb, 2024',
      status: CaseStatusType.onTrack,
      statusLabel: 'Drafting',
    ),
  ];

  static List<Consultation> consultations = [
    Consultation(
      id: 'c1',
      clientName: 'Video Call with Sarah J.',
      topic: 'Legal Notice Review',
      time: '10:00 AM - 11:00 AM',
      isConfirmed: true,
      date: DateTime.now(),
    ),
    Consultation(
      id: 'c2',
      clientName: 'In-Person with Mr. Bilal',
      topic: 'New Case Discussion',
      time: '02:00 PM - 03:00 PM',
      isConfirmed: true,
      date: DateTime.now(),
    ),
    Consultation(
      id: 'c3',
      clientName: 'Call with Ahmed Raza',
      topic: 'Case Update',
      time: '04:30 PM - 05:00 PM',
      isConfirmed: false,
      date: DateTime.now(),
    ),
    Consultation(
      id: 'c4',
      clientName: 'Video Call with Zainab',
      topic: 'Consultation',
      time: '11:00 AM - 11:30 AM',
      isConfirmed: true,
      date: DateTime.now().add(const Duration(days: 1)),
    ),
  ];
}

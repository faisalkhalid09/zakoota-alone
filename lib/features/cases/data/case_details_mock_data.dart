/// Mock data for case details
class CaseDetailsMockData {
  static Map<String, dynamic> getCaseDetails(String caseId) {
    // For now, just return details for Case #204
    if (caseId == '204') {
      return {
        'id': '204',
        'title': 'Property Dispute Resolution',
        'status': 'In Court Hearing',
        'category': 'Property Law',
        'filedDate': DateTime(2024, 1, 1),
        'description':
            'Dispute regarding the ownership of a commercial property in Gulberg, Lahore. The case involves multiple stakeholders and requires detailed documentation of property records dating back 20 years.',
        'lawyerId': 'lawyer_1',
        'lawyerName': 'Adv. Sarah Ahmed',
        'lawyerAvatar': 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
        'nextHearing': {
          'date': DateTime.now().add(const Duration(days: 1)),
          'time': '10:00 AM',
          'venue': 'Lahore High Court',
          'room': 'Room 4',
        },
        'timeline': [
          {
            'title': 'Case Filed',
            'description': 'Initial case documentation submitted',
            'date': DateTime(2024, 1, 1),
            'isCompleted': true,
          },
          {
            'title': 'Lawyer Hired',
            'description': 'Adv. Sarah Ahmed assigned to the case',
            'date': DateTime(2024, 1, 2),
            'isCompleted': true,
          },
          {
            'title': 'Documents Verified',
            'description': 'All property documents verified and submitted',
            'date': DateTime(2024, 1, 5),
            'isCompleted': true,
          },
          {
            'title': 'Court Hearing',
            'description': 'First hearing scheduled',
            'date': DateTime.now().add(const Duration(days: 1)),
            'isCompleted': false,
            'isCurrent': true,
          },
          {
            'title': 'Judgment',
            'description': 'Final verdict pending',
            'date': null,
            'isCompleted': false,
            'isCurrent': false,
          },
        ],
        'documents': [
          {
            'name': 'Property Deed.pdf',
            'type': 'PDF',
            'size': '2.4 MB',
            'uploadedDate': DateTime(2024, 1, 1),
          },
          {
            'name': 'ID Proof.pdf',
            'type': 'PDF',
            'size': '1.1 MB',
            'uploadedDate': DateTime(2024, 1, 1),
          },
          {
            'name': 'Ownership Certificate.pdf',
            'type': 'PDF',
            'size': '3.2 MB',
            'uploadedDate': DateTime(2024, 1, 3),
          },
          {
            'name': 'Court Notice.pdf',
            'type': 'PDF',
            'size': '856 KB',
            'uploadedDate': DateTime(2024, 1, 5),
          },
        ],
      };
    } else if (caseId == 'C205') {
      return {
        'id': 'C205',
        'title': 'Property Dispute',
        'status': 'In Court Hearing',
        'category': 'Property Law',
        'filedDate': DateTime(2025, 11, 20),
        'description':
            'Inheritance property claim case involving commercial land dispute. Requires verification of ancestral records and title deeds.',
        'lawyerId': 'L004',
        'lawyerName': 'Adv. Ali Khan',
        'lawyerAvatar': 'https://api.dicebear.com/7.x/avataaars/png?seed=Ali',
        'nextHearing': {
          'date': DateTime(2026, 2, 18),
          'time': '09:00 AM',
          'venue': 'Civil Court',
          'room': 'Room 12',
        },
        'timeline': [
          {
            'title': 'Case Filed',
            'description': 'Initial petition submitted to court',
            'date': DateTime(2025, 11, 20),
            'isCompleted': true,
          },
          {
            'title': 'Documents Verified',
            'description': 'Title deeds verified by registrar',
            'date': DateTime(2025, 12, 10),
            'isCompleted': true,
          },
        ],
        'documents': [
          {
            'name': 'Title Deed.pdf',
            'type': 'PDF',
            'size': '4.1 MB',
            'uploadedDate': DateTime(2025, 11, 20),
          },
        ],
      };
    } else if (caseId == 'C187') {
      return {
        'id': 'C187',
        'title': 'Contract Breach',
        'status': 'Under Review',
        'category': 'Corporate Law',
        'filedDate': DateTime(2026, 1, 5),
        'description':
            'Business contract violation dispute regarding supply chain agreement. Claiming damages for breach of exclusivity clause.',
        'lawyerId': 'L001',
        'lawyerName': 'Adv. Sarah Ahmed',
        'lawyerAvatar': 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
        'nextHearing': {
          'date': DateTime(2026, 2, 22),
          'time': '11:00 AM',
          'venue': 'High Court',
          'room': 'Room 5',
        },
        'timeline': [
          {
            'title': 'Case Filed',
            'description': 'Complaint filed against supplier',
            'date': DateTime(2026, 1, 5),
            'isCompleted': true,
          },
        ],
        'documents': [
          {
            'name': 'Contract.pdf',
            'type': 'PDF',
            'size': '1.5 MB',
            'uploadedDate': DateTime(2026, 1, 5),
          },
          {
            'name': 'Notice.pdf',
            'type': 'PDF',
            'size': '500 KB',
            'uploadedDate': DateTime(2026, 1, 15),
          },
        ],
      };
    }

    // Default case if not found
    return {};
  }
}

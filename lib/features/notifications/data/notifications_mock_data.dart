/// Mock data for notifications
class NotificationsMockData {
  static List<Map<String, dynamic>> getNotifications() {
    final now = DateTime.now();

    return [
      // Today
      {
        'id': '1',
        'type': 'hearing',
        'title': 'Court Hearing Tomorrow',
        'message': 'Case #204 hearing scheduled for tomorrow at 10:00 AM',
        'timestamp': now.subtract(const Duration(hours: 1)),
        'isRead': false,
        'caseId': '204',
      },
      {
        'id': '2',
        'type': 'message',
        'title': 'New Message from Adv. Sarah Ahmed',
        'message': 'I have reviewed your case documents and have some updates.',
        'timestamp': now.subtract(const Duration(hours: 2)),
        'isRead': false,
        'lawyerId': 'lawyer_1',
      },
      {
        'id': '3',
        'type': 'document',
        'title': 'Document Verified',
        'message': 'Your CNIC document has been approved for Case #204.',
        'timestamp': now.subtract(const Duration(hours: 4)),
        'isRead': true,
        'caseId': '204',
      },

      // Yesterday
      {
        'id': '4',
        'type': 'payment',
        'title': 'Payment Received',
        'message': 'PKR 5,000 consultation fee payment confirmed.',
        'timestamp': now.subtract(const Duration(days: 1)),
        'isRead': true,
      },
      {
        'id': '5',
        'type': 'case_update',
        'title': 'Case Status Updated',
        'message': 'Case #204 status changed to "In Court Hearing"',
        'timestamp': now.subtract(const Duration(days: 1, hours: 3)),
        'isRead': true,
        'caseId': '204',
      },

      // Earlier
      {
        'id': '6',
        'type': 'lawyer_assigned',
        'title': 'Lawyer Assigned',
        'message': 'Adv. Sarah Ahmed has been assigned to your case.',
        'timestamp': now.subtract(const Duration(days: 3)),
        'isRead': true,
        'lawyerId': 'lawyer_1',
      },
      {
        'id': '7',
        'type': 'case_filed',
        'title': 'Case Filed Successfully',
        'message': 'Your case #204 has been filed and is now in process.',
        'timestamp': now.subtract(const Duration(days: 5)),
        'isRead': true,
        'caseId': '204',
      },
    ];
  }

  static int getUnreadCount() {
    return getNotifications().where((n) => !n['isRead']).length;
  }
}

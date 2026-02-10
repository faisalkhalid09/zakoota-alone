import '../../cases/models/case_model.dart';

class JobOpportunity {
  final String id;
  final String title;
  final String description;
  final String location;
  final String budgetLabel;
  final int proposalCount;
  final double clientRating;
  final String postedAgo;
  final String activity;
  final List<String> attachments;
  final String clientId; // Added clientId
  final String category;

  const JobOpportunity({
    required this.id,
    required this.clientId, // Required
    required this.title,
    required this.description,
    required this.location,
    required this.budgetLabel,
    required this.proposalCount,
    required this.clientRating,
    required this.postedAgo,
    required this.activity,
    required this.attachments,
    required this.category,
  });

  factory JobOpportunity.fromCaseModel(CaseModel caseModel) {
    // Calculate posted ago
    final now = DateTime.now();
    final difference = now.difference(caseModel.createdAt);
    String timeAgo;

    if (difference.inDays > 0) {
      timeAgo = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes}m ago';
    } else {
      timeAgo = 'Just now';
    }

    // Format budget
    String budget;
    if (caseModel.budgetMin == caseModel.budgetMax) {
      budget = 'Budget: ${caseModel.budgetMin.toInt()}';
    } else {
      budget =
          'Budget: ${caseModel.budgetMin.toInt()} - ${caseModel.budgetMax.toInt()}';
    }

    return JobOpportunity(
      id: caseModel.caseId,
      clientId: caseModel.clientId, // Map clientId
      title: caseModel.title,
      description: caseModel.description,
      location: caseModel.city,
      budgetLabel: budget,
      proposalCount: caseModel.proposalCount,
      clientRating: 0.0, // Placeholder, fetch if available
      postedAgo: timeAgo,
      activity: '${caseModel.proposalCount} Proposals',
      attachments: caseModel.attachments.map((a) => a.title).toList(),
      category: caseModel.category,
    );
  }
}

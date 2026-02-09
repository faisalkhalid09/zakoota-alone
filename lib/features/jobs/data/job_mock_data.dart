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

  const JobOpportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.budgetLabel,
    required this.proposalCount,
    required this.clientRating,
    required this.postedAgo,
    required this.activity,
    required this.attachments,
  });
}

class JobMockData {
  static const List<JobOpportunity> jobs = [
    JobOpportunity(
      id: 'job-001',
      title: 'Property Dispute in DHA',
      description:
          'Seeking legal counsel for a property dispute involving joint ownership and inheritance claims in DHA. Need representation for court filings and hearings.',
      location: 'Lahore',
      budgetLabel: 'Budget: 100k',
      proposalCount: 12,
      clientRating: 5.0,
      postedAgo: '2m ago',
      activity: '5 Proposals received',
      attachments: ['Sale Deed.pdf', 'Property Photos.zip'],
    ),
    JobOpportunity(
      id: 'job-002',
      title: 'Corporate Contract Review',
      description:
          'Need a lawyer to review and negotiate a supplier agreement with international clauses and arbitration terms.',
      location: 'Karachi',
      budgetLabel: 'Budget: 80k',
      proposalCount: 7,
      clientRating: 4.8,
      postedAgo: '15m ago',
      activity: '2 Proposals received',
      attachments: ['Draft Agreement.docx'],
    ),
    JobOpportunity(
      id: 'job-003',
      title: 'Criminal Defense Consultation',
      description:
          'Urgent consultation required for a criminal defense case. Client needs advice on next hearing and bail status.',
      location: 'Islamabad',
      budgetLabel: 'Budget: 120k',
      proposalCount: 18,
      clientRating: 4.9,
      postedAgo: '40m ago',
      activity: '8 Proposals received',
      attachments: [],
    ),
    JobOpportunity(
      id: 'job-004',
      title: 'Family Law Custody Matter',
      description:
          'Looking for representation for a custody dispute. Prefer someone experienced with family court proceedings.',
      location: 'Rawalpindi',
      budgetLabel: 'Budget: 60k',
      proposalCount: 5,
      clientRating: 4.7,
      postedAgo: '1h ago',
      activity: '1 Proposal received',
      attachments: ['Custody Petition.pdf'],
    ),
    JobOpportunity(
      id: 'job-005',
      title: 'Tax Filing Dispute',
      description:
          'Need a tax lawyer to handle a dispute with authorities over recent filings and penalties.',
      location: 'Faisalabad',
      budgetLabel: 'Budget: 90k',
      proposalCount: 9,
      clientRating: 4.6,
      postedAgo: '2h ago',
      activity: '3 Proposals received',
      attachments: ['Tax Notices.pdf', 'Penalty Letter.pdf'],
    ),
  ];

  static JobOpportunity? getById(String id) {
    for (final job in jobs) {
      if (job.id == id) return job;
    }
    return null;
  }
}

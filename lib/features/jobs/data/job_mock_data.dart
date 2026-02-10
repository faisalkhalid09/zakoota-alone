import '../models/job_opportunity.dart';

class JobMockData {
  static const List<JobOpportunity> jobs = [
    JobOpportunity(
      id: 'job-001',
      clientId: 'mock_client_1',
      title: 'Legal Counsel for Tech Startup',
      description:
          'We are a fast-growing tech startup looking for a legal counsel to help us with intellectual property, contracts, and compliance. Experience in the tech industry is a plus.',
      location: 'Remote',
      budgetLabel: 'PKR 150k - 200k',
      proposalCount: 5,
      clientRating: 4.8,
      postedAgo: '2h ago',
      activity: '5 Proposals',
      attachments: [],
      category: 'Corporate',
    ),
    JobOpportunity(
      id: '2',
      clientId: 'mock_client_2',
      title: 'Divorce Attorney Needed',
      description:
          'Seeking an experienced divorce attorney to handle a contested divorce case involving child custody and asset division. Must be compassionate and aggressive when needed.',
      location: 'Lahore',
      budgetLabel: 'PKR 50k',
      proposalCount: 12,
      clientRating: 4.5,
      postedAgo: '5h ago',
      activity: '12 Proposals',
      attachments: [],
      category: 'Family',
    ),
    JobOpportunity(
      id: '3',
      clientId: 'mock_client_3',
      title: 'Criminal Defense Lawyer',
      description:
          'Looking for a criminal defense lawyer to represent a client in a theft case. The trial is scheduled for next month. Previous experience with similar cases is required.',
      location: 'Karachi',
      budgetLabel: 'PKR 100k',
      proposalCount: 8,
      clientRating: 4.2,
      postedAgo: '1d ago',
      activity: '8 Proposals',
      attachments: [],
      category: 'Criminal',
    ),
    JobOpportunity(
      id: '4',
      clientId: 'mock_client_4',
      title: 'Property Dispute Resolution',
      description:
          'Need a lawyer to help resolve a property dispute between family members. The property is located in Islamabad. The ideal candidate should have expertise in property law.',
      location: 'Islamabad',
      budgetLabel: 'PKR 80k - 120k',
      proposalCount: 3,
      clientRating: 4.0,
      postedAgo: '2d ago',
      activity: '3 Proposals',
      attachments: [],
      category: 'Property',
    ),
    JobOpportunity(
      id: '5',
      clientId: 'mock_client_5',
      title: 'Contract Review',
      description:
          'I need a lawyer to review a business contract before I sign it. It is a partnership agreement. I want to make sure my interests are protected.',
      location: 'Remote',
      budgetLabel: 'PKR 20k',
      proposalCount: 15,
      clientRating: 4.9,
      postedAgo: '3d ago',
      activity: '15 Proposals',
      attachments: [],
      category: 'Corporate',
    ),
  ];

  static JobOpportunity? getById(String id) {
    for (final job in jobs) {
      if (job.id == id) return job;
    }
    return null;
  }
}

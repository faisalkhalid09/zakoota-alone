class LawyerDashboardMockData {
  static const List<PerformanceStat> performanceStats = [
    PerformanceStat(
      title: 'Total Earnings',
      value: 'PKR 150,000',
      highlight: true,
    ),
    PerformanceStat(
      title: 'Active Cases',
      value: '5',
      highlight: false,
    ),
    PerformanceStat(
      title: 'Success Rate',
      value: '98%',
      highlight: false,
    ),
  ];

  static const String urgentTask = 'Hearing Tomorrow: Case #204 vs State';

  static const List<LeadRequest> leads = [
    LeadRequest(
      jobId: 'job-001',
      title: 'Property Dispute in DHA',
      budget: 'Budget: 100k',
      postedAgo: 'Posted 2m ago',
    ),
    LeadRequest(
      jobId: 'job-002',
      title: 'Corporate Contract Review',
      budget: 'Budget: 80k',
      postedAgo: 'Posted 15m ago',
    ),
  ];

  static const List<ActiveAd> activeAds = [
    ActiveAd(
      title: 'Criminal Defense GIG',
      views: '1.2k',
      clicks: '45',
      status: 'Active',
    ),
    ActiveAd(
      title: 'Family Law Consultation',
      views: '820',
      clicks: '31',
      status: 'Paused',
    ),
  ];
}

class PerformanceStat {
  final String title;
  final String value;
  final bool highlight;

  const PerformanceStat({
    required this.title,
    required this.value,
    required this.highlight,
  });
}

class LeadRequest {
  final String jobId;
  final String title;
  final String budget;
  final String postedAgo;

  const LeadRequest({
    required this.jobId,
    required this.title,
    required this.budget,
    required this.postedAgo,
  });
}

class ActiveAd {
  final String title;
  final String views;
  final String clicks;
  final String status;

  const ActiveAd({
    required this.title,
    required this.views,
    required this.clicks,
    required this.status,
  });
}

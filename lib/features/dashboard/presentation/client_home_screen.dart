import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_constants.dart';

/// Client Home Screen - Main dashboard for clients
class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  Future<void> _onRefresh() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard refreshed'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.secondary,
        child: CustomScrollView(
          slivers: [
            // A. SLIVER APP BAR - Header
            _buildSliverAppBar(context),

            // B. PRIORITY ACTION CARD
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _PriorityActionCard(
                  data: ClientHomeData.priorityAction,
                ),
              ),
            ),

            // C. ACTIVE CASES - Horizontal Scroll
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Cases',
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/client-cases');
                          },
                          child: Text(
                            'View All',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      itemCount: ClientHomeData.activeCases.length,
                      itemBuilder: (context, index) {
                        return _ActiveCaseCard(
                          caseData: ClientHomeData.activeCases[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),

            // D. SERVICES GRID
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Legal Services',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      children: ClientHomeData.services.map((service) {
                        return _ServiceItem(service: service);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // E. RECENT ACTIVITY - Vertical List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  'Recent Updates',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _RecentActivityTile(
                    activity: ClientHomeData.recentActivities[index],
                  );
                },
                childCount: ClientHomeData.recentActivities.length,
              ),
            ),

            // Bottom Padding
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: const NetworkImage(
            'https://i.pravatar.cc/150?img=11',
          ),
          backgroundColor: AppColors.grey200,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning,',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            'Ali Khan',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        // Wallet Chip
        GestureDetector(
          onTap: () {
            context.push('/wallet');
          },
          child: Container(
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              children: [
                PhosphorIcon(
                  PhosphorIconsRegular.wallet,
                  color: colorScheme.secondary,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'PKR 5,000',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Notification Icon with Badge
        Stack(
          children: [
            IconButton(
              icon: PhosphorIcon(
                PhosphorIconsRegular.bell,
                color: colorScheme.primary,
              ),
              onPressed: () {
                context.push('/notifications');
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}

/// Priority Action Card Widget
class _PriorityActionCard extends StatelessWidget {
  final PriorityActionData data;

  const _PriorityActionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Icon
          Positioned(
            right: -20,
            top: -20,
            child: PhosphorIcon(
              PhosphorIconsRegular.gavel,
              size: 140,
              color: Colors.white.withOpacity(0.1),
            ),
          ),

          // Content
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      data.subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/case-details/204');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Active Case Card Widget
class _ActiveCaseCard extends StatelessWidget {
  final ActiveCaseData caseData;

  const _ActiveCaseCard({required this.caseData});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Case ID
          Text(
            caseData.caseId,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Lawyer Info
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(caseData.lawyerAvatar),
                backgroundColor: AppColors.grey200,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  caseData.lawyerName,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Progress
          Text(
            'Status: ${caseData.status}',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          LinearProgressIndicator(
            value: caseData.progress,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}

/// Service Item Widget
class _ServiceItem extends StatelessWidget {
  final ServiceData service;

  const _ServiceItem({required this.service});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // Navigate to lawyer search with category filter
        context.push('/lawyer-search?category=${service.name}');
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.grey200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIcon(
              service.icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              service.name,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Recent Activity Tile Widget
class _RecentActivityTile extends StatelessWidget {
  final RecentActivityData activity;

  const _RecentActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            // Leading Icon
            CircleAvatar(
              backgroundColor: activity.iconColor.withOpacity(0.1),
              child: PhosphorIcon(
                activity.icon,
                color: activity.iconColor,
                size: 20,
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Time
            Text(
              activity.time,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textLight,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    // Navigate based on activity title/type
    if (activity.title.contains('Message')) {
      // Navigate to chat with the lawyer mentioned
      context.push('/chat/lawyer_1', extra: {
        'lawyerName': 'Adv. Sarah Ahmed',
        'lawyerId': 'lawyer_1',
        'isOnline': true,
        'lawyerAvatar': 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      });
    } else if (activity.title.contains('Hearing') ||
        activity.title.contains('Case')) {
      // Navigate to case details for Case #204
      final caseIdMatch = RegExp(r'#(\d+)').firstMatch(activity.subtitle);
      if (caseIdMatch != null) {
        final caseId = caseIdMatch.group(1);
        context.push('/case-details/$caseId');
      }
    } else if (activity.title.contains('Document')) {
      // Navigate to case details for the document
      final caseIdMatch = RegExp(r'#([\w-]+)').firstMatch(activity.subtitle);
      if (caseIdMatch != null) {
        final caseId = caseIdMatch.group(1)?.replaceAll('CHD-', '');
        if (caseId != null) {
          context.push('/case-details/$caseId');
        }
      }
    }
  }
}

// ============================================================================
// MOCK DATA MODELS
// ============================================================================

class ClientHomeData {
  static final PriorityActionData priorityAction = PriorityActionData(
    title: 'Hearing Tomorrow!',
    subtitle: 'Case #204 vs State',
  );

  static final List<ActiveCaseData> activeCases = [
    ActiveCaseData(
      caseId: '#CHD-2023',
      lawyerName: 'Adv. Sarah Ahmed',
      lawyerAvatar: 'https://i.pravatar.cc/150?img=5',
      status: 'Evidence',
      progress: 0.7,
    ),
    ActiveCaseData(
      caseId: '#CHD-2024',
      lawyerName: 'Adv. Hassan Ali',
      lawyerAvatar: 'https://i.pravatar.cc/150?img=12',
      status: 'Hearing',
      progress: 0.45,
    ),
    ActiveCaseData(
      caseId: '#CHD-2025',
      lawyerName: 'Adv. Fatima Khan',
      lawyerAvatar: 'https://i.pravatar.cc/150?img=9',
      status: 'Discovery',
      progress: 0.3,
    ),
  ];

  static final List<ServiceData> services = [
    ServiceData(name: 'Criminal', icon: PhosphorIconsRegular.shield),
    ServiceData(name: 'Property', icon: PhosphorIconsRegular.house),
    ServiceData(name: 'Family', icon: PhosphorIconsRegular.users),
    ServiceData(name: 'Corporate', icon: PhosphorIconsRegular.briefcase),
    ServiceData(name: 'Civil', icon: PhosphorIconsRegular.scales),
    ServiceData(name: 'Startups', icon: PhosphorIconsRegular.rocket),
  ];

  static final List<RecentActivityData> recentActivities = [
    RecentActivityData(
      icon: PhosphorIconsRegular.check,
      iconColor: AppColors.success,
      title: 'Document Verified',
      subtitle: 'Your CNIC was approved.',
      time: '2m ago',
    ),
    RecentActivityData(
      icon: PhosphorIconsRegular.chatCircle,
      iconColor: AppColors.info,
      title: 'New Message',
      subtitle: 'Adv. Sarah sent you a message.',
      time: '1h ago',
    ),
    RecentActivityData(
      icon: PhosphorIconsRegular.calendar,
      iconColor: AppColors.warning,
      title: 'Hearing Scheduled',
      subtitle: 'Case #204 - Feb 8, 2026 at 10:00 AM',
      time: '3h ago',
    ),
    RecentActivityData(
      icon: PhosphorIconsRegular.fileText,
      iconColor: AppColors.secondary,
      title: 'Document Uploaded',
      subtitle: 'Evidence.pdf added to Case #CHD-2023',
      time: '5h ago',
    ),
  ];
}

class PriorityActionData {
  final String title;
  final String subtitle;

  PriorityActionData({
    required this.title,
    required this.subtitle,
  });
}

class ActiveCaseData {
  final String caseId;
  final String lawyerName;
  final String lawyerAvatar;
  final String status;
  final double progress;

  ActiveCaseData({
    required this.caseId,
    required this.lawyerName,
    required this.lawyerAvatar,
    required this.status,
    required this.progress,
  });
}

class ServiceData {
  final String name;
  final PhosphorIconData icon;

  ServiceData({
    required this.name,
    required this.icon,
  });
}

class RecentActivityData {
  final PhosphorIconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  RecentActivityData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

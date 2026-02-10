import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../data/lawyer_profile_mock_data.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/auth_service.dart';

class LawyerProfileScreen extends StatefulWidget {
  const LawyerProfileScreen({super.key});

  @override
  State<LawyerProfileScreen> createState() => _LawyerProfileScreenState();
}

class _LawyerProfileScreenState extends State<LawyerProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isAcceptingCase = LawyerProfileMockData.isAcceptingCases;

  Future<void> _handleLogout() async {
    debugPrint('Logout button pressed');
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        debugPrint('Building Logout Dialog');
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout',
                  style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      if (!mounted) return;
      await _authService.signOut();
      if (!mounted) return;
      context.go('/login?role=lawyer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section (Navy Background)
            _buildHeader(),

            // Availability Switch (Floating Card)
            Transform.translate(
              offset: const Offset(0, -30),
              child: _buildAvailabilityCard(),
            ),

            // Menu Groups
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  _buildMenuGroup(
                    title: 'Practice Management',
                    items: [
                      _MenuItem(
                        icon: PhosphorIconsRegular.wallet,
                        title: 'My Wallet & Earnings',
                        iconColor: AppColors.primary,
                        onTap: () {}, // Link to Wallet
                      ),
                      _MenuItem(
                        icon: PhosphorIconsRegular.megaphone,
                        title: 'Manage Gigs / Ads',
                        iconColor: AppColors.secondary,
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: PhosphorIconsRegular.shieldCheck,
                        title: 'Verification Status',
                        iconColor: AppColors.success,
                        subtitle: 'Verified',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildMenuGroup(
                    title: 'Account Settings',
                    items: [
                      _MenuItem(
                        icon: PhosphorIconsRegular.pencilSimple,
                        title: 'Edit Profile',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: PhosphorIconsRegular.bell,
                        title: 'Notifications',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: PhosphorIconsRegular.lockKey,
                        title: 'Security & Password',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildMenuGroup(
                    title: 'Support',
                    items: [
                      _MenuItem(
                        icon: PhosphorIconsRegular.question,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: PhosphorIconsRegular.signOut,
                        title: 'Logout',
                        iconColor: AppColors.error,
                        textColor: AppColors.error,
                        hideChevron: true,
                        onTap: _handleLogout,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 60, AppSpacing.lg,
          60), // Extra bottom padding for overlap
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.secondary, width: 4),
            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.grey200,
              child: Icon(PhosphorIconsRegular.user,
                  size: 50, color: AppColors.textSecondary),
              // backgroundImage: NetworkImage('...'), // Placeholder
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Identity
          Text(
            LawyerProfileMockData.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              LawyerProfileMockData.badge,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            LawyerProfileMockData.location,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat(PhosphorIconsFill.star, LawyerProfileMockData.rating,
                  'Rating'),
              _buildDivider(),
              _buildStat(PhosphorIconsRegular.briefcase,
                  LawyerProfileMockData.cases, 'Cases'),
              _buildDivider(),
              _buildStat(PhosphorIconsRegular.medal,
                  LawyerProfileMockData.experience, 'Exp'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(icon, color: AppColors.secondary, size: 20),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.white.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    );
  }

  Widget _buildAvailabilityCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.sm), // Inner padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SwitchListTile(
        value: _isAcceptingCase,
        activeColor: AppColors.success,
        title: const Text(
          'Accepting New Cases',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: const Text(
          'Turn off to hide your profile from search.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isAcceptingCase
                ? AppColors.success.withOpacity(0.1)
                : AppColors.grey100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            PhosphorIconsRegular.briefcase,
            color:
                _isAcceptingCase ? AppColors.success : AppColors.textSecondary,
          ),
        ),
        onChanged: (val) {
          setState(() {
            _isAcceptingCase = val;
          });
        },
      ),
    );
  }

  Widget _buildMenuGroup(
      {required String title, required List<_MenuItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            children: items.map((item) {
              final isLast = items.last == item;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (item.iconColor ?? AppColors.textSecondary)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.iconColor ?? AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: item.textColor ?? AppColors.textPrimary,
                      ),
                    ),
                    subtitle: item.subtitle != null
                        ? Text(
                            item.subtitle!,
                            style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          )
                        : null,
                    trailing: item.hideChevron
                        ? null
                        : const Icon(PhosphorIconsRegular.caretRight,
                            size: 16, color: AppColors.grey400),
                    onTap: item.onTap,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  ),
                  if (!isLast) const Divider(height: 1, indent: 60),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? subtitle;
  final Color? iconColor;
  final Color? textColor;
  final bool hideChevron;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.iconColor,
    this.textColor,
    this.hideChevron = false,
  });
}

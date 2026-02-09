import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../data/lawyer_mock_data.dart';

/// Lawyer Search Screen - Find and filter lawyers
class LawyerSearchScreen extends StatefulWidget {
  final String? category;

  const LawyerSearchScreen({
    super.key,
    this.category,
  });

  @override
  State<LawyerSearchScreen> createState() => _LawyerSearchScreenState();
}

class _LawyerSearchScreenState extends State<LawyerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LawyerProfile> _filteredLawyers = [];
  bool _verifiedOnly = false;
  bool _highRating = false;
  String _sortBy = '';

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredLawyers = LawyerMockData.searchLawyers(
        category: widget.category,
        query: _searchController.text,
        verifiedOnly: _verifiedOnly,
        minRating: _highRating ? 4.5 : null,
      );

      // Sort if needed
      if (_sortBy == 'price_low') {
        _filteredLawyers.sort(
            (a, b) => a.pricePerConsultation.compareTo(b.pricePerConsultation));
      } else if (_sortBy == 'rating') {
        _filteredLawyers.sort((a, b) => b.rating.compareTo(a.rating));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Find a Lawyer',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: PhosphorIcon(
            PhosphorIconsRegular.arrowLeft,
            color: colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilters(),
              decoration: InputDecoration(
                hintText: 'Search by name or keyword',
                prefixIcon: PhosphorIcon(
                  PhosphorIconsRegular.magnifyingGlass,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),

          // Filter Chips
          Container(
            height: 50,
            color: AppColors.surface,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                FilterChip(
                  label: const Text('Verified'),
                  selected: _verifiedOnly,
                  onSelected: (value) {
                    setState(() => _verifiedOnly = value);
                    _applyFilters();
                  },
                  selectedColor: AppColors.secondary.withOpacity(0.2),
                  checkmarkColor: AppColors.secondary,
                  side: BorderSide(
                    color:
                        _verifiedOnly ? AppColors.secondary : AppColors.grey300,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: const Text('Price: Low-High'),
                  selected: _sortBy == 'price_low',
                  onSelected: (value) {
                    setState(() => _sortBy = value ? 'price_low' : '');
                    _applyFilters();
                  },
                  selectedColor: AppColors.secondary.withOpacity(0.2),
                  checkmarkColor: AppColors.secondary,
                  side: BorderSide(
                    color: _sortBy == 'price_low'
                        ? AppColors.secondary
                        : AppColors.grey300,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: const Text('Rating 4.5+'),
                  selected: _highRating,
                  onSelected: (value) {
                    setState(() => _highRating = value);
                    _applyFilters();
                  },
                  selectedColor: AppColors.secondary.withOpacity(0.2),
                  checkmarkColor: AppColors.secondary,
                  side: BorderSide(
                    color:
                        _highRating ? AppColors.secondary : AppColors.grey300,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: const Text('Experience'),
                  selected: _sortBy == 'experience',
                  onSelected: (value) {
                    setState(() => _sortBy = value ? 'experience' : '');
                    _applyFilters();
                  },
                  selectedColor: AppColors.secondary.withOpacity(0.2),
                  checkmarkColor: AppColors.secondary,
                  side: BorderSide(
                    color: _sortBy == 'experience'
                        ? AppColors.secondary
                        : AppColors.grey300,
                  ),
                ),
              ],
            ),
          ),

          // Results Count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              '${_filteredLawyers.length} lawyers found${widget.category != null ? ' in ${widget.category}' : ''}',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // Lawyer List
          Expanded(
            child: _filteredLawyers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PhosphorIcon(
                          PhosphorIconsRegular.magnifyingGlass,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No lawyers found',
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _filteredLawyers.length,
                    itemBuilder: (context, index) {
                      return LawyerSearchCard(
                        lawyer: _filteredLawyers[index],
                        onTap: () {
                          context.push(
                            '/lawyer-profile/${_filteredLawyers[index].id}',
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Lawyer Search Card Widget
class LawyerSearchCard extends StatelessWidget {
  final LawyerProfile lawyer;
  final VoidCallback onTap;

  const LawyerSearchCard({
    super.key,
    required this.lawyer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Avatar + Name + Title + Location
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(lawyer.photoUrl),
                backgroundColor: AppColors.grey200,
              ),
              const SizedBox(width: AppSpacing.md),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lawyer.name,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        if (lawyer.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PhosphorIcon(
                                  PhosphorIconsRegular.seal,
                                  size: 12,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Verified',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppColors.success,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lawyer.title,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        PhosphorIcon(
                          PhosphorIconsRegular.mapPin,
                          size: 14,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          lawyer.location,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Row 2: Specialization Badges
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: lawyer.specializations.take(3).map((spec) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  spec,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.md),

          // Row 3: Stats + Price
          Row(
            children: [
              // Stats
              Row(
                children: [
                  PhosphorIcon(
                    PhosphorIconsFill.star,
                    size: 16,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${lawyer.rating}',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '• ${lawyer.reviewCount} Reviews',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Price
              Text(
                'PKR ${lawyer.pricePerConsultation.toStringAsFixed(0)}/consult',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Row 4: View Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              ),
              child: const Text('View Profile'),
            ),
          ),
        ],
      ),
    );
  }
}

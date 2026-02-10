import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_constants.dart';
import '../../models/proposal.dart';

class ProposalCard extends StatefulWidget {
  final Proposal proposal;
  final String caseId; // Needed for delete/update
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProposalCard({
    super.key,
    required this.proposal,
    required this.caseId,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ProposalCard> createState() => _ProposalCardState();
}

class _ProposalCardState extends State<ProposalCard> {
  bool _isExpanded = false;
  static const int _truncateLength = 150;
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  bool get _isOwner => widget.proposal.lawyerId == _currentUserId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLongText = widget.proposal.coverLetter.length > _truncateLength;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Lawyer Info & Actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: Container(
                  width: 40,
                  height: 40,
                  color: AppColors.grey200,
                  child: widget.proposal.lawyerImage.isNotEmpty
                      ? Image.network(
                          widget.proposal.lawyerImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person,
                                color: AppColors.grey500, size: 24);
                          },
                        )
                      : const Icon(Icons.person,
                          color: AppColors.grey500, size: 24),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.proposal.lawyerName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          widget.proposal.rating.toString(),
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '•  ${widget.proposal.location}',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(widget.proposal.createdAt),
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
                      fontSize: 10,
                    ),
                  ),
                  if (_isOwner) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ActionButton(
                          icon: PhosphorIconsRegular.pencilSimple,
                          onTap: widget.onEdit,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          icon: PhosphorIconsRegular.trash,
                          onTap: widget.onDelete,
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),

          // Proposal Details Summary
          Row(
            children: [
              _ProposalStat(
                label: 'Bid Amount',
                value:
                    'PKR ${(widget.proposal.bidAmount / 1000).toStringAsFixed(1)}k',
                icon: PhosphorIconsRegular.currencyDollar,
              ),
              const SizedBox(width: AppSpacing.xl),
              _ProposalStat(
                label: 'Duration',
                value: widget.proposal.duration,
                icon: PhosphorIconsRegular.clock,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Cover Letter
          Text(
            'Cover Letter',
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          if (isLongText && !_isExpanded) ...[
            Stack(
              children: [
                Text(
                  widget.proposal.coverLetter,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            )
          ] else
            Text(
              widget.proposal.coverLetter,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

          if (isLongText)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _isExpanded ? 'Show Less' : 'More',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _ProposalStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProposalStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textLight),
            const SizedBox(width: 4),
            Text(label,
                style:
                    const TextStyle(fontSize: 10, color: AppColors.textLight)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

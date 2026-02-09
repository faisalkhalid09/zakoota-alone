import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../data/notifications_mock_data.dart';

/// Notifications Screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<Map<String, dynamic>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = NotificationsMockData.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Group notifications
    final today = _getNotificationsForToday();
    final earlier = _getNotificationsEarlier();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          'Notifications',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Mark all read',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // Today Section
                if (today.isNotEmpty) ...[
                  Text(
                    'Today',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...today.map((notification) => _NotificationCard(
                        notification: notification,
                        onTap: () => _handleNotificationTap(notification),
                        onDismiss: () =>
                            _dismissNotification(notification['id']),
                      )),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Earlier Section
                if (earlier.isNotEmpty) ...[
                  Text(
                    'Earlier',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...earlier.map((notification) => _NotificationCard(
                        notification: notification,
                        onTap: () => _handleNotificationTap(notification),
                        onDismiss: () =>
                            _dismissNotification(notification['id']),
                      )),
                ],
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhosphorIcon(
            PhosphorIconsRegular.bellSlash,
            size: 80,
            color: AppColors.grey300,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No notifications',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'You\'re all caught up!',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getNotificationsForToday() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    return notifications
        .where((n) => (n['timestamp'] as DateTime).isAfter(todayStart))
        .toList();
  }

  List<Map<String, dynamic>> _getNotificationsEarlier() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    return notifications
        .where((n) => (n['timestamp'] as DateTime).isBefore(todayStart))
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _dismissNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n['id'] == id);
    });
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Mark as read
    setState(() {
      notification['isRead'] = true;
    });

    // Navigate based on type
    final type = notification['type'];

    if (type == 'hearing' || type == 'case_update' || type == 'case_filed') {
      final caseId = notification['caseId'];
      if (caseId != null) {
        context.push('/case-details/$caseId');
      }
    } else if (type == 'message') {
      final lawyerId = notification['lawyerId'];
      if (lawyerId != null) {
        context.push('/chat/$lawyerId', extra: {
          'lawyerName': 'Adv. Sarah Ahmed',
          'lawyerId': lawyerId,
          'isOnline': true,
          'lawyerAvatar':
              'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
        });
      }
    } else if (type == 'payment') {
      context.push('/wallet');
    }
  }
}

/// Notification Card Widget
class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isRead = notification['isRead'] as bool;
    final timestamp = notification['timestamp'] as DateTime;
    final type = notification['type'] as String;

    return Dismissible(
      key: Key(notification['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: PhosphorIcon(
          PhosphorIconsRegular.trash,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismiss(),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color:
              isRead ? AppColors.surface : AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isRead
                ? AppColors.grey300
                : AppColors.secondary.withOpacity(0.3),
            width: isRead ? 1 : 2,
          ),
        ),
        child: ListTile(
          onTap: onTap,
          leading: _getNotificationIcon(type),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification['title'],
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                  ),
                ),
              ),
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification['message'],
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(timestamp),
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(AppSpacing.md),
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'hearing':
        icon = PhosphorIconsFill.gavel;
        color = AppColors.error;
        break;
      case 'message':
        icon = PhosphorIconsFill.chatCircleText;
        color = AppColors.info;
        break;
      case 'document':
        icon = PhosphorIconsFill.fileText;
        color = AppColors.secondary;
        break;
      case 'payment':
        icon = PhosphorIconsFill.wallet;
        color = AppColors.success;
        break;
      case 'case_update':
        icon = PhosphorIconsFill.clipboard;
        color = AppColors.warning;
        break;
      case 'lawyer_assigned':
        icon = PhosphorIconsFill.userCircle;
        color = AppColors.primary;
        break;
      case 'case_filed':
        icon = PhosphorIconsFill.checkCircle;
        color = AppColors.success;
        break;
      default:
        icon = PhosphorIconsFill.bell;
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: PhosphorIcon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(timestamp);
    }
  }
}

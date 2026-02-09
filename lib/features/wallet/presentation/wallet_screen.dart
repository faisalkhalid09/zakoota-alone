import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_constants.dart';
import 'widgets/add_funds_dialog.dart';
import 'widgets/withdraw_dialog.dart';

/// Wallet Screen - View balance and transactions
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(
            PhosphorIconsRegular.arrowLeft,
            color: Colors.white,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Wallet',
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Top Section - Navy Background with Balance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xl,
              horizontal: AppSpacing.lg,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              children: [
                // Balance Display
                Text(
                  'Total Balance',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'PKR ${WalletMockData.balance.toStringAsFixed(2)}',
                  style: textTheme.displaySmall?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const AddFundsDialog(),
                          );
                        },
                        icon: PhosphorIcon(
                          PhosphorIconsRegular.plus,
                          size: 20,
                        ),
                        label: const Text('Add Money'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const WithdrawDialog(),
                          );
                        },
                        icon: PhosphorIcon(
                          PhosphorIconsRegular.bank,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text('Withdraw'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Section - White Container with Transactions
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  topRight: Radius.circular(AppRadius.xl),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'Recent Transactions',
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  // Transactions List
                  Expanded(
                    child: WalletMockData.transactions.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PhosphorIcon(
                                  PhosphorIconsRegular.wallet,
                                  size: 64,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'No transactions yet',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            itemCount: WalletMockData.transactions.length,
                            itemBuilder: (context, index) {
                              return TransactionTile(
                                transaction: WalletMockData.transactions[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Transaction Tile Widget
class TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;

  const TransactionTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isCredit = transaction.type == TransactionType.credit;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          // Leading Icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isCredit
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: PhosphorIcon(
              isCredit
                  ? PhosphorIconsRegular.arrowDown
                  : PhosphorIconsRegular.arrowUp,
              size: 20,
              color: isCredit ? AppColors.success : AppColors.error,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.date,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${isCredit ? '+' : '-'} PKR ${transaction.amount.toStringAsFixed(0)}',
            style: textTheme.titleMedium?.copyWith(
              color: isCredit ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MOCK DATA
// ============================================================================

class WalletMockData {
  static double balance = 15400.00;

  static final List<WalletTransaction> transactions = [
    WalletTransaction(
      title: 'EasyPaisa Deposit',
      date: 'Today, 10:00 AM',
      amount: 5000,
      type: TransactionType.credit,
    ),
    WalletTransaction(
      title: 'Consultation Fee - Adv. Sarah Ahmed',
      date: 'Today, 9:15 AM',
      amount: 3000,
      type: TransactionType.debit,
    ),
    WalletTransaction(
      title: 'JazzCash Deposit',
      date: 'Yesterday, 2:30 PM',
      amount: 10000,
      type: TransactionType.credit,
    ),
    WalletTransaction(
      title: 'Consultation Fee - Adv. Hassan Ali',
      date: 'Feb 3, 3:45 PM',
      amount: 2500,
      type: TransactionType.debit,
    ),
    WalletTransaction(
      title: 'Bank Transfer',
      date: 'Feb 2, 11:20 AM',
      amount: 8000,
      type: TransactionType.credit,
    ),
    WalletTransaction(
      title: 'Document Fee',
      date: 'Feb 1, 4:10 PM',
      amount: 500,
      type: TransactionType.debit,
    ),
  ];
}

enum TransactionType { credit, debit }

class WalletTransaction {
  final String title;
  final String date;
  final double amount;
  final TransactionType type;

  WalletTransaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';

/// Withdraw Dialog - Modal bottom sheet for withdrawing money
class WithdrawDialog extends StatefulWidget {
  const WithdrawDialog({super.key});

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  String _selectedMethod = 'bank';
  bool _isProcessing = false;

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _processWithdrawal() async {
    if (_amountController.text.isEmpty) {
      _showError('Please enter an amount');
      return;
    }

    if (_accountController.text.isEmpty) {
      _showError(_selectedMethod == 'bank'
          ? 'Enter IBAN/Account Number'
          : 'Enter Mobile Number');
      return;
    }

    if (_selectedMethod == 'bank' && _titleController.text.isEmpty) {
      _showError('Enter Account Title');
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Withdrawal Request Submitted - PKR ${_amountController.text}',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isBank = _selectedMethod == 'bank';

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'Withdraw Funds',
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 1. Amount
            _buildLabel('Amount to Withdraw', textTheme),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:
                  _buildInputDecoration(textTheme, hint: '0', prefix: 'PKR '),
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 2. Withdrawal Method
            _buildLabel('Select Method', textTheme),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _MethodCard(
                    icon: PhosphorIconsRegular.bank,
                    label: 'Bank Transfer',
                    value: 'bank',
                    groupValue: _selectedMethod,
                    onTap: () => setState(() => _selectedMethod = 'bank'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MethodCard(
                    icon: PhosphorIconsRegular.deviceMobile,
                    label: 'JazzCash',
                    value: 'jazzcash',
                    groupValue: _selectedMethod,
                    onTap: () => setState(() => _selectedMethod = 'jazzcash'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MethodCard(
                    icon: PhosphorIconsRegular.deviceTablet,
                    label: 'EasyPaisa',
                    value: 'easypaisa',
                    groupValue: _selectedMethod,
                    onTap: () => setState(() => _selectedMethod = 'easypaisa'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3. Account Details
            _buildLabel(
                isBank ? 'Account Details' : 'Mobile Number', textTheme),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _accountController,
              keyboardType: isBank ? TextInputType.text : TextInputType.phone,
              decoration: _buildInputDecoration(
                textTheme,
                hint: isBank ? 'IBAN / Account Number' : '03XX-XXXXXXX',
                icon: isBank
                    ? PhosphorIconsRegular.hash
                    : PhosphorIconsRegular.phone,
              ),
            ),

            if (isBank) ...[
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _titleController,
                decoration: _buildInputDecoration(
                  textTheme,
                  hint: 'Account Title',
                  icon: PhosphorIconsRegular.user,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processWithdrawal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Confirm Withdraw'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, TextTheme textTheme) {
    return Text(
      text,
      style: textTheme.labelLarge?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _buildInputDecoration(TextTheme textTheme,
      {required String hint, String? prefix, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefix,
      prefixStyle: textTheme.titleLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: icon != null
          ? PhosphorIcon(icon, color: AppColors.textSecondary)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.grey300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final PhosphorIconData icon;
  final String label;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withOpacity(0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            PhosphorIcon(
              icon,
              size: 28,
              color: isSelected ? AppColors.secondary : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected ? AppColors.secondary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

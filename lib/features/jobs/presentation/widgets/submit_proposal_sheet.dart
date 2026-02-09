import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/job_mock_data.dart';

Future<void> showSubmitProposalSheet(
  BuildContext context,
  JobOpportunity job,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (context) => _SubmitProposalSheet(job: job),
  );
}

class _SubmitProposalSheet extends StatefulWidget {
  final JobOpportunity job;

  const _SubmitProposalSheet({required this.job});

  @override
  State<_SubmitProposalSheet> createState() => _SubmitProposalSheetState();
}

class _SubmitProposalSheetState extends State<_SubmitProposalSheet> {
  final _bidController = TextEditingController();
  final _coverController = TextEditingController();
  String _duration = '1 week';

  @override
  void dispose() {
    _bidController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    Navigator.of(context).pop();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Your proposal has been submitted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: bottomInset + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Submit Proposal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _bidController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Your Bid Price',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _coverController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Cover Letter',
              hintText: 'Why are you the best fit?',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            value: _duration,
            items: const [
              DropdownMenuItem(value: '1 week', child: Text('1 week')),
              DropdownMenuItem(value: '2 weeks', child: Text('2 weeks')),
              DropdownMenuItem(value: '1 month', child: Text('1 month')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _duration = value);
            },
            decoration: const InputDecoration(
              labelText: 'Estimated Duration',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Send Proposal'),
            ),
          ),
        ],
      ),
    );
  }
}

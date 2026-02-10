import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../cases/models/case_model.dart';
import '../../cases/services/case_service.dart';

class ClientCaseAdDetailsScreen extends StatefulWidget {
  final CaseModel caseModel;

  const ClientCaseAdDetailsScreen({super.key, required this.caseModel});

  @override
  State<ClientCaseAdDetailsScreen> createState() =>
      _ClientCaseAdDetailsScreenState();
}

class _ClientCaseAdDetailsScreenState extends State<ClientCaseAdDetailsScreen> {
  late bool _isAdVisible;
  late List<CaseAttachment> _attachments;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isAdVisible = widget.caseModel.isAdVisible;
    _attachments = List.from(widget.caseModel.attachments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Ad Management'),
        actions: [
          // Edit Button (FAB alternative in AppBar)
          TextButton.icon(
            onPressed: () {
              context.push('/edit-case', extra: widget.caseModel);
            },
            icon: PhosphorIcon(PhosphorIconsRegular.pencilSimple, size: 20),
            label: const Text('Edit'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Status & Toggle Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: _isAdVisible
                          ? Colors.black.withOpacity(0.1)
                          : AppColors.grey300.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: PhosphorIcon(
                      _isAdVisible
                          ? PhosphorIconsRegular.checkCircle
                          : PhosphorIconsRegular.pauseCircle,
                      color:
                          _isAdVisible ? Colors.black : AppColors.textSecondary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isAdVisible ? 'Ad is Active' : 'Ad is Paused',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _isAdVisible
                                        ? Colors.black
                                        : AppColors.textSecondary,
                                  ),
                        ),
                        Text(
                          _isAdVisible
                              ? 'Lawyers can find and view your case.'
                              : 'Your case is hidden from the job board.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isAdVisible,
                    activeColor: Colors.black,
                    activeTrackColor: Colors.grey.withOpacity(0.3),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.black.withOpacity(0.1),
                    onChanged: (value) async {
                      setState(() {
                        _isAdVisible = value;
                      });
                      try {
                        await CaseService()
                            .toggleAdVisibility(widget.caseModel.caseId, value);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                          setState(() => _isAdVisible = !value); // Revert
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 2. Analytics Grid
            Text(
              'Performance Analytics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _AnalyticsCard(
                  label: 'Views',
                  value: widget.caseModel.viewsCount.toString(),
                  icon: PhosphorIconsRegular.eye,
                  color: Colors.blue,
                ),
                const SizedBox(width: AppSpacing.md),
                _AnalyticsCard(
                  label: 'Proposals',
                  value: widget.caseModel.proposalCount.toString(),
                  icon: PhosphorIconsRegular.paperPlaneRight,
                  color: Colors.orange,
                ),
                const SizedBox(width: AppSpacing.md),
                _AnalyticsCard(
                  label: 'Saves',
                  value: widget.caseModel.savesCount.toString(),
                  icon: PhosphorIconsRegular.bookmarkSimple,
                  color: Colors.purple,
                ),
              ],
            ),
            // Insight Tip
            if (widget.caseModel.viewsCount > 10 &&
                widget.caseModel.proposalCount == 0)
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    PhosphorIcon(PhosphorIconsRegular.lightbulb,
                        color: Colors.amber[800]),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        "Many lawyers are viewing your case but not applying. Consider increasing your budget range to attract more proposals.",
                        style:
                            TextStyle(color: Colors.amber[900], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.xl),

            // 3. Document Management
            _buildDocumentSection(context),

            const SizedBox(height: AppSpacing.xl),

            // 4. Case Details Preview
            Text(
              'Case Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: 'Title', value: widget.caseModel.title),
                  const Divider(height: 24),
                  _DetailRow(
                      label: 'Budget',
                      value:
                          'PKR ${widget.caseModel.budgetMin.toInt()} - ${widget.caseModel.budgetMax.toInt()}'),
                  const Divider(height: 24),
                  _DetailRow(label: 'Location', value: widget.caseModel.city),
                  const Divider(height: 24),
                  Text(
                    'Description',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.caseModel.description,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attached Documents',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            if (!_isLoading)
              TextButton.icon(
                onPressed: _addDocument,
                icon: PhosphorIcon(PhosphorIconsRegular.plus, size: 16),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_attachments.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhosphorIcon(PhosphorIconsRegular.file,
                    color: AppColors.textLight),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'No documents attached',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          )
        else
          ..._attachments.map((attachment) => _buildAttachmentCard(attachment)),
      ],
    );
  }

  Widget _buildAttachmentCard(CaseAttachment attachment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: PhosphorIcon(
              _getFileIcon(attachment.fileType),
              color: AppColors.secondary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  attachment.fileType.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: PhosphorIcon(PhosphorIconsRegular.dotsThreeVertical,
                color: AppColors.textSecondary),
            onSelected: (value) {
              switch (value) {
                case 'download':
                  _downloadDocument(attachment);
                  break;
                case 'rename':
                  _renameDocument(attachment);
                  break;
                case 'delete':
                  _deleteDocument(attachment);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 18),
                    SizedBox(width: 8),
                    Text('Download'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'rename',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Rename'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PhosphorIconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return PhosphorIconsRegular.filePdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return PhosphorIconsRegular.fileImage;
      case 'doc':
      case 'docx':
        return PhosphorIconsRegular.fileDoc;
      default:
        return PhosphorIconsRegular.file;
    }
  }

  Future<void> _addDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;

        // Ask for Title
        String? title = await showDialog<String>(
          context: context,
          builder: (context) {
            String tempTitle = fileName;
            return AlertDialog(
              title: const Text('Document Title'),
              content: TextFormField(
                initialValue: tempTitle,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => tempTitle = value,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, tempTitle),
                  child: const Text('Upload'),
                ),
              ],
            );
          },
        );

        if (title != null && title.isNotEmpty) {
          setState(() => _isLoading = true);
          await CaseService()
              .addAttachment(widget.caseModel.caseId, file, title);

          // Refresh list locally for immediate feedback (ideally fetch from server)
          // We can't know the exact URL/Type without fetching, but let's fetch the case to be safe
          final updatedCases = await CaseService()
              .getCasesForClient(widget.caseModel.clientId)
              .first;
          final updatedCase = updatedCases
              .firstWhere((c) => c.caseId == widget.caseModel.caseId);

          setState(() {
            _attachments = updatedCase.attachments;
            _isLoading = false;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document uploaded successfully')),
            );
          }
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading document: $e')),
        );
      }
    }
  }

  Future<void> _deleteDocument(CaseAttachment attachment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document?'),
        content: Text('Are you sure you want to delete "${attachment.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await CaseService()
            .deleteAttachment(widget.caseModel.caseId, attachment);
        setState(() {
          _attachments.remove(attachment);
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document deleted')),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting document: $e')),
          );
        }
      }
    }
  }

  Future<void> _renameDocument(CaseAttachment attachment) async {
    String? newTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempTitle = attachment.title;
        return AlertDialog(
          title: const Text('Rename Document'),
          content: TextFormField(
            initialValue: tempTitle,
            decoration: const InputDecoration(labelText: 'New Title'),
            onChanged: (value) => tempTitle = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, tempTitle),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newTitle != null &&
        newTitle.isNotEmpty &&
        newTitle != attachment.title) {
      setState(() => _isLoading = true);
      try {
        await CaseService().updateAttachmentTitle(
            widget.caseModel.caseId, attachment, newTitle);

        // Refresh local state
        final index = _attachments.indexOf(attachment);
        if (index != -1) {
          final newAttachment = CaseAttachment(
            title: newTitle,
            fileUrl: attachment.fileUrl,
            fileType: attachment.fileType,
          );
          setState(() {
            _attachments[index] = newAttachment;
            _isLoading = false;
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document renamed')),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error renaming document: $e')),
          );
        }
      }
    }
  }

  Future<void> _downloadDocument(CaseAttachment attachment) async {
    final Uri url = Uri.parse(attachment.fileUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch document URL')),
        );
      }
    }
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String label;
  final String value;
  final PhosphorIconData icon;
  final Color color;

  const _AnalyticsCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: PhosphorIcon(icon, color: color, size: 20),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

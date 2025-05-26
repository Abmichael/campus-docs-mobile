import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/letter_template.dart';
import '../../providers/letter_template_provider.dart';
import '../../services/letter_template_service.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';
import 'package:go_router/go_router.dart';

class LetterTemplatesScreen extends ConsumerStatefulWidget {
  const LetterTemplatesScreen({super.key});

  @override
  ConsumerState<LetterTemplatesScreen> createState() =>
      _LetterTemplatesScreenState();
}

class _LetterTemplatesScreenState extends ConsumerState<LetterTemplatesScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _service = LetterTemplateService();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
  void _showAddTemplateDialog() {
    _titleController.clear();
    _bodyController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeConfig.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        ),
        title: Text(
          'Add Template',
          style: ThemeConfig.headlineSmall.copyWith(
            color: ThemeConfig.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                  borderSide: const BorderSide(color: ThemeConfig.primaryBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: ThemeConfig.spaceMedium),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                  borderSide: const BorderSide(color: ThemeConfig.primaryBlue, width: 2),
                ),
                hintText: 'Use [placeholders] for dynamic content',
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ThemeConfig.primaryBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty &&
                  _bodyController.text.isNotEmpty) {
                try {
                  await _service.createTemplate(
                    title: _titleController.text,
                    body: _bodyController.text,
                    placeholders: _extractPlaceholders(_bodyController.text),
                  );
                  if (mounted) {
                    ref.invalidate(letterTemplatesProvider);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: ThemeConfig.white),
                            SizedBox(width: ThemeConfig.spaceSmall),
                            Text('Template created successfully'),
                          ],
                        ),
                        backgroundColor: ThemeConfig.successGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.error, color: ThemeConfig.white),
                            const SizedBox(width: ThemeConfig.spaceSmall),
                            Expanded(child: Text('Error creating template: ${e.toString()}')),
                          ],
                        ),
                        backgroundColor: ThemeConfig.errorRed,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                        ),
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.primaryBlue,
              foregroundColor: ThemeConfig.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditTemplateDialog(LetterTemplate template) {
    _titleController.text = template.title;
    _bodyController.text = template.body;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeConfig.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        ),
        title: Text(
          'Edit Template',
          style: ThemeConfig.headlineSmall.copyWith(
            color: ThemeConfig.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                  borderSide: const BorderSide(color: ThemeConfig.primaryBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: ThemeConfig.spaceMedium),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                  borderSide: const BorderSide(color: ThemeConfig.primaryBlue, width: 2),
                ),
                hintText: 'Use [placeholders] for dynamic content',
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ThemeConfig.primaryBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty &&
                  _bodyController.text.isNotEmpty) {
                try {
                  await _service.updateTemplate(
                    id: template.id,
                    title: _titleController.text,
                    body: _bodyController.text,
                    placeholders: _extractPlaceholders(_bodyController.text),
                  );
                  if (mounted) {
                    ref.invalidate(letterTemplatesProvider);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: ThemeConfig.white),
                            SizedBox(width: ThemeConfig.spaceSmall),
                            Text('Template updated successfully'),
                          ],
                        ),
                        backgroundColor: ThemeConfig.successGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.error, color: ThemeConfig.white),
                            const SizedBox(width: ThemeConfig.spaceSmall),
                            Expanded(child: Text('Error updating template: ${e.toString()}')),
                          ],
                        ),
                        backgroundColor: ThemeConfig.errorRed,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                        ),
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.primaryBlue,
              foregroundColor: ThemeConfig.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  List<String> _extractPlaceholders(String text) {
    final RegExp regex = RegExp(r'\[([^\]]+)\]');
    return regex.allMatches(text).map((match) => match.group(1)!).toList();
  }

  void _showDeleteConfirmation(LetterTemplate template) {
    showDialog(
      context: context,      builder: (context) => AlertDialog(
        backgroundColor: ThemeConfig.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: ThemeConfig.warningOrange,
              size: 24,
            ),
            const SizedBox(width: ThemeConfig.spaceSmall),
            Text(
              'Delete Template',
              style: ThemeConfig.headlineSmall.copyWith(
                color: ThemeConfig.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${template.title}"? This action cannot be undone.',
          style: ThemeConfig.bodyMedium.copyWith(
            color: ThemeConfig.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _service.deleteTemplate(template.id);                if (mounted) {
                  ref.invalidate(letterTemplatesProvider);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Template deleted successfully'),
                      backgroundColor: ThemeConfig.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting template: ${e.toString()}'),
                      backgroundColor: ThemeConfig.errorRed,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.errorRed,
              foregroundColor: ThemeConfig.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(letterTemplatesProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Container(
                padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: ThemeConfig.textPrimary,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: ThemeConfig.spaceSmall),
                    Expanded(
                      child: Text(
                        'Letter Templates',
                        style: ThemeConfig.headlineMedium.copyWith(
                          color: ThemeConfig.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),                    ActionButton(
                      onPressed: _showAddTemplateDialog,
                      text: 'Add Template',
                      icon: Icons.add,
                      isSecondary: true,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: templatesAsync.when(
                  data: (templates) {
                    if (templates.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              size: 64,
                              color: ThemeConfig.textSecondary,
                            ),
                            const SizedBox(height: ThemeConfig.spaceMedium),
                            Text(
                              'No templates found',
                              style: ThemeConfig.headlineSmall.copyWith(
                                color: ThemeConfig.textSecondary,
                              ),
                            ),
                            const SizedBox(height: ThemeConfig.spaceSmall),
                            Text(
                              'Create your first letter template to get started',
                              style: ThemeConfig.bodyMedium.copyWith(
                                color: ThemeConfig.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => ref.refresh(letterTemplatesProvider.future),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConfig.spaceMedium,
                          vertical: ThemeConfig.spaceSmall,
                        ),
                        itemCount: templates.length,
                        itemBuilder: (context, index) {
                          final template = templates[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: ThemeConfig.spaceMedium,
                            ),
                            child: ModernCard(
                              child: Padding(
                                padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.description,
                                          color: ThemeConfig.primaryBlue,
                                          size: 20,
                                        ),
                                        const SizedBox(width: ThemeConfig.spaceSmall),
                                        Expanded(
                                          child: Text(
                                            template.title,
                                            style: ThemeConfig.headlineSmall.copyWith(
                                              color: ThemeConfig.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                                color: ThemeConfig.primaryBlue,
                                                size: 20,
                                              ),
                                              onPressed: () => _showEditTemplateDialog(template),
                                              tooltip: 'Edit template',
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: ThemeConfig.errorRed,
                                                size: 20,
                                              ),
                                              onPressed: () => _showDeleteConfirmation(template),
                                              tooltip: 'Delete template',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: ThemeConfig.spaceSmall),
                                    Container(
                                      padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
                                      decoration: BoxDecoration(
                                        color: ThemeConfig.paleGray,
                                        borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                                        border: Border.all(
                                          color: ThemeConfig.borderLight,
                                        ),
                                      ),
                                      child: Text(
                                        template.body,
                                        style: ThemeConfig.bodyMedium.copyWith(
                                          color: ThemeConfig.textSecondary,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (template.placeholders.isNotEmpty) ...[
                                      const SizedBox(height: ThemeConfig.spaceSmall),
                                      Wrap(                                        spacing: ThemeConfig.spaceXSmall,
                                        runSpacing: ThemeConfig.spaceXSmall,
                                        children: template.placeholders.map((placeholder) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: ThemeConfig.spaceSmall,
                                              vertical: ThemeConfig.spaceXSmall,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ThemeConfig.primaryBlue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                                            ),
                                            child: Text(
                                              '[$placeholder]',
                                              style: ThemeConfig.bodySmall.copyWith(
                                                color: ThemeConfig.primaryBlue,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: ThemeConfig.errorRed,
                        ),
                        const SizedBox(height: ThemeConfig.spaceMedium),
                        Text(
                          'Error loading templates',
                          style: ThemeConfig.headlineSmall.copyWith(
                            color: ThemeConfig.errorRed,
                          ),
                        ),
                        const SizedBox(height: ThemeConfig.spaceSmall),
                        Text(
                          error.toString(),
                          style: ThemeConfig.bodyMedium.copyWith(
                            color: ThemeConfig.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

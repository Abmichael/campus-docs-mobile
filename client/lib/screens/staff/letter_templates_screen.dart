import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/letter_template.dart';
import '../../providers/letter_template_provider.dart';
import '../../services/letter_template_service.dart';

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
        title: const Text('Add Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
                    ref.refresh(letterTemplatesProvider);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Template created successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Error creating template: ${e.toString()}')),
                    );
                  }
                }
              }
            },
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
        title: const Text('Edit Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
                    ref.refresh(letterTemplatesProvider);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Template updated successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Error updating template: ${e.toString()}')),
                    );
                  }
                }
              }
            },
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

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(letterTemplatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Letter Templates')),
      body: templatesAsync.when(
        data: (templates) {
          if (templates.isEmpty) {
            return const Center(
              child: Text('No templates found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(letterTemplatesProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return Card(
                  child: ListTile(
                    title: Text(template.title),
                    subtitle: Text(
                      template.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditTemplateDialog(template),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await _service.deleteTemplate(template.id);
                              if (mounted) {
                                ref.refresh(letterTemplatesProvider);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Template deleted successfully')),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error deleting template: ${e.toString()}')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading templates: ${error.toString()}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTemplateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

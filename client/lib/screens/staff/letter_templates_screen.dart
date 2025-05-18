import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/letter_template.dart';

class LetterTemplatesScreen extends ConsumerStatefulWidget {
  const LetterTemplatesScreen({super.key});

  @override
  ConsumerState<LetterTemplatesScreen> createState() =>
      _LetterTemplatesScreenState();
}

class _LetterTemplatesScreenState extends ConsumerState<LetterTemplatesScreen> {
  // TODO: Replace with actual data provider
  final List<LetterTemplate> _templates = [
    LetterTemplate(
      id: '1',
      title: 'Enrollment Verification',
      body: 'This letter confirms that [STUDENT_NAME] is enrolled at MIT...',
      placeholders: ['STUDENT_NAME'],
    ),
    LetterTemplate(
      id: '2',
      title: 'Good Standing',
      body: 'This letter confirms that [STUDENT_NAME] is in good standing...',
      placeholders: ['STUDENT_NAME'],
    ),
  ];

  void _showAddTemplateDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Template'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
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
                onPressed: () {
                  // TODO: Implement template creation
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Letter Templates')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _templates.length,
        itemBuilder: (context, index) {
          final template = _templates[index];
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
                    onPressed: () {
                      // TODO: Implement template editing
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // TODO: Implement template deletion
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTemplateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

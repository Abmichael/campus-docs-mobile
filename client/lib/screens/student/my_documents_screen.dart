import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/document.dart';
import '../../models/letter.dart';
import '../../providers/document_provider.dart';
import '../../providers/letter_provider.dart';
import '../../config/theme_config.dart';

class MyDocumentsScreen extends ConsumerWidget {
  const MyDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(studentDocumentsProvider);
    final lettersAsync = ref.watch(studentLettersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: ThemeConfig.primaryBlue,
        foregroundColor: Colors.white,
      ),      body: RefreshIndicator(
        color: ThemeConfig.primaryBlue,
        backgroundColor: Colors.white,
        onRefresh: () async {
          // Invalidate both providers
          ref.invalidate(studentDocumentsProvider);
          ref.invalidate(studentLettersProvider);
          
          // Wait for both providers to complete
          try {
            await Future.wait([
              ref.read(studentDocumentsProvider.future),
              ref.read(studentLettersProvider.future),
            ]);
            
            // Show success message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Documents refreshed successfully'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            // Error is handled by the error state
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to refresh documents'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: documentsAsync.when(
          data: (documents) {
            return lettersAsync.when(
              data: (letters) {
                if (documents.isEmpty && letters.isEmpty) {
                  return const _EmptyState();
                }
                return _DocumentsAndLettersList(
                  documents: documents,
                  letters: letters,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _ErrorState(
                error: error,
                onRetry: () {
                  ref.invalidate(studentDocumentsProvider);
                  ref.invalidate(studentLettersProvider);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _ErrorState(
            error: error,
            onRetry: () {
              ref.invalidate(studentDocumentsProvider);
              ref.invalidate(studentLettersProvider);
            },
          ),
        ),
      ),    );
  }
}

class _DocumentsAndLettersList extends ConsumerWidget {
  final List<Document> documents;
  final List<Letter> letters;

  const _DocumentsAndLettersList({
    required this.documents,
    required this.letters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = documents.length + letters.length;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index < documents.length) {
          final document = documents[index];
          return _DocumentCard(document: document);
        } else {
          final letter = letters[index - documents.length];
          return _LetterCard(letter: letter);
        }
      },
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final Document document;

  const _DocumentCard({required this.document});

  bool get isReady => document.signedBy != null;
  
  String get statusText => isReady ? 'Ready' : 'Pending';
  
  Color get statusColor => isReady ? Colors.green : Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Document #${document.requestId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${_formatDate(document.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (isReady && document.signedAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Signed: ${_formatDate(document.signedAt!)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _StatusChip(
                  text: statusText,
                  backgroundColor: statusColor,
                  textColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              document.content,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created by: ${document.createdBy}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (isReady)                  ElevatedButton.icon(
                    onPressed: () => _downloadDocument(context),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeConfig.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _downloadDocument(BuildContext context) {
    // TODO: Implement actual document download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document download functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _LetterCard extends ConsumerWidget {
  final Letter letter;

  const _LetterCard({required this.letter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openLetter(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Letter #${letter.requestId}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Created: ${_formatDate(letter.createdAt)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.description,
                    color: ThemeConfig.primaryBlue,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                letter.content,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created by: ${letter.createdBy}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _openLetter(BuildContext context) {
    // Navigate to letter detail page
    context.push('/student/letter/${letter.id}');
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _StatusChip({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your requested documents will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.primaryBlue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

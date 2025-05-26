import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/letter.dart';
import '../../providers/letter_provider.dart';
import '../../config/theme_config.dart';
import '../../services/pdf_service.dart';

class LetterDetailScreen extends ConsumerWidget {
  final String letterId;
  final PdfService _pdfService = PdfService();

  LetterDetailScreen({
    super.key,
    required this.letterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final letterAsync = ref.watch(letterDetailProvider(letterId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: ThemeConfig.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          letterAsync.when(
            data: (letter) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareLetter(context, letter),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadLetter(context, letter),
                ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: letterAsync.when(
        data: (letter) => _LetterContent(letter: letter),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorState(
          error: error,
          onRetry: () => ref.refresh(letterDetailProvider(letterId).future),
        ),
      ),
    );
  }

  Future<void> _shareLetter(BuildContext context, Letter letter) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Generating PDF...'),
            ],
          ),
        ),
      );

      // Generate PDF
      final String pdfPath = await _pdfService.generateLetterPdf(letter);
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Share the PDF
      await _pdfService.sharePdf(pdfPath, _getLetterTitle(letter));

    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share letter: ${e.toString()}'),
            backgroundColor: ThemeConfig.errorRed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _downloadLetter(BuildContext context, Letter letter) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Downloading...'),
            ],
          ),
        ),
      );

      // Generate PDF
      final String tempPdfPath = await _pdfService.generateLetterPdf(letter);
      
      // Save to downloads
      final String savedPath = await _pdfService.savePdfToDownloads(tempPdfPath, letter);
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Letter downloaded successfully'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Saved to: ${savedPath.split('/').last}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: ThemeConfig.successGreen,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download letter: ${e.toString()}'),
            backgroundColor: ThemeConfig.errorRed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getLetterTitle(Letter letter) {
    if (letter.templateVariables != null) {
      if (letter.templateVariables!.containsKey('template_title')) {
        return letter.templateVariables!['template_title']!;
      }
      if (letter.templateVariables!.containsKey('title')) {
        return letter.templateVariables!['title']!;
      }
    }

    final content = letter.content.toLowerCase();
    if (content.contains('enrollment') || content.contains('enrolment')) {
      return 'Certificate of Enrollment';
    } else if (content.contains('completion')) {
      return 'Certificate of Completion';
    } else if (content.contains('transcript')) {
      return 'Academic Transcript';
    } else if (content.contains('recommendation')) {
      return 'Letter of Recommendation';
    } else {
      return 'Official Letter';
    }
  }
}

class _LetterContent extends StatelessWidget {
  final Letter letter;

  const _LetterContent({required this.letter});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Institution Header with Logo
                  _buildInstitutionHeader(),
                  const SizedBox(height: 24),

                  // Reference Number and Date
                  _buildReferenceAndDate(),
                  const SizedBox(height: 16),

                  // Letter Title
                  _buildLetterTitle(),
                  const SizedBox(height: 16),

                  // Letter Content
                  _buildLetterBody(),

                  const SizedBox(height: 24),

                  // Signature Section
                  _buildSignatureSection(),

                  const SizedBox(height: 16),

                  // Footer/Seal
                  _buildInstitutionalFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstitutionHeader() {
    return Column(
      children: [
        // Institution Logo and Name
        Row(
          children: [
            // MIT Logo - vertical rectangular
            Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Image.asset(
                'assets/images/Mekelle_Institute_of_Technology.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if asset doesn't exist
                  return Container(
                    decoration: BoxDecoration(
                      color: ThemeConfig.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MEKELLE INSTITUTE OF TECHNOLOGY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeConfig.primaryBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'STUDENT SERVICES DEPARTMENT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Po.Box 94006, Mekelle City, Tigray 7000\n'
                    'Phone: +251 9 968 8000 | Email: info@mekelle.et',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Decorative line
        Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ThemeConfig.primaryBlue,
                ThemeConfig.primaryBlue.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reference Number
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ref: ${_getRefNumber()}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ThemeConfig.textPrimary,
              ),
            ),
          ],
        ), // Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Date: ${_formatFullDate(letter.createdAt)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ThemeConfig.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLetterTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        _getLetterTitle(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: ThemeConfig.textPrimary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildLetterBody() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      child: Text(
        letter.content,
        style: const TextStyle(
          fontSize: 13,
          height: 1.5,
          color: ThemeConfig.textPrimary,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40), // Space for signature
    
        // Signature line
        Container(
          width: 200,
          height: 1,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 6),
    
        // Signatory information
        if (letter.signedBy != null) ...[
          Text(
            letter.signedBy!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ThemeConfig.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Student Services Manager',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          if (letter.signedAt != null) ...[
            const SizedBox(height: 2),
            Text(
              'Date: ${_formatDate(letter.signedAt!)}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ] else ...[
          Text(
            letter.createdBy,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ThemeConfig.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Student Services Department',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInstitutionalFooter() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConfig.primaryBlue,
                  ThemeConfig.primaryBlue.withOpacity(0.3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Institutional seal/footer text
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: ThemeConfig.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: ThemeConfig.primaryBlue,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.school,
                  color: ThemeConfig.primaryBlue,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This document is issued by Mekelle Institute of Technology',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'For verification, contact Student Services at +64 9 968 8000',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (letter.templateVariables != null &&
              letter.templateVariables!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document Details:',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...letter.templateVariables!.entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  } // Helper methods

  String _getRefNumber() {
    // Use template variables if available
    if (letter.templateVariables != null) {
      // Check for various ref number keys
      if (letter.templateVariables!.containsKey('ref_no')) {
        return letter.templateVariables!['ref_no']!;
      }
      if (letter.templateVariables!.containsKey('refnum')) {
        return letter.templateVariables!['refnum']!;
      }
    }
    // Fallback: Generate a reference number similar to backend format
    return 'REF-${DateTime.now().millisecondsSinceEpoch}';
  }

  String _formatFullDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getLetterTitle() {
    String prefix = 'Title: ';
    // Use template variables if available
    if (letter.templateVariables != null) {
      // Check for a prefix in variables
      if (letter.templateVariables!.containsKey('title_prefix')) {
        prefix = '${letter.templateVariables!['title_prefix']!.toUpperCase()} ';
      }
      // Check for template title in variables
      if (letter.templateVariables!.containsKey('template_title')) {
        return '$prefix${letter.templateVariables!['template_title']!.toUpperCase()}';
      }
      if (letter.templateVariables!.containsKey('title')) {
        return '$prefix${letter.templateVariables!['title']!.toUpperCase()}';
      }
    }

    // Fallback: Try to extract title from content or use a default
    final content = letter.content.toLowerCase();
    if (content.contains('enrollment') || content.contains('enrolment')) {
      return '${prefix}CERTIFICATE OF ENROLLMENT';
    } else if (content.contains('completion')) {
      return '${prefix}CERTIFICATE OF COMPLETION';
    } else if (content.contains('transcript')) {
      return '${prefix}ACADEMIC TRANSCRIPT';
    } else if (content.contains('recommendation')) {
      return '${prefix}LETTER OF RECOMMENDATION';
    } else {
      return '${prefix}OFFICIAL LETTER';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
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
            'Failed to load letter',
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
          const SizedBox(height: 16),
          ElevatedButton.icon(
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

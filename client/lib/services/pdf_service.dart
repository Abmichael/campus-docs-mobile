import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../models/letter.dart';

class PdfService {
  /// Generates a PDF from letter content and returns the file path
  Future<String> generateLetterPdf(Letter letter) async {
    final pdf = pw.Document();

    // Load logo if available
    pw.ImageProvider? logoImage;
    try {
      final logoData = await rootBundle.load('assets/images/Mekelle_Institute_of_Technology.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      // Logo not found, continue without it
      print('Logo not found: $e');
    }

    // Add page to PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(72), // 1 inch margins
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo and institution info
              _buildHeader(logoImage),
              pw.SizedBox(height: 24),

              // Reference and date
              _buildReferenceAndDate(letter),
              pw.SizedBox(height: 16),

              // Letter title
              _buildLetterTitle(letter),
              pw.SizedBox(height: 16),

              // Letter content
              _buildLetterContent(letter),
              pw.SizedBox(height: 32),

              // Signature section
              _buildSignatureSection(letter),

              // Footer
              pw.Spacer(),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    // Save PDF to temporary directory
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName = 'MIT_Letter_${letter.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final String filePath = '${tempDir.path}/$fileName';
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  pw.Widget _buildHeader(pw.ImageProvider? logoImage) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Logo
        if (logoImage != null)
          pw.Container(
            width: 50,
            height: 70,
            child: pw.Image(logoImage),
          ),
        if (logoImage != null) pw.SizedBox(width: 16),
        
        // Institution details
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'MEKELLE INSTITUTE OF TECHNOLOGY',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'STUDENT SERVICES DEPARTMENT',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Po.Box 94006, Mekelle City, Tigray 7000\n'
                'Phone: +251 9 968 8000 | Email: info@mekelle.et',
                style: const pw.TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildReferenceAndDate(Letter letter) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Ref: ${_getRefNumber(letter)}',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          'Date: ${_formatFullDate(letter.createdAt)}',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildLetterTitle(Letter letter) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Text(
        _getLetterTitle(letter),
        style: pw.TextStyle(
          fontSize: 13,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildLetterContent(Letter letter) {
    return pw.Container(
      width: double.infinity,
      child: pw.Text(
        letter.content,
        style: const pw.TextStyle(
          fontSize: 13,
          lineSpacing: 1.5,
        ),
        textAlign: pw.TextAlign.justify,
      ),
    );
  }

  pw.Widget _buildSignatureSection(Letter letter) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 40), // Space for signature

        // Signature line
        pw.Container(
          width: 200,
          height: 1,
          color: PdfColors.grey400,
        ),
        pw.SizedBox(height: 6),

        // Signatory information
        if (letter.signedBy != null) ...[
          pw.Text(
            letter.signedBy!,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Student Services Manager',
            style: const pw.TextStyle(fontSize: 10),
          ),
          if (letter.signedAt != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              'Date: ${_formatDate(letter.signedAt!)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ] else ...[
          pw.Text(
            letter.createdBy,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Student Services Department',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Container(
          height: 1,
          color: PdfColors.grey300,
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'This document is issued by Mekelle Institute of Technology\n'
          'For verification, contact Student Services at +251 9 968 8000',
          style: const pw.TextStyle(fontSize: 8),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  String _getRefNumber(Letter letter) {
    if (letter.templateVariables != null) {
      if (letter.templateVariables!.containsKey('ref_no')) {
        return letter.templateVariables!['ref_no']!;
      }
      if (letter.templateVariables!.containsKey('refnum')) {
        return letter.templateVariables!['refnum']!;
      }
    }
    return 'REF-${DateTime.now().millisecondsSinceEpoch}';
  }

  String _formatFullDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getLetterTitle(Letter letter) {
    String prefix = 'SUBJECT: ';
    if (letter.templateVariables != null) {
      if (letter.templateVariables!.containsKey('title_prefix')) {
        prefix = '${letter.templateVariables!['title_prefix']!.toUpperCase()} ';
      }
      if (letter.templateVariables!.containsKey('template_title')) {
        return '$prefix${letter.templateVariables!['template_title']!.toUpperCase()}';
      }
      if (letter.templateVariables!.containsKey('title')) {
        return '$prefix${letter.templateVariables!['title']!.toUpperCase()}';
      }
    }

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

  /// Share a PDF file using the share_plus package
  Future<void> sharePdf(String filePath, String letterTitle) async {
    final file = XFile(filePath);
    await Share.shareXFiles(
      [file],
      text: 'MIT Letter: $letterTitle',
      subject: 'Official Letter from Mekelle Institute of Technology',
    );
  }

  /// Save PDF to downloads folder (Android) or documents folder (iOS)
  Future<String> savePdfToDownloads(String tempFilePath, Letter letter) async {
    final String fileName = 'MIT_Letter_${letter.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    
    try {
      Directory? downloadsDir;
      
      if (Platform.isAndroid) {
        // For Android, try to save to Downloads folder
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          // Fallback to external storage
          downloadsDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        // For iOS, save to Documents directory
        downloadsDir = await getApplicationDocumentsDirectory();
      } else {
        // For other platforms, use application documents directory
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null) {
        throw Exception('Unable to access storage directory');
      }

      final String savePath = '${downloadsDir.path}/$fileName';
      final File tempFile = File(tempFilePath);
      final File savedFile = await tempFile.copy(savePath);

      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }
}

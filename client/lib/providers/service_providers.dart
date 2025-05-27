import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/http_service.dart';
import '../services/user_service.dart';
import '../services/request_service.dart';
import '../services/document_service.dart';
import '../services/letter_template_service.dart';
import '../services/letter_service.dart';

/// Provider for the centralized HTTP service
final httpServiceProvider = Provider<HttpService>((ref) => HttpService());

/// Provider for UserService using centralized HTTP service
final userServiceProvider = Provider<UserService>((ref) => UserService());

/// Provider for RequestService using centralized HTTP service
final requestServiceProvider = Provider<RequestService>((ref) => RequestService());

/// Provider for DocumentService using centralized HTTP service
final documentServiceProvider = Provider<DocumentService>((ref) => DocumentService());

/// Provider for LetterTemplateService using centralized HTTP service
final letterTemplateServiceProvider = Provider<LetterTemplateService>((ref) => LetterTemplateService());

/// Provider for LetterService using centralized HTTP service
final letterServiceProvider = Provider<LetterService>((ref) => LetterService());

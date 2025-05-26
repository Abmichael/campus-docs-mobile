import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/request.dart';
import '../../services/request_service.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';

class RequestFormScreen extends ConsumerStatefulWidget {
  const RequestFormScreen({super.key});

  @override
  ConsumerState<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends ConsumerState<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _requestService = RequestService();
  RequestType? _selectedType;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await _requestService.createRequest(
          _selectedType!,
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
        );        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Request submitted successfully'),
              backgroundColor: ThemeConfig.successGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
              ),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting request: ${e.toString()}'),
              backgroundColor: ThemeConfig.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: ThemeConfig.headerGradient,
                ),
                padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'New Request',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ModernCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
                                    decoration: BoxDecoration(
                                      color: ThemeConfig.primaryBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                                    ),
                                    child: const Icon(
                                      Icons.assignment,
                                      color: ThemeConfig.primaryBlue,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: ThemeConfig.spaceSmall),
                                  const Text(
                                    'Request Type',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeConfig.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: ThemeConfig.spaceMedium),
                              DropdownButtonFormField<RequestType>(
                                decoration: InputDecoration(
                                  labelText: 'Select Type',
                                  prefixIcon: const Icon(Icons.category, color: ThemeConfig.primaryBlue),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                                    borderSide: const BorderSide(color: ThemeConfig.borderLight),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                                    borderSide: const BorderSide(color: ThemeConfig.primaryBlue, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                value: _selectedType,
                                items: RequestType.values.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                      type.name.toUpperCase(),
                                      style: const TextStyle(color: ThemeConfig.textPrimary),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedType = value);
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a request type';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: ThemeConfig.spaceMedium),
                        ModernCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
                                    decoration: BoxDecoration(
                                      color: ThemeConfig.warningOrange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                                    ),
                                    child: const Icon(
                                      Icons.notes,
                                      color: ThemeConfig.warningOrange,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: ThemeConfig.spaceSmall),
                                  const Text(
                                    'Additional Notes',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeConfig.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: ThemeConfig.spaceMedium),
                              TextFormField(
                                controller: _notesController,
                                decoration: InputDecoration(
                                  labelText: 'Notes',
                                  prefixIcon: const Icon(Icons.edit_note, color: ThemeConfig.primaryBlue),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                                    borderSide: const BorderSide(color: ThemeConfig.borderLight),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                                    borderSide: const BorderSide(color: ThemeConfig.primaryBlue, width: 2),
                                  ),
                                  hintText: 'Add any additional information here...',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                maxLines: 5,
                                style: const TextStyle(color: ThemeConfig.textPrimary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: ThemeConfig.spaceLarge),
                        if (_isLoading)
                          Container(
                            padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(ThemeConfig.primaryBlue),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeConfig.primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send, size: 20),
                                  SizedBox(width: ThemeConfig.spaceSmall),
                                  Text(
                                    'Submit Request',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

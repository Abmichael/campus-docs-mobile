import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/request.dart';
import '../../models/letter_template.dart';
import '../../services/letter_template_service.dart';
import '../../services/letter_service.dart';
import '../../config/theme_config.dart';

class CreateLetterScreen extends ConsumerStatefulWidget {
  final Request request;
  const CreateLetterScreen({Key? key, required this.request}) : super(key: key);

  @override
  ConsumerState<CreateLetterScreen> createState() => _CreateLetterScreenState();
}

class _CreateLetterScreenState extends ConsumerState<CreateLetterScreen> {
  LetterTemplate? _selectedTemplate;
  String _body = '';
  bool _isSubmitting = false;
  List<LetterTemplate> _templates = [];
  final Map<String, TextEditingController> _variableControllers = {};
  final _bodyController = TextEditingController();
  final _refNoController = TextEditingController(); // Add ref number controller

  @override
  void initState() {
    super.initState();
    _fetchTemplates();
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _refNoController.dispose(); // Dispose ref number controller
    for (var controller in _variableControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchTemplates() async {
    try {
      final service = LetterTemplateService();
      final templates = await service.fetchTemplates();
      setState(() {
        _templates = templates;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load templates: ${e.toString()}')),
        );
      }
    }
  }

  void _onTemplateSelected(LetterTemplate? template) {
    setState(() {
      _selectedTemplate = template;
      _body = template?.body ?? '';
      _bodyController.text = _body;

      // Create controllers for each placeholder
      _variableControllers.clear();
      if (template != null) {
        for (String placeholder in template.placeholders) {
          _variableControllers[placeholder] = TextEditingController();
        }
      }
    });  }

  Future<void> _submit() async {
    if (_selectedTemplate == null || _body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a template and fill in the content')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    try {
      final letterService = LetterService();      // Prepare template variables
      Map<String, String> templateVariables = {};
      _variableControllers.forEach((key, controller) {
        if (controller.text.isNotEmpty) {
          templateVariables[key] = controller.text;
        }
      });

      // Add ref_no if provided
      if (_refNoController.text.isNotEmpty) {
        templateVariables['ref_no'] = _refNoController.text;
      }

      // Add template title to variables
      templateVariables['template_title'] = _selectedTemplate!.title;

      await letterService.createLetter(
        requestId: widget.request.id,
        content: _body,
        templateId: _selectedTemplate!.id,
        templateVariables: templateVariables,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create letter: ${e.toString()}'),
            backgroundColor: ThemeConfig.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.paleGray,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                      'Create Letter',
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

            // Content
            Expanded(
              child: _isSubmitting
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ThemeConfig.primaryBlue),
                          ),
                          SizedBox(height: ThemeConfig.spaceMedium),
                          Text(
                            'Creating letter...',
                            style: TextStyle(
                              color: ThemeConfig.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Request Info Card
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ThemeConfig.radiusMedium),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(ThemeConfig.spaceMedium),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: ThemeConfig.primaryBlue,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                          width: ThemeConfig.spaceSmall),
                                      Text(
                                        'Request Information',
                                        style:
                                            ThemeConfig.headlineSmall.copyWith(
                                          color: ThemeConfig.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: ThemeConfig.spaceSmall),
                                  Text(
                                      'Type: ${widget.request.type.name.toUpperCase()}'),
                                  if (widget.request.notes != null &&
                                      widget.request.notes!.isNotEmpty)
                                    Text('Notes: ${widget.request.notes}'),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: ThemeConfig.spaceMedium),

                          // Template Selection Card
                          Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ThemeConfig.radiusMedium),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(ThemeConfig.spaceMedium),
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
                                      const SizedBox(
                                          width: ThemeConfig.spaceSmall),
                                      Text(
                                        'Select Template',
                                        style:
                                            ThemeConfig.headlineSmall.copyWith(
                                          color: ThemeConfig.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: ThemeConfig.spaceMedium),
                                  DropdownButtonFormField<LetterTemplate>(
                                    value: _selectedTemplate,
                                    items: _templates
                                        .map((template) => DropdownMenuItem(
                                              value: template,
                                              child: Text(template.title),
                                            ))
                                        .toList(),
                                    onChanged: _onTemplateSelected,
                                    decoration: InputDecoration(
                                      labelText: 'Choose a template',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ThemeConfig.radiusMedium),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ThemeConfig.radiusMedium),
                                        borderSide: const BorderSide(
                                            color: ThemeConfig.primaryBlue,
                                            width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),                          ),

                          // Reference Number Card (always show if template is selected)
                          if (_selectedTemplate != null) ...[
                            const SizedBox(height: ThemeConfig.spaceMedium),
                            Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ThemeConfig.radiusMedium),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    ThemeConfig.spaceMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.numbers,
                                          color: ThemeConfig.primaryBlue,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                            width: ThemeConfig.spaceSmall),
                                        Text(
                                          'Reference Number',
                                          style: ThemeConfig.headlineSmall
                                              .copyWith(
                                            color: ThemeConfig.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: ThemeConfig.spaceSmall),
                                    Text(
                                      'Leave empty for auto-generation',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: ThemeConfig.spaceMedium),
                                    TextFormField(
                                      controller: _refNoController,
                                      decoration: InputDecoration(
                                        labelText: 'Reference Number (Optional)',
                                        hintText: 'e.g., REF-2025-001',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              ThemeConfig.radiusMedium),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              ThemeConfig.radiusMedium),
                                          borderSide: const BorderSide(
                                              color: ThemeConfig.primaryBlue,
                                              width: 2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          // Template Variables Card (only show if template is selected)
                          if (_selectedTemplate != null &&
                              _selectedTemplate!.placeholders.isNotEmpty) ...[
                            const SizedBox(height: ThemeConfig.spaceMedium),
                            Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ThemeConfig.radiusMedium),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    ThemeConfig.spaceMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.edit,
                                          color: ThemeConfig.primaryBlue,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                            width: ThemeConfig.spaceSmall),
                                        Text(
                                          'Fill Template Variables',
                                          style: ThemeConfig.headlineSmall
                                              .copyWith(
                                            color: ThemeConfig.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: ThemeConfig.spaceMedium),
                                    ..._selectedTemplate!.placeholders
                                        .map((placeholder) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: ThemeConfig.spaceMedium),
                                        child: TextFormField(
                                          controller:
                                              _variableControllers[placeholder],
                                          decoration: InputDecoration(
                                            labelText: placeholder
                                                .replaceAll('_', ' ')
                                                .toUpperCase(),
                                            hintText:
                                                'Enter ${placeholder.replaceAll('_', ' ')}',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ThemeConfig.radiusMedium),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ThemeConfig.radiusMedium),
                                              borderSide: const BorderSide(
                                                  color:
                                                      ThemeConfig.primaryBlue,
                                                  width: 2),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            // Update the letter body in real-time
                                            String updatedBody =
                                                _selectedTemplate!.body;
                                            _variableControllers
                                                .forEach((key, controller) {
                                              if (controller.text.isNotEmpty) {
                                                updatedBody =
                                                    updatedBody.replaceAll(
                                                        '[$key]',
                                                        controller.text);
                                              }
                                            });
                                            setState(() {
                                              _body = updatedBody;
                                              _bodyController.text = _body;
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          // Letter Preview Card
                          if (_selectedTemplate != null) ...[
                            const SizedBox(height: ThemeConfig.spaceMedium),
                            Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ThemeConfig.radiusMedium),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    ThemeConfig.spaceMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.preview,
                                          color: ThemeConfig.primaryBlue,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                            width: ThemeConfig.spaceSmall),
                                        Text(
                                          'Letter Preview',
                                          style: ThemeConfig.headlineSmall
                                              .copyWith(
                                            color: ThemeConfig.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: ThemeConfig.spaceMedium),
                                    TextFormField(
                                      controller: _bodyController,
                                      minLines: 8,
                                      maxLines: 15,
                                      onChanged: (val) =>
                                          setState(() => _body = val),
                                      decoration: InputDecoration(
                                        labelText: 'Letter Content',
                                        hintText:
                                            'Letter content will appear here...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              ThemeConfig.radiusMedium),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              ThemeConfig.radiusMedium),
                                          borderSide: const BorderSide(
                                              color: ThemeConfig.primaryBlue,
                                              width: 2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: ThemeConfig.spaceLarge),

                          // Create Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _selectedTemplate == null ||
                                      _body.isEmpty ||
                                      _isSubmitting
                                  ? null
                                  : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeConfig.primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      ThemeConfig.radiusMedium),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.create, size: 20),
                                  SizedBox(width: ThemeConfig.spaceSmall),
                                  Text(
                                    'Create Letter',
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
          ],
        ),
      ),
    );
  }
}

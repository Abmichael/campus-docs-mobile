import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_provider.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';
import '../../models/system_settings.dart';

class SystemSettingsScreen extends ConsumerStatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  ConsumerState<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(systemSettingsProvider);

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
                        'System Settings',
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
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: ThemeConfig.spaceMedium),                  child: settingsAsync.when(
                    data: (SystemSettings settings) {
                      // Initialize controllers if not already done
                      if (_controllers.isEmpty) {
                        _controllers['systemName'] = TextEditingController(text: settings.systemName);
                        _controllers['emailFrom'] = TextEditingController(text: settings.emailFrom);
                        _controllers['smtpServer'] = TextEditingController(text: settings.smtpServer);
                        _controllers['smtpPort'] = TextEditingController(text: settings.smtpPort);
                        _controllers['smtpUsername'] = TextEditingController(text: settings.smtpUsername);
                        _controllers['smtpPassword'] = TextEditingController(text: settings.smtpPassword);
                      }
                      return SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [                              const SectionHeader(
                                title: 'Email Configuration',
                              ),
                              ModernCard(
                                child: Column(
                                  children: [
                                    _buildSettingField(
                                      'System Name',
                                      'systemName',
                                      'Enter system name',
                                      Icons.settings,
                                    ),
                                    const SizedBox(height: ThemeConfig.spaceMedium),
                                    _buildSettingField(
                                      'Email From Address',
                                      'emailFrom',
                                      'Enter email from address',
                                      Icons.email,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceMedium),                              const SectionHeader(
                                title: 'SMTP Configuration',
                              ),
                              ModernCard(
                                child: Column(
                                  children: [
                                    _buildSettingField(
                                      'SMTP Server',
                                      'smtpServer',
                                      'Enter SMTP server address',
                                      Icons.dns,
                                    ),
                                    const SizedBox(height: ThemeConfig.spaceMedium),
                                    _buildSettingField(
                                      'SMTP Port',
                                      'smtpPort',
                                      'Enter SMTP port',
                                      Icons.settings_ethernet,
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: ThemeConfig.spaceMedium),
                                    _buildSettingField(
                                      'SMTP Username',
                                      'smtpUsername',
                                      'Enter SMTP username',
                                      Icons.person,
                                    ),
                                    const SizedBox(height: ThemeConfig.spaceMedium),
                                    _buildSettingField(
                                      'SMTP Password',
                                      'smtpPassword',
                                      'Enter SMTP password',
                                      Icons.lock,
                                      isPassword: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceLarge),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveSettings,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeConfig.primaryBlue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.save),
                                            SizedBox(width: ThemeConfig.spaceSmall),
                                            Text(
                                              'Save Settings',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceLarge),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const LoadingWidget(message: 'Loading settings...'),
                    error: (error, stack) => Center(
                      child: ModernCard(
                        child: Padding(
                          padding: const EdgeInsets.all(ThemeConfig.spaceLarge),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: ThemeConfig.errorRed,
                              ),
                              const SizedBox(height: ThemeConfig.spaceMedium),
                              const Text(
                                'Error loading settings',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeConfig.errorRed,
                                ),
                              ),
                              const SizedBox(height: ThemeConfig.spaceSmall),
                              Text(
                                error.toString(),
                                style: const TextStyle(
                                  color: ThemeConfig.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
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
  Widget _buildSettingField(
    String label,
    String key,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: _controllers[key],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: ThemeConfig.primaryBlue,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
          borderSide: const BorderSide(color: ThemeConfig.primaryBlue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
          borderSide: const BorderSide(color: ThemeConfig.borderLight),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(adminServiceProvider);
      final settingsMap = {
        'systemName': _controllers['systemName']!.text,
        'emailFrom': _controllers['emailFrom']!.text,
        'smtpServer': _controllers['smtpServer']!.text,
        'smtpPort': _controllers['smtpPort']!.text,
        'smtpUsername': _controllers['smtpUsername']!.text,
        'smtpPassword': _controllers['smtpPassword']!.text,
      };
      await service.updateSystemSettings(settingsMap);
      if (mounted) {
        ref.invalidate(systemSettingsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: ThemeConfig.spaceSmall),
                Text('Settings saved successfully'),
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
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: ThemeConfig.spaceSmall),
                Expanded(child: Text('Error saving settings: ${e.toString()}')),
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

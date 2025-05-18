import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/admin_provider.dart';

class SystemSettingsScreen extends ConsumerStatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  ConsumerState<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _settings;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(systemSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
      ),
      body: settingsAsync.when(
        data: (settings) {
          _settings = Map<String, dynamic>.from(settings);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingField(
                    'System Name',
                    'systemName',
                    'Enter system name',
                  ),
                  const SizedBox(height: 16),
                  _buildSettingField(
                    'Email From Address',
                    'emailFrom',
                    'Enter email from address',
                  ),
                  const SizedBox(height: 16),
                  _buildSettingField(
                    'SMTP Server',
                    'smtpServer',
                    'Enter SMTP server address',
                  ),
                  const SizedBox(height: 16),
                  _buildSettingField(
                    'SMTP Port',
                    'smtpPort',
                    'Enter SMTP port',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildSettingField(
                    'SMTP Username',
                    'smtpUsername',
                    'Enter SMTP username',
                  ),
                  const SizedBox(height: 16),
                  _buildSettingField(
                    'SMTP Password',
                    'smtpPassword',
                    'Enter SMTP password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveSettings,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Save Settings'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildSettingField(
    String label,
    String key,
    String hint, {
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return TextFormField(
      initialValue: _settings[key]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      obscureText: isPassword,
      onChanged: (value) {
        setState(() {
          _settings[key] = value;
        });
      },
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
      await service.updateSystemSettings(_settings);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: ${e.toString()}'),
            backgroundColor: Colors.red,
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

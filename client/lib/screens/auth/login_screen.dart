import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../utils/snackbar_utils.dart';
import '../../config/theme_config.dart';
import '../../config/api_config.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiUrlController = TextEditingController();
  bool _showAdvancedSettings = false;

  @override
  void initState() {
    super.initState();
    _loadSavedApiUrl();
  }

  Future<void> _loadSavedApiUrl() async {
    final savedUrl = await ApiConfig.baseUrl;
    if (savedUrl != ApiConfig.defaultBaseUrl) {
      _apiUrlController.text = savedUrl;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _apiUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final customUrl = _apiUrlController.text.trim().isEmpty 
          ? null 
          : _apiUrlController.text.trim();
      
      await ref
          .read(authProvider.notifier)
          .login(
            _emailController.text, 
            _passwordController.text,
            customApiUrl: customUrl,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // Listen to auth state changes
        ref.listen(authProvider, (previous, next) {
          if (next.error != null) {
            showErrorSnackBar(context, next.error!);
            ref.read(authProvider.notifier).clearError();
          }
        });

        final authState = ref.watch(authProvider);        return Scaffold(
          body: GradientBackground(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(ThemeConfig.spaceLarge),
                child: ModernCard(
                  child: Padding(
                    padding: const EdgeInsets.all(ThemeConfig.spaceLarge),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo/Title
                          const Icon(
                            Icons.school,
                            size: 80,
                            color: ThemeConfig.primaryBlue,
                          ),
                          const SizedBox(height: ThemeConfig.spaceMedium),
                          Text(
                            'MIT Mobile',
                            style: ThemeConfig.headlineLarge.copyWith(
                              color: ThemeConfig.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: ThemeConfig.spaceSmall),                          Text(
                            'Sign in to continue',
                            style: ThemeConfig.bodyLarge.copyWith(
                              color: ThemeConfig.textSecondary,
                            ),
                          ),
                          const SizedBox(height: ThemeConfig.spaceLarge),
                          
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: ThemeConfig.spaceMedium),
                            // Password Field
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outlined),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: ThemeConfig.spaceMedium),
                            // Advanced Settings Expansion
                          ExpansionTile(
                            initiallyExpanded: _showAdvancedSettings,
                            title: Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: ThemeConfig.primaryBlue,
                                  size: 20,
                                ),
                                const SizedBox(width: ThemeConfig.spaceSmall),
                                Text(
                                  'Advanced Settings',
                                  style: ThemeConfig.bodyMedium.copyWith(
                                    color: ThemeConfig.primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(bottom: ThemeConfig.spaceMedium),
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _showAdvancedSettings = expanded;
                              });
                            },
                            children: [
                              const SizedBox(height: ThemeConfig.spaceSmall),
                              TextFormField(
                                controller: _apiUrlController,
                                decoration: InputDecoration(
                                  labelText: 'Custom API URL (Optional)',
                                  hintText: 'e.g., http://192.168.1.100:4000',
                                  prefixIcon: const Icon(Icons.cloud_outlined),
                                  border: const OutlineInputBorder(),
                                  helperText: 'Leave empty to use default server',
                                  helperStyle: ThemeConfig.bodySmall.copyWith(
                                    color: ThemeConfig.textSecondary,
                                  ),
                                ),
                                keyboardType: TextInputType.url,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    // Basic URL validation
                                    final urlPattern = RegExp(r'^https?://[^\s/$.?#].[^\s]*$');
                                    if (!urlPattern.hasMatch(value)) {
                                      return 'Please enter a valid URL';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: ThemeConfig.spaceMedium),
                          
                          // Login Button
                          if (authState.isLoading)
                            const LoadingWidget(message: 'Signing in...')
                          else
                            ActionButton(
                              onPressed: _handleLogin,
                              text: 'Sign In',
                              isLoading: authState.isLoading,
                              icon: Icons.login,
                            ),
                          const SizedBox(height: ThemeConfig.spaceMedium),
                          
                          // Forgot Password
                          TextButton(
                            onPressed: () => context.go('/forgot-password'),
                            child: Text(
                              'Forgot Password?',
                              style: ThemeConfig.bodyMedium.copyWith(
                                color: ThemeConfig.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

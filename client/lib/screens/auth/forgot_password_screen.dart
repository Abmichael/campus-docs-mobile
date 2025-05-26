import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // TODO: Implement password reset logic
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset instructions sent to your email'),
          ),
        );
        context.go('/login');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // Icon and Title
                      const Icon(
                        Icons.lock_reset,
                        size: 64,
                        color: ThemeConfig.primaryBlue,
                      ),
                      const SizedBox(height: ThemeConfig.spaceMedium),
                      Text(
                        'Reset Password',
                        style: ThemeConfig.headlineMedium.copyWith(
                          color: ThemeConfig.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: ThemeConfig.spaceSmall),
                      Text(
                        'Enter your email address and we\'ll send you instructions to reset your password.',
                        textAlign: TextAlign.center,
                        style: ThemeConfig.bodyMedium.copyWith(
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
                      const SizedBox(height: ThemeConfig.spaceLarge),
                      
                      // Reset Button
                      if (_isLoading)
                        const LoadingWidget(message: 'Sending reset instructions...')
                      else
                        ActionButton(
                          onPressed: _handleSubmit,
                          text: 'Send Reset Instructions',
                          icon: Icons.send,
                        ),
                      const SizedBox(height: ThemeConfig.spaceMedium),
                      
                      // Back to Login
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(
                          'Back to Login',
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
  }
}

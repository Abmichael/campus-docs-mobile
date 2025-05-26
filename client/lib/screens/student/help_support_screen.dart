import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../widgets/common_widgets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              decoration: BoxDecoration(
                gradient: ThemeConfig.softBlueGradient,
                borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                boxShadow: ThemeConfig.cardShadow,
              ),
              padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'We\'re Here to Help',
                          style: ThemeConfig.headlineMedium.copyWith(
                            color: ThemeConfig.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: ThemeConfig.spaceSmall),
                        Text(
                          'Find answers to common questions or get in touch with our support team',
                          style: ThemeConfig.bodyMedium.copyWith(
                            color: ThemeConfig.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.support_agent,
                    size: 48,
                    color: ThemeConfig.primaryBlue.withOpacity(0.7),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConfig.spaceLarge),

            // Quick Actions
            const SectionHeader(
              title: 'Quick Actions',
              subtitle: 'Get help instantly',
            ),
            const SizedBox(height: ThemeConfig.spaceMedium),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: ThemeConfig.spaceMedium,
              crossAxisSpacing: ThemeConfig.spaceMedium,
              childAspectRatio: 0.8,
              children: [
                _QuickActionCard(
                  icon: Icons.phone,
                  title: 'Call Support',
                  subtitle: '+1 (617) 253-1000',
                  onTap: () => _showCallDialog(context),
                ),
                _QuickActionCard(
                  icon: Icons.email,
                  title: 'Email Support',
                  subtitle: 'support@mit.edu',
                  onTap: () => _showEmailDialog(context),
                ),
                _QuickActionCard(
                  icon: Icons.chat,
                  title: 'Live Chat',
                  subtitle: 'Available 9-5 EST',
                  onTap: () => _showChatDialog(context),
                ),
                _QuickActionCard(
                  icon: Icons.location_on,
                  title: 'Visit Office',
                  subtitle: 'Room 3-103',
                  onTap: () => _showLocationDialog(context),
                ),
              ],
            ),

            const SizedBox(height: ThemeConfig.spaceLarge),

            // FAQ Section
            const SectionHeader(
              title: 'Frequently Asked Questions',
              subtitle: 'Find answers to common questions',
            ),
            const SizedBox(height: ThemeConfig.spaceMedium),

            ..._buildFAQItems(),

            const SizedBox(height: ThemeConfig.spaceLarge),

            // Resources Section
            const SectionHeader(
              title: 'Additional Resources',
              subtitle: 'Helpful links and information',
            ),
            const SizedBox(height: ThemeConfig.spaceMedium),

            _ResourceCard(
              icon: Icons.book,
              title: 'User Guide',
              description: 'Complete guide on how to use the MIT Mobile app',
              onTap: () => _showUserGuideDialog(context),
            ),
            const SizedBox(height: ThemeConfig.spaceMedium),
            _ResourceCard(
              icon: Icons.policy,
              title: 'Privacy Policy',
              description: 'Learn how we protect your personal information',
              onTap: () => _showPrivacyPolicyDialog(context),
            ),
            const SizedBox(height: ThemeConfig.spaceMedium),
            _ResourceCard(
              icon: Icons.info,
              title: 'About MIT',
              description: 'Learn more about Massachusetts Institute of Technology',
              onTap: () => _showAboutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFAQItems() {
    final faqs = [
      {
        'question': 'How long does it take to process a document request?',
        'answer': 'Most document requests are processed within 3-5 business days. Transcripts may take up to 7-10 business days during peak periods.',
      },
      {
        'question': 'How do I track the status of my request?',
        'answer': 'You can track your request status by going to "Request History" from the main dashboard. You\'ll see real-time updates on the progress of your requests.',
      },
      {
        'question': 'Can I cancel a request after submitting it?',
        'answer': 'Yes, you can cancel a request as long as it hasn\'t been processed yet. Contact support if you need to cancel a request that\'s already in progress.',
      },
      {
        'question': 'What document formats are available for download?',
        'answer': 'All documents are provided in PDF format to ensure compatibility and maintain official formatting. Some documents may also be available in other formats upon request.',
      },
      {
        'question': 'Is there a fee for document requests?',
        'answer': 'Basic transcripts and letters are provided free of charge for current students. Alumni may be subject to processing fees for certain documents.',
      },
    ];

    return faqs.map((faq) => _FAQItem(
      question: faq['question']!,
      answer: faq['answer']!,
    )).toList();
  }

  void _showCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Support'),
        content: const Text('Would you like to call MIT Support at +1 (617) 253-1000?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual phone call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening phone app...')),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _showEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Support'),
        content: const Text('Would you like to send an email to support@mit.edu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual email
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening email app...')),
              );
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _showChatDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat feature coming soon!'),
        backgroundColor: ThemeConfig.primaryBlue,
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Visit Our Office'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MIT Student Services Office'),
            SizedBox(height: ThemeConfig.spaceSmall),
            Text('Building 3, Room 103'),
            Text('77 Massachusetts Avenue'),
            Text('Cambridge, MA 02139'),
            SizedBox(height: ThemeConfig.spaceSmall),
            Text('Office Hours:'),
            Text('Monday - Friday: 9:00 AM - 5:00 PM'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement map integration
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening maps...')),
              );
            },
            child: const Text('Get Directions'),
          ),
        ],
      ),
    );
  }

  void _showUserGuideDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User guide will be available soon!'),
        backgroundColor: ThemeConfig.primaryBlue,
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy policy will be available soon!'),
        backgroundColor: ThemeConfig.primaryBlue,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About MIT'),
        content: const Text(
          'The Massachusetts Institute of Technology (MIT) is a private research university in Cambridge, Massachusetts. '
          'Established in 1861, MIT has since been at the forefront of science, technology, and innovation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
              decoration: BoxDecoration(
                color: ThemeConfig.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
              ),
              child: Icon(
                icon,
                size: 28,
                color: ThemeConfig.primaryBlue,
              ),
            ),
            const SizedBox(height: ThemeConfig.spaceSmall),
            Text(
              title,
              textAlign: TextAlign.center,
              style: ThemeConfig.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ThemeConfig.spaceXSmall),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: ThemeConfig.bodySmall.copyWith(
                color: ThemeConfig.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      margin: const EdgeInsets.only(bottom: ThemeConfig.spaceMedium),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: ThemeConfig.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: ThemeConfig.primaryBlue,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ThemeConfig.spaceMedium,
                0,
                ThemeConfig.spaceMedium,
                ThemeConfig.spaceMedium,
              ),
              child: Text(
                widget.answer,
                style: ThemeConfig.bodyMedium.copyWith(
                  color: ThemeConfig.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ResourceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spaceMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConfig.spaceSmall),
              decoration: BoxDecoration(
                color: ThemeConfig.accentTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
              ),
              child: Icon(
                icon,
                color: ThemeConfig.accentTeal,
                size: 24,
              ),
            ),
            const SizedBox(width: ThemeConfig.spaceMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ThemeConfig.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: ThemeConfig.spaceXSmall),
                  Text(
                    description,
                    style: ThemeConfig.bodySmall.copyWith(
                      color: ThemeConfig.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: ThemeConfig.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

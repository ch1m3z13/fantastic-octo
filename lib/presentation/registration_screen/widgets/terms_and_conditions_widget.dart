import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Terms and conditions acceptance widget
class TermsAndConditionsWidget extends StatelessWidget {
  final bool termsAccepted;
  final bool privacyAccepted;
  final Function(bool?) onTermsChanged;
  final Function(bool?) onPrivacyChanged;

  const TermsAndConditionsWidget({
    super.key,
    required this.termsAccepted,
    required this.privacyAccepted,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
  });

  void _showTermsDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Abuja Commuter',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. Acceptance of Terms\n\n'
                'By using Abuja Commuter, you agree to these terms and conditions. '
                'If you do not agree, please do not use our services.\n\n'
                '2. User Responsibilities\n\n'
                '• Provide accurate registration information\n'
                '• Maintain account security\n'
                '• Comply with all applicable laws\n'
                '• Respect other users and drivers\n\n'
                '3. Driver Requirements\n\n'
                '• Valid driver\'s license\n'
                '• Vehicle registration and insurance\n'
                '• Clean driving record\n'
                '• Professional conduct\n\n'
                '4. Payment Terms\n\n'
                '• All payments processed through secure wallet system\n'
                '• No cash transactions permitted\n'
                '• Refund policy applies to cancelled rides\n\n'
                '5. Safety and Security\n\n'
                '• Pre-verified passenger manifests\n'
                '• QR code verification required\n'
                '• Virtual Bus Stop system for safety\n\n'
                '6. Limitation of Liability\n\n'
                'Abuja Commuter is a platform connecting riders and drivers. '
                'We are not responsible for actions of users.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Privacy Matters',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. Information We Collect\n\n'
                '• Personal information (name, phone, email)\n'
                '• Location data for ride services\n'
                '• Payment information\n'
                '• Vehicle information (drivers only)\n\n'
                '2. How We Use Your Information\n\n'
                '• Provide ridesharing services\n'
                '• Process payments\n'
                '• Improve user experience\n'
                '• Ensure safety and security\n\n'
                '3. Information Sharing\n\n'
                '• We do not sell your personal information\n'
                '• Limited sharing with drivers/riders for ride coordination\n'
                '• Compliance with legal requirements\n\n'
                '4. Data Security\n\n'
                '• Encrypted data transmission\n'
                '• Secure storage systems\n'
                '• Regular security audits\n\n'
                '5. Your Rights\n\n'
                '• Access your personal data\n'
                '• Request data deletion\n'
                '• Opt-out of marketing communications\n\n'
                '6. Contact Us\n\n'
                'For privacy concerns, contact: privacy@abujacommuter.ng',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Terms of Service Checkbox
        InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTermsChanged(!termsAccepted);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: termsAccepted,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  onTermsChanged(value);
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(text: 'I agree to the '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _showTermsDialog(context);
                            },
                            child: Text(
                              'Terms of Service',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
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
        SizedBox(height: 8),

        // Privacy Policy Checkbox
        InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onPrivacyChanged(!privacyAccepted);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: privacyAccepted,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  onPrivacyChanged(value);
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(text: 'I agree to the '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _showPrivacyDialog(context);
                            },
                            child: Text(
                              'Privacy Policy',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
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
      ],
    );
  }
}

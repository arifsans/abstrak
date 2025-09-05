import 'package:abstrak/main.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'PRIVACY POLICY',
          style: customTextTheme.titleLarge?.copyWith(
            fontFamily: 'Kenzo',
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? const EdgeInsets.all(16)
            : EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .2,
                vertical: 24,
              ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'CAPTIVE GUILD',
                      style: customTextTheme.displayMedium?.copyWith(
                        fontSize: ResponsiveBreakpoints.of(context).isDesktop 
                            ? 48 
                            : 36,
                        color: const Color(0xFF00bcd5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Privacy Policy',
                      style: customTextTheme.bodyLarge?.copyWith(
                        color: Colors.grey[300],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: September 6, 2025',
                      style: customTextTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Introduction
              _buildSection(
                title: '1. INTRODUCTION',
                content: 'CAPTIVE Guild ("we," "us," or "our") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our guild services, website, and community platforms.',
              ),

              // Information We Collect
              _buildSection(
                title: '2. INFORMATION WE COLLECT',
                content: 'We may collect the following types of information:\n\n'
                    '• Personal Information: Name, email address, phone number\n'
                    '• Account Information: Username, password, profile information\n'
                    '• Game Data: Character information, guild activities, statistics\n'
                    '• Communication Data: Messages, chat logs, forum posts\n'
                    '• Technical Data: IP address, device information, browser type\n'
                    '• Usage Data: How you interact with our services',
              ),

              // How We Use Information
              _buildSection(
                title: '3. HOW WE USE YOUR INFORMATION',
                content: 'We use the collected information for the following purposes:\n\n'
                    '• To provide and maintain our guild services\n'
                    '• To manage your account and membership\n'
                    '• To facilitate guild activities and communications\n'
                    '• To improve our services and user experience\n'
                    '• To send important notifications and updates\n'
                    '• To ensure community safety and enforce our rules\n'
                    '• To comply with legal obligations',
              ),

              // Information Sharing
              _buildSection(
                title: '4. INFORMATION SHARING AND DISCLOSURE',
                content: 'We do not sell, trade, or rent your personal information to third parties. We may share your information in the following circumstances:\n\n'
                    '• With your consent or at your direction\n'
                    '• With other guild members for community purposes\n'
                    '• With service providers who assist in our operations\n'
                    '• To comply with legal requirements or protect rights\n'
                    '• In connection with a business transfer or merger',
              ),

              // Data Security
              _buildSection(
                title: '5. DATA SECURITY',
                content: 'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
              ),

              // Data Retention
              _buildSection(
                title: '6. DATA RETENTION',
                content: 'We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law. When we no longer need your information, we will securely delete or anonymize it.',
              ),

              // Your Rights
              _buildSection(
                title: '7. YOUR PRIVACY RIGHTS',
                content: 'Depending on your location, you may have the following rights:\n\n'
                    '• Access: Request copies of your personal information\n'
                    '• Rectification: Request correction of inaccurate information\n'
                    '• Erasure: Request deletion of your personal information\n'
                    '• Portability: Request transfer of your data\n'
                    '• Objection: Object to processing of your information\n'
                    '• Withdrawal: Withdraw consent at any time',
              ),

              // Cookies and Tracking
              _buildSection(
                title: '8. COOKIES AND TRACKING TECHNOLOGIES',
                content: 'We may use cookies and similar tracking technologies to enhance your experience on our website and services. You can control cookie settings through your browser preferences.',
              ),

              // Third-Party Services
              _buildSection(
                title: '9. THIRD-PARTY SERVICES',
                content: 'Our services may contain links to third-party websites or integrate with third-party services (such as Discord, Facebook, or game platforms). This Privacy Policy does not apply to third-party services, and we encourage you to review their privacy policies.',
              ),

              // Children's Privacy
              _buildSection(
                title: '10. CHILDREN\'S PRIVACY',
                content: 'Our services are not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If you become aware that a child has provided us with personal information, please contact us.',
              ),

              // International Data Transfers
              _buildSection(
                title: '11. INTERNATIONAL DATA TRANSFERS',
                content: 'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your information during such transfers.',
              ),

              // Changes to Privacy Policy
              _buildSection(
                title: '12. CHANGES TO THIS PRIVACY POLICY',
                content: 'We may update this Privacy Policy from time to time. We will notify you of any material changes by posting the new Privacy Policy on our website and updating the "Last updated" date.',
              ),

              // Contact Information
              _buildSection(
                title: '13. CONTACT US',
                content: 'If you have any questions about this Privacy Policy or our privacy practices, please contact us:\n\n'
                    '• Discord: https://discord.gg/g3wvaQHqMD\n'
                    '• Facebook: https://www.facebook.com/CaptiveG\n'
                    '• In-game: Find us @YORUMI HACHIKO-6666\n\n'
                    'For privacy-specific inquiries, please mention "Privacy Policy" in your message.',
              ),

              const SizedBox(height: 32),

              // Footer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00bcd5)),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      color: const Color(0xFF00bcd5),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'YOUR PRIVACY MATTERS',
                      style: customTextTheme.titleLarge?.copyWith(
                        fontFamily: 'Kenzo',
                        color: const Color(0xFF00bcd5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We are committed to protecting your personal information and respecting your privacy choices.',
                      style: courierText.bodyMedium?.copyWith(
                        color: Colors.grey[300],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'By using our services, you acknowledge that you have read and understood this Privacy Policy.',
                      style: courierText.bodySmall?.copyWith(
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.privacy_tip_outlined,
                color: const Color(0xFF00bcd5),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: customTextTheme.titleLarge?.copyWith(
                    fontFamily: 'Kenzo',
                    color: const Color(0xFF00bcd5),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.2),
            ),
            child: Text(
              content,
              style: courierText.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
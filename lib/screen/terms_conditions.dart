import 'package:abstrak/main.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TermsCondition extends StatelessWidget {
  const TermsCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'TERMS & CONDITIONS',
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
                      'Terms and Conditions of Service',
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
                content: 'Welcome to CAPTIVE Guild! These Terms and Conditions ("Terms") govern your use of our guild services, website, and community platforms. By accessing or using our services, you agree to be bound by these Terms.',
              ),

              // Acceptance of Terms
              _buildSection(
                title: '2. ACCEPTANCE OF TERMS',
                content: 'By creating an account, participating in guild activities, or using any of our services, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy.',
              ),

              // Guild Membership
              _buildSection(
                title: '3. GUILD MEMBERSHIP',
                content: 'Membership in CAPTIVE Guild is subject to the following conditions:\n\n'
                    '• You must provide accurate and complete information during registration\n'
                    '• You must be at least 13 years of age to join\n'
                    '• You agree to maintain the confidentiality of your account credentials\n'
                    '• You are responsible for all activities that occur under your account',
              ),

              // Code of Conduct
              _buildSection(
                title: '4. CODE OF CONDUCT',
                content: 'All guild members must adhere to our community standards:\n\n'
                    '• Treat all members with respect and courtesy\n'
                    '• No harassment, discrimination, or hate speech\n'
                    '• No cheating, exploiting, or use of unauthorized software\n'
                    '• No sharing of inappropriate or offensive content\n'
                    '• Follow all game rules and regulations',
              ),

              // Guild Activities
              _buildSection(
                title: '5. GUILD ACTIVITIES',
                content: 'CAPTIVE Guild organizes various activities including:\n\n'
                    '• Guild wars and competitions\n'
                    '• Community events and gatherings\n'
                    '• Training sessions and tutorials\n'
                    '• Social activities and discussions\n\n'
                    'Participation in these activities is voluntary and subject to additional rules that may be specified for each event.',
              ),

              // Intellectual Property
              _buildSection(
                title: '6. INTELLECTUAL PROPERTY',
                content: 'All content, logos, designs, and materials related to CAPTIVE Guild are protected by intellectual property laws. You may not use our intellectual property without express written permission.',
              ),

              // Privacy and Data
              _buildSection(
                title: '7. PRIVACY AND DATA PROTECTION',
                content: 'We are committed to protecting your privacy. Our collection and use of personal information is governed by our Privacy Policy, which is incorporated into these Terms by reference.',
              ),

              // Limitation of Liability
              _buildSection(
                title: '8. LIMITATION OF LIABILITY',
                content: 'CAPTIVE Guild and its officers shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of our services or participation in guild activities.',
              ),

              // Termination
              _buildSection(
                title: '9. TERMINATION',
                content: 'We reserve the right to terminate or suspend your membership at any time for violation of these Terms or for any other reason deemed appropriate by guild leadership.',
              ),

              // Changes to Terms
              _buildSection(
                title: '10. CHANGES TO TERMS',
                content: 'We reserve the right to modify these Terms at any time. Changes will be effective immediately upon posting. Your continued use of our services constitutes acceptance of the revised Terms.',
              ),

              // Contact Information
              _buildSection(
                title: '11. CONTACT INFORMATION',
                content: 'If you have any questions about these Terms, please contact us:\n\n'
                    '• Discord: https://discord.gg/g3wvaQHqMD\n'
                    '• Facebook: https://www.facebook.com/CaptiveG\n'
                    '• In-game: Find us @YORUMI HACHIKO-6666',
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
                    Text(
                      'CAPTIVE GUILD',
                      style: customTextTheme.titleLarge?.copyWith(
                        fontFamily: 'Kenzo',
                        color: const Color(0xFF00bcd5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"IT\'S ONLY AFTER WE\'VE LOST EVERYTHING\nTHAT WE\'RE FREE TO DO ANYTHING"',
                      style: customTextTheme.bodyMedium?.copyWith(
                        fontFamily: 'Kenzo',
                        color: Colors.grey[300],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'By using our services, you acknowledge that you have read and understood these Terms and Conditions.',
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
          Text(
            title,
            style: customTextTheme.titleLarge?.copyWith(
              fontFamily: 'Kenzo',
              color: const Color(0xFF00bcd5),
              letterSpacing: 1.2,
            ),
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
import 'package:abstrak/main.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Manifesto extends StatelessWidget {
  const Manifesto({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? const EdgeInsets.all(16)
            : EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .2,
                vertical: 32,
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'OUR MANIFESTO',
              style: customTextTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Guild Mission Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Mission',
                    style: customTextTheme.headlineSmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We are a game-based community united by our passion for art and creativity. Our guild exists to support talented artists and provide them with a platform to showcase their incredible artworks to the world.',
                    style: customTextTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Vision Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Vision',
                    style: customTextTheme.headlineSmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'To create a thriving ecosystem where artists receive the recognition they deserve. We believe every artwork tells a story, and every artist deserves to be highlighted and celebrated by the community.',
                    style: customTextTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Values Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Values',
                    style: customTextTheme.headlineSmall,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 16),
                  _buildValueItem('🎨', 'Creativity',
                      'We celebrate diverse artistic expressions and encourage innovative approaches to art.'),
                  const SizedBox(height: 12),
                  _buildValueItem('🤝', 'Community',
                      'We foster a supportive environment where artists can connect, collaborate, and grow together.'),
                  const SizedBox(height: 12),
                  _buildValueItem('⭐', 'Recognition',
                      'We ensure that talented artists receive the spotlight and appreciation they deserve.'),
                  const SizedBox(height: 12),
                  _buildValueItem('🌟', 'Excellence',
                      'We strive for quality in everything we do, from showcasing art to building our community.'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Call to Action
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withValues(alpha: 0.2),
                    Colors.blue.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Join Our Community',
                    style: customTextTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Whether you\'re an artist looking for recognition or an art enthusiast wanting to discover amazing creations, our guild welcomes you. Together, we build a world where art thrives and artists flourish.',
                    style: customTextTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32), // Add some bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: customTextTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: customTextTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

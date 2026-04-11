import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AiRecommendations extends StatelessWidget {
  const AiRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Recommendations',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecommendation(
              'You seem to be low on protein today. Try adding some chicken or lentils to your dinner.',
              LucideIcons.egg,
            ),
            const SizedBox(height: 12),
            _buildRecommendation(
              'You are close to your step goal! A short walk after dinner will get you there.',
              LucideIcons.footprints,
            ),
            const SizedBox(height: 12),
            _buildRecommendation(
              'You had a great workout yesterday. Make sure to get enough sleep to recover.',
              LucideIcons.bed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 16),
        Expanded(child: Text(text)),
      ],
    );
  }
}

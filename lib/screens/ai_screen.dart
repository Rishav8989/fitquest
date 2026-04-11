import 'package:fitquest/widgets/ai_recommendations.dart';
import 'package:fitquest/widgets/gamification_panel.dart';
import 'package:flutter/material.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'AI Coach',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const GamificationPanel(),
            const SizedBox(height: 24),
            const AiRecommendations(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitquest/screens/ai_food_questionnaire_screen.dart';
import 'package:fitquest/screens/ai_exercise_questionnaire_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuickAddScreen extends StatelessWidget {
  const QuickAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Actions'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What would you like to log?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
              const SizedBox(height: 32),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _HeroCard(
                        title: 'Log Meal',
                        subtitle: 'AI Guide & Custom',
                        icon: LucideIcons.utensilsCrossed,
                        gradientColors: const [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
                        delay: 100.ms,
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AiFoodQuestionnaireScreen()));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _HeroCard(
                        title: 'Workout',
                        subtitle: 'Live Tracking',
                        icon: LucideIcons.dumbbell,
                        gradientColors: const [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
                        delay: 200.ms,
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AiExerciseQuestionnaireScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _HeroCard(
                        title: 'Hydration',
                        subtitle: '+1 Glass',
                        icon: LucideIcons.glassWater,
                        gradientColors: const [Color(0xFF84fab0), Color(0xFF8fd3f4)],
                        delay: 300.ms,
                        onTap: () {
                          // Quick increment logic can go here
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log Water action coming soon!')));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _HeroCard(
                        title: 'Sleep',
                        subtitle: 'Manual Entry',
                        icon: LucideIcons.moonStar,
                        gradientColors: const [Color(0xFFcfd9df), Color(0xFFe2ebf0)],
                        delay: 400.ms,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log Sleep action coming soon!')));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Duration delay;
  final VoidCallback onTap;

  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 10),
            )
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 56,
              color: Colors.black87,
            ).animate().scale(delay: delay + 200.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms, delay: delay).slideY(begin: 0.2, delay: delay),
    );
  }
}

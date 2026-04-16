import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitquest/screens/ai_food_questionnaire_screen.dart';
import 'package:fitquest/screens/ai_exercise_questionnaire_screen.dart';
import 'package:fitquest/screens/sleep_tracking_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class QuickAddScreen extends StatelessWidget {
  const QuickAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                        gradientColors: [cs.primary, cs.secondary],
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
                        gradientColors: [cs.secondary, cs.tertiary],
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
                        subtitle: '+250 ml',
                        icon: LucideIcons.glassWater,
                        gradientColors: [cs.tertiary, cs.primary],
                        delay: 300.ms,
                        onTap: () {
                          context.read<AppState>().addWater(250);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('+250 ml water logged!')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _HeroCard(
                        title: 'Sleep',
                        subtitle: 'Track Tonight',
                        icon: LucideIcons.moonStar,
                        gradientColors: [cs.primary, cs.tertiary],
                        delay: 400.ms,
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SleepTrackingScreen()));
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
              color: gradientColors.last.withValues(alpha: 0.3),
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
              size: 48,
              color: Colors.white,
            ).animate().scale(delay: delay + 200.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
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

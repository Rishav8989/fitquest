import 'package:fitquest/screens/sleep_tracking_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/activity_tracker.dart';
import 'package:fitquest/widgets/animated_counter.dart';
import 'package:fitquest/widgets/animated_scale_tap.dart';
import 'package:fitquest/widgets/daily_summary.dart';
import 'package:fitquest/widgets/habit_tracker.dart';
import 'package:fitquest/widgets/water_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const DashboardHeader(),
            const SizedBox(height: 24),
            const QuickStatsGrid(),
            const SizedBox(height: 24),
            const SleepTrackingCard(),
            const SizedBox(height: 24),
            const DailySummary(),
            const SizedBox(height: 24),
            const WaterTracker(),
            const SizedBox(height: 24),
            const HabitTracker(),
            const SizedBox(height: 24),
            const ActivityTracker(),
          ]
              .animate(
                interval: 60.ms,
              )
              .fadeIn(
                duration: 400.ms,
                curve: Curves.easeOutCubic,
              )
              .slideY(
                begin: 0.06,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutCubic,
              ),
        ),
      ),
    );
  }
}

class SleepTrackingCard extends StatelessWidget {
  const SleepTrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleTap(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SleepTrackingScreen(),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(LucideIcons.bed),
              const SizedBox(width: 16.0),
              const Text(
                'Sleep Tracking',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr =
        '${now.day} ${_month(now.month)} ${now.year}';
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FitQuest',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.primary,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your fitness, your phone',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today, $dateStr',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Row(
              children: [
                Icon(LucideIcons.flame, size: 20, color: cs.primary),
                const SizedBox(width: 4),
                Text(
                  'Let\'s go',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: cs.primary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static String _month(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m - 1];
  }
}

class QuickStatsGrid extends StatelessWidget {
  const QuickStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final steps = appState.steps;
        final calories = appState.todayCalories;
        return Row(
          children: [
            Expanded(
              child: AnimatedScaleTap(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Keep moving to reach your daily step goal!')));
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        const Icon(LucideIcons.footprints,
                            color: Colors.white, size: 28),
                        const SizedBox(height: 8),
                        AnimatedCounter(
                          value: steps,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'Steps Today',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedScaleTap(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log your food to track calories!')));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cs.secondary.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        cs.secondary,
                        cs.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        const Icon(LucideIcons.utensilsCrossed,
                            color: Colors.white, size: 28),
                        const SizedBox(height: 8),
                        AnimatedCounter(
                          value: calories,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'Calories',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

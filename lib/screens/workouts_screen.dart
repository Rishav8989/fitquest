import 'package:fitquest/screens/timer_screen.dart';
import 'package:fitquest/widgets/activity_tracker.dart';
import 'package:fitquest/widgets/exercise_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Workouts',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TimerScreen(),
                      ),
                    );
                  },
                  icon: Icon(LucideIcons.timer, size: 18, color: cs.primary),
                  label: Text('Timer', style: TextStyle(color: cs.primary)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ActivityTracker(),
            const SizedBox(height: 24),
            const ExerciseLog(),
          ]
              .animate(interval: 60.ms)
              .fadeIn(duration: 350.ms, curve: Curves.easeOutCubic)
              .slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }
}

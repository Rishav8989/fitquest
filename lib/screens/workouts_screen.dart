import 'package:fitquest/screens/ai_exercise_questionnaire_screen.dart';
import 'package:fitquest/screens/timer_screen.dart';
import 'package:fitquest/widgets/activity_tracker.dart';
import 'package:fitquest/widgets/animated_scale_tap.dart';
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
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TimerScreen(),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.timer, size: 18),
                  label: const Text('Open Timer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.tertiary,
                    foregroundColor: cs.onTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AnimatedScaleTap(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AiExerciseQuestionnaireScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [cs.primary, cs.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Icon(LucideIcons.plus,
                                color: Colors.white, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Log Exercise',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 350.ms)
                .slideY(begin: 0.05, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),
            const SizedBox(height: 24),
            const ActivityTracker(),
            const SizedBox(height: 24),
            const ExerciseLog(),
          ],
        ),
      ),
    );
  }
}

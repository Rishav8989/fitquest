import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class ExerciseLog extends StatelessWidget {
  const ExerciseLog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final exercises = appState.exercises;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercise Log',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...exercises.asMap().entries.map((entry) {
                  final i = entry.key;
                  final exercise = entry.value;
                  String subtitle = '${exercise.duration} min - ${exercise.calories} kcal';
                  if (exercise.sets != null && exercise.reps != null) {
                    subtitle += '\n${exercise.sets} sets x ${exercise.reps} reps';
                    if (exercise.weight != null) {
                      subtitle += ' @ ${exercise.weight} kg';
                    }
                  } else if (exercise.weight != null) {
                    subtitle += '\n${exercise.weight} kg';
                  }

                  return ListTile(
                    leading: Icon(
                      _getExerciseIcon(exercise.type),
                      color: cs.secondary,
                    ),
                    title: Text(exercise.name),
                    subtitle: Text(subtitle),
                    trailing: IconButton(
                      icon: Icon(LucideIcons.trash, color: cs.error),
                      onPressed: () async {
                        final ok = await showConfirmDialog(
                          context,
                          title: 'Remove exercise?',
                          message:
                              'Remove "${exercise.name}" from your log?',
                          confirmText: 'Remove',
                          isDanger: true,
                        );
                        if (ok && context.mounted) {
                          await appState.removeExercise(exercise);
                        }
                      },
                    ),
                  )
                      .animate(delay: (i * 50).ms)
                      .fadeIn(duration: 280.ms, curve: Curves.easeOut)
                      .slideX(begin: 0.05, end: 0, duration: 280.ms, curve: Curves.easeOut);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getExerciseIcon(String type) {
    switch (type) {
      case 'cardio':
        return LucideIcons.heartPulse;
      case 'strength':
        return LucideIcons.dumbbell;
      case 'flexibility':
        return LucideIcons.stretchHorizontal;
      case 'sports':
        return LucideIcons.goal;
      default:
        return LucideIcons.activity;
    }
  }
}

import 'package:fitquest/screens/add_exercise_screen.dart';
import 'package:fitquest/screens/ai_exercise_questionnaire_screen.dart';
import 'package:fitquest/screens/timer_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class WorkoutDetailPage extends StatelessWidget {
  const WorkoutDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.timer, color: cs.primary),
            tooltip: 'Stopwatch',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TimerScreen())),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final exercises = appState.exercises;
          final burned = appState.todayExerciseCalories;
          final activeMin = appState.todayActiveMinutes;
          final steps = appState.steps;
          final distanceKm = (steps * 0.00076).toStringAsFixed(1);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Activity summary strip
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _activityStat(LucideIcons.footprints, '$steps', 'Steps'),
                    _divider(),
                    _activityStat(LucideIcons.flame, '$burned', 'kcal'),
                    _divider(),
                    _activityStat(LucideIcons.timer, '$activeMin', 'min'),
                    _divider(),
                    _activityStat(LucideIcons.navigation, distanceKm, 'km'),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0, duration: 350.ms),
              const SizedBox(height: 16),
              // Quick actions
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const AddExerciseScreen())),
                      icon: const Icon(LucideIcons.plus, size: 18),
                      label: const Text('Log Exercise'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const AiExerciseQuestionnaireScreen())),
                      icon: Icon(LucideIcons.sparkles, size: 18, color: cs.primary),
                      label: Text('AI Workout', style: TextStyle(color: cs.primary)),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
              const SizedBox(height: 16),
              // Exercise list
              if (exercises.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(LucideIcons.dumbbell, size: 64, color: cs.onSurfaceVariant.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text('No exercises logged yet', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else
                ...exercises.asMap().entries.map((entry) {
                  final i = entry.key;
                  final exercise = entry.value;
                  String subtitle = '${exercise.duration} min · ${exercise.calories} kcal';
                  if (exercise.sets != null && exercise.reps != null) {
                    subtitle += '\n${exercise.sets} sets × ${exercise.reps} reps';
                    if (exercise.weight != null) subtitle += ' @ ${exercise.weight} kg';
                  }
                  return Dismissible(
                    key: ValueKey(exercise.id ?? i),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(LucideIcons.trash, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showConfirmDialog(
                        context,
                        title: 'Remove exercise?',
                        message: 'Remove "${exercise.name}" from your log?',
                        confirmText: 'Remove',
                        isDanger: true,
                      );
                    },
                    onDismissed: (direction) => appState.removeExercise(exercise),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: cs.secondaryContainer,
                          child: Icon(_getExerciseIcon(exercise.type), color: cs.secondary, size: 20),
                        ),
                        title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(subtitle),
                      ),
                    ),
                  ).animate(delay: (i * 40).ms).fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0, duration: 250.ms);
                }),
            ],
          );
        },
      ),
    );
  }

  Widget _activityStat(IconData icon, String value, String label) {
    return Column(children: [
      Icon(icon, color: Colors.white, size: 18),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ]);
  }

  Widget _divider() {
    return Container(width: 1, height: 40, color: Colors.white24);
  }

  static IconData _getExerciseIcon(String type) {
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

import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

/// Shows steps from device motion sensor (Android). No external devices.
class ActivityTracker extends StatelessWidget {
  const ActivityTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final steps = appState.steps;
        final distanceKm = (steps * 0.00076).toStringAsFixed(1);
        final activeMin = appState.todayActiveMinutes;
        final burned = appState.todayExerciseCalories;
        final cs = Theme.of(context).colorScheme;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Activity',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Icon(LucideIcons.smartphone, size: 18, color: cs.primary),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Steps from your phone’s motion sensor',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                _buildActivityRow(
                    context, LucideIcons.footprints, 'Steps',
                    '${steps.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]},',
                        )} / 10,000'),
                const SizedBox(height: 16),
                _buildActivityRow(
                    context, LucideIcons.timer, 'Active Minutes', '$activeMin min'),
                const SizedBox(height: 16),
                _buildActivityRow(
                    context, LucideIcons.flame, 'Calories Burned', '$burned kcal'),
                const SizedBox(height: 16),
                _buildActivityRow(
                    context, LucideIcons.map, 'Distance', '$distanceKm km'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityRow(
      BuildContext context, IconData icon, String title, String value) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 28, color: cs.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface)),
        ),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: cs.primary)),
      ],
    );
  }
}

import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/animated_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailySummary extends StatelessWidget {
  const DailySummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final calories = appState.todayCalories;
        final protein = appState.todayProtein;
        final carbs = appState.todayCarbs;
        final fat = appState.todayFat;
        final fiber = appState.todayFiber;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Summary',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildMacroRow(
                    context, 'Calories', calories, appState.calorieGoal, 'kcal', cs.primary),
                const SizedBox(height: 16),
                _buildMacroRow(
                    context, 'Protein', protein, appState.proteinGoal, 'g', cs.tertiary),
                const SizedBox(height: 16),
                _buildMacroRow(
                    context, 'Carbs', carbs, appState.carbsGoal, 'g', cs.secondary),
                const SizedBox(height: 16),
                _buildMacroRow(
                    context, 'Fat', fat, appState.fatGoal, 'g', const Color(0xFFA855F7)),
                const SizedBox(height: 16),
                _buildMacroRow(
                    context, 'Fiber', fiber, appState.fiberGoal, 'g', const Color(0xFFD97706)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMacroRow(BuildContext context, String title, int current,
      int goal, String unit, Color color) {
    double percent = goal > 0 ? (current / goal) : 0;
    if (percent > 1.0) percent = 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700)),
            Text('$current / $goal $unit',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedProgressBar(
          percent: percent,
          progressColor: color,
          height: 10,
          radius: 5,
        ),
      ],
    );
  }
}

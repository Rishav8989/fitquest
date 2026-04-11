import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  final _amountController = TextEditingController(text: '250');

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    double percent = appState.waterIntake / appState.waterGoal;
    if (percent > 1.0) percent = 1.0;
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Water Tracker',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percent),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  percent: value,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.glassWater, size: 40, color: cs.primary),
                      Text(
                        '${appState.waterIntake} / ${appState.waterGoal} ml',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  progressColor: cs.primary,
                  backgroundColor: cs.primaryContainer.withOpacity(0.5),
                  circularStrokeCap: CircularStrokeCap.round,
                );
              },
            ),
            const SizedBox(height: 16),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount (ml)',
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    final amount = int.tryParse(_amountController.text) ?? 0;
                    if (amount > 0) {
                      await appState.addWater(amount);
                    }
                  },
                  child: const Text('Add'),
                ),
                FilledButton(
                  onPressed: () async {
                    final amount = int.tryParse(_amountController.text) ?? 0;
                    if (amount > 0) {
                      await appState.removeWater(amount);
                    }
                  },
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

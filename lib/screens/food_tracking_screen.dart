import 'package:fitquest/screens/add_food_screen.dart';
import 'package:fitquest/widgets/daily_summary.dart';
import 'package:fitquest/widgets/food_log.dart';
import 'package:fitquest/widgets/water_tracker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FoodTrackingScreen extends StatelessWidget {
  const FoodTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'Nutrition',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddFoodScreen(),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: const Text('Log Food'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const DailySummary(),
            const SizedBox(height: 24),
            const WaterTracker(),
            const SizedBox(height: 24),
            const FoodLog(),
          ],
        ),
      ),
    );
  }
}

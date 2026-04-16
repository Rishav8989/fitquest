import 'package:fitquest/widgets/food_log.dart';
import 'package:flutter/material.dart';

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
            Text(
              'Nutrition',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const FoodLog(),
          ],
        ),
      ),
    );
  }
}

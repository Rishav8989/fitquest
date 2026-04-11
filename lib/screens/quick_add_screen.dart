import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitquest/screens/add_food_screen.dart';
import 'package:fitquest/screens/add_exercise_screen.dart';

class QuickAddScreen extends StatelessWidget {
  const QuickAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Add')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(LucideIcons.utensilsCrossed),
            title: const Text('Add Food'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddFoodScreen()));
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.dumbbell),
            title: const Text('Add Exercise'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddExerciseScreen()));
            },
          ),
        ],
      ),
    );
  }
}

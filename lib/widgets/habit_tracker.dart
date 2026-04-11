import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitquest/screens/edit_habits_screen.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({super.key});

  @override
  State<HabitTracker> createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  List<Habit> _habits = [
    Habit(
        name: 'Drink 8 glasses of water',
        icon: LucideIcons.glassWater,
        isCompleted: true),
    Habit(
        name: 'Exercise for 30 minutes',
        icon: LucideIcons.dumbbell,
        isCompleted: false),
    Habit(name: 'Sleep 8 hours', icon: LucideIcons.bed, isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Tracker',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: ValueKey(_habits.length),
                children: _habits.map((habit) {
                  return CheckboxListTile(
                    secondary: Icon(habit.icon),
                    title: Text(habit.name),
                    value: habit.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        habit.isCompleted = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  final updatedHabits = await Navigator.push<List<Habit>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditHabitsScreen(initialHabits: _habits),
                    ),
                  );
                  if (updatedHabits != null) {
                    setState(() {
                      _habits = updatedHabits;
                    });
                  }
                },
                child: const Text('Edit Habits'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Habit {
  final String name;
  final IconData icon;
  bool isCompleted;

  Habit({required this.name, required this.icon, this.isCompleted = false});
}

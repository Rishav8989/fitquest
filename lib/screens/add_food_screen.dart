import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

final _indianMeals = [
  ('Idli (2 pcs)', 120, 4, 22, 2, 2, '2 pcs'),
  ('Dosa', 150, 3, 28, 4, 2, '1 piece'),
  ('Poha', 250, 6, 45, 8, 3, '1 bowl'),
  ('Upma', 200, 5, 30, 6, 2, '1 bowl'),
  ('Paratha', 280, 8, 35, 10, 3, '1 piece'),
  ('Dal Rice', 350, 12, 55, 8, 5, '1 plate'),
  ('Rajma Chawal', 400, 15, 60, 10, 8, '1 plate'),
  ('Chole Bhature', 450, 12, 55, 18, 6, '1 serving'),
  ('Biryani', 500, 18, 65, 15, 2, '1 plate'),
  ('Samosa (2 pcs)', 300, 5, 35, 15, 3, '2 pcs'),
  ('Chaat', 200, 6, 28, 8, 4, '1 plate'),
  ('Apple', 95, 0, 25, 0, 4, '1 medium'),
  ('Banana', 105, 1, 27, 0, 3, '1 medium'),
  ('Chicken Salad', 350, 30, 10, 20, 5, '1 bowl'),
];

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  String name = _indianMeals.first.$1;
  int calories = _indianMeals.first.$2;
  int protein = _indianMeals.first.$3;
  int carbs = _indianMeals.first.$4;
  int fat = _indianMeals.first.$5;
  int fiber = _indianMeals.first.$6;
  String serving = _indianMeals.first.$7;
  String mealType = _mealTypes.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Food'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: name,
              decoration: const InputDecoration(
                labelText: 'Food',
              ),
              items: _indianMeals
                  .map((m) => DropdownMenuItem(
                        value: m.$1,
                        child: Text(m.$1),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                final m = _indianMeals.firstWhere((e) => e.$1 == v);
                setState(() {
                  name = m.$1;
                  calories = m.$2;
                  protein = m.$3;
                  carbs = m.$4;
                  fat = m.$5;
                  fiber = m.$6;
                  serving = m.$7;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: mealType,
              decoration: const InputDecoration(
                labelText: 'Meal type',
              ),
              items: _mealTypes
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => mealType = v ?? mealType),
            ),
            const SizedBox(height: 8),
            Text(
              '$calories kcal · P: $protein C: $carbs F: $fat · $serving',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () async {
                final item = FoodItem(
                  name: name,
                  calories: calories,
                  protein: protein,
                  carbs: carbs,
                  fat: fat,
                  fiber: fiber,
                  serving: serving,
                  mealType: mealType,
                  date: DateTime.now().toIso8601String(),
                );
                final ok = await showConfirmDialog(
                  context,
                  title: 'Add food?',
                  message: 'Add "$name" ($calories kcal) to your log?',
                  confirmText: 'Add',
                );
                if (ok && context.mounted) {
                  await context.read<AppState>().addFood(item);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

class EditFoodScreen extends StatefulWidget {
  final FoodItem foodItem;
  const EditFoodScreen({super.key, required this.foodItem});

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  late String mealType;
  late String serving;
  late TextEditingController servingController;

  @override
  void initState() {
    super.initState();
    mealType = widget.foodItem.mealType;
    serving = widget.foodItem.serving;
    servingController = TextEditingController(text: serving);
  }

  @override
  void dispose() {
    servingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.foodItem.name;
    final calories = widget.foodItem.calories;
    final protein = widget.foodItem.protein;
    final carbs = widget.foodItem.carbs;
    final fat = widget.foodItem.fat;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Food')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
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
            const SizedBox(height: 12),
            TextFormField(
              controller: servingController,
              decoration: const InputDecoration(
                labelText: 'Serving Size',
              ),
              onChanged: (value) {
                serving = value;
              },
            ),
            const SizedBox(height: 8),
            Text(
              '$calories kcal · P: $protein C: $carbs F: $fat',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final updatedFoodItem = widget.foodItem.copyWith(
                    mealType: mealType,
                    serving: serving,
                  );
                  await context.read<AppState>().updateFood(updatedFoodItem);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:fitquest/screens/edit_food_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class FoodLog extends StatelessWidget {
  const FoodLog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final foods = appState.foods;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Food Log',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...foods.asMap().entries.map((entry) {
                  final i = entry.key;
                  final food = entry.value;
                  return ListTile(
                    leading: Icon(
                      _getMealIcon(food.mealType),
                      color: cs.primary,
                    ),
                    title: Text(food.name),
                    subtitle: Text(
                        '${food.calories} kcal - ${food.serving}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(LucideIcons.edit, color: cs.primary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditFoodScreen(foodItem: food),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(LucideIcons.trash, color: cs.error),
                          onPressed: () async {
                            final ok = await showConfirmDialog(
                              context,
                              title: 'Remove food?',
                              message:
                                  'Remove "${food.name}" from your log?',
                              confirmText: 'Remove',
                              isDanger: true,
                            );
                            if (ok && context.mounted) {
                              await appState.removeFood(food);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                      .animate(delay: (i * 50).ms)
                      .fadeIn(duration: 280.ms, curve: Curves.easeOut)
                      .slideX(begin: 0.05, end: 0, duration: 280.ms, curve: Curves.easeOut);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return LucideIcons.sunrise;
      case 'Lunch':
        return LucideIcons.sun;
      case 'Dinner':
        return LucideIcons.moon;
      case 'Snack':
        return LucideIcons.cookie;
      default:
        return LucideIcons.utensils;
    }
  }
}

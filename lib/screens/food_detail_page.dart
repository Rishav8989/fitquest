import 'package:fitquest/screens/add_food_screen.dart';
import 'package:fitquest/screens/edit_food_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class FoodDetailPage extends StatelessWidget {
  const FoodDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final foods = appState.foods;
          if (foods.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.utensilsCrossed, size: 64, color: cs.onSurfaceVariant.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('No food logged yet', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16)),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFoodScreen())),
                    icon: const Icon(LucideIcons.plus, size: 18),
                    label: const Text('Add Food'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return Dismissible(
                key: ValueKey(food.id ?? index),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  child: const Icon(LucideIcons.trash, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showConfirmDialog(
                    context,
                    title: 'Remove food?',
                    message: 'Remove "${food.name}" from your log?',
                    confirmText: 'Remove',
                    isDanger: true,
                  );
                },
                onDismissed: (direction) => appState.removeFood(food),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cs.primaryContainer,
                      child: Icon(_getMealIcon(food.mealType), color: cs.primary, size: 20),
                    ),
                    title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${food.calories} kcal · ${food.serving} · P:${food.protein}g C:${food.carbs}g F:${food.fat}g'),
                    trailing: IconButton(
                      icon: Icon(LucideIcons.edit, color: cs.primary, size: 18),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditFoodScreen(foodItem: food))),
                    ),
                  ),
                ).animate(delay: (index * 40).ms).fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0, duration: 250.ms),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFoodScreen())),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Add Food'),
      ),
    );
  }

  static IconData _getMealIcon(String mealType) {
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

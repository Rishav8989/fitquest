import os
import re

file_path = '/home/server/etc/fitquest/lib/screens/ai_food_questionnaire_screen.dart'
with open(file_path, 'r') as f:
    content = f.read()

content = content.replace("import 'package:provider/provider.dart';", "import 'package:provider/provider.dart';\nimport 'package:fitquest/data/massive_datasets.dart';\nimport 'dart:math';")

# Remove _indianMeals
content = re.sub(r'final _indianMeals = \[.*?\];', '', content, flags=re.DOTALL)

old_generate = '''  void _generateRecommendations() {
    _recommendedFoods.clear();
    _selectedFoodIndices.clear();

    // Filter by focus if possible
    var filtered = _indianMeals.where((f) => f.$8 == (_mealType ?? 'Snack')).toList();
    if (filtered.isEmpty) filtered = List.from(_indianMeals);

    var highlyRecommended = filtered.where((f) => f.$9 == _focus).toList();
    if (highlyRecommended.isNotEmpty) {
      for (var f in highlyRecommended.take(3)) {
        _recommendedFoods.add(FoodItem(name: f.$1, calories: f.$2, protein: f.$3, carbs: f.$4, fat: f.$5, fiber: f.$6, mealType: _mealType ?? 'Snack', serving: f.$7, date: DateTime.now().toIso8601String()));
      }
    } else {
      for (var f in filtered.take(3)) {
        _recommendedFoods.add(FoodItem(name: f.$1, calories: f.$2, protein: f.$3, carbs: f.$4, fat: f.$5, fiber: f.$6, mealType: _mealType ?? 'Snack', serving: f.$7, date: DateTime.now().toIso8601String()));
      }
    }
    
    // Safety fallback
    if (_recommendedFoods.isEmpty) {
      _recommendedFoods.add(FoodItem(name: 'Generic Meal', calories: 400, protein: 15, carbs: 40, fat: 10, fiber: 5, mealType: _mealType ?? 'Snack', serving: '1 portion', date: DateTime.now().toIso8601String()));
    }
  }'''

new_generate = '''  void _generateRecommendations() {
    _recommendedFoods.clear();
    _selectedFoodIndices.clear();

    var candidates = List<Map<String, dynamic>>.from(MassiveDatasets.foods);
    
    if (_focus == 'High Protein') {
        candidates = candidates.where((f) => f['protein'] >= 15).toList();
    } else if (_focus == 'Low Calorie') {
        candidates = candidates.where((f) => f['calories'] <= 250).toList();
    } else if (_focus == 'Quick Energy') {
        candidates = candidates.where((f) => f['carbs'] >= 40).toList();
    } else if (_focus == 'Balanced') {
        candidates = candidates.where((f) => f['protein'] >= 5 && f['carbs'] <= 60).toList();
    }
    
    if (candidates.isEmpty) {
        candidates = MassiveDatasets.foods;
    }
    
    candidates.shuffle(Random());

    for (var f in candidates.take(4)) {
      _recommendedFoods.add(FoodItem(
        name: f['name'], 
        calories: f['calories'], 
        protein: f['protein'], 
        carbs: f['carbs'], 
        fat: f['fat'], 
        fiber: f['fiber'], 
        mealType: _mealType ?? 'Snack', 
        serving: f['serving'], 
        date: DateTime.now().toIso8601String()
      ));
    }
  }'''

content = content.replace(old_generate, new_generate)

with open(file_path, 'w') as f:
    f.write(content)

print('Updated ai_food_questionnaire_screen.dart')

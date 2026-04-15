import 'package:fitquest/screens/add_food_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/data/massive_datasets.dart';
import 'dart:math';

class AiFoodQuestionnaireScreen extends StatefulWidget {
  const AiFoodQuestionnaireScreen({super.key});

  @override
  State<AiFoodQuestionnaireScreen> createState() => _AiFoodQuestionnaireScreenState();
}

class _AiFoodQuestionnaireScreenState extends State<AiFoodQuestionnaireScreen> {
  int _currentStep = 0;
  String? _mealType;
  String? _focus;
  
  List<FoodItem> _recommendedFoods = [];
  final Set<int> _selectedFoodIndices = {};

  

  void _nextStep() {
    if (_currentStep == 1) {
      _generateRecommendations();
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _generateRecommendations() {
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
  }

  Future<void> _logSelectedFoods() async {
    final appState = context.read<AppState>();
    for (var index in _selectedFoodIndices) {
      await appState.addFood(_recommendedFoods[index]);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foods logged to your diary!')));
      Navigator.pop(context);
    }
  }

  void _goToCustomFood() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AddFoodScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Food Guide')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _currentStep < 2 ? _nextStep : null,
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          if (_currentStep == 2) {
            return const SizedBox.shrink(); // Hide controls on the last step
          }
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                FilledButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 1 ? 'Find Ideas' : 'Continue'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Which meal is this?'),
            content: DropdownButtonFormField<String>(
              value: _mealType,
              hint: const Text('Select Meal'),
              items: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _mealType = v),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('What is your nutritional focus?'),
            content: DropdownButtonFormField<String>(
              value: _focus,
              hint: const Text('Select Focus'),
              items: ['High Protein', 'Low Calorie', 'Quick Energy', 'Balanced']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _focus = v),
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Your Recommended Plates'),
            content: _buildRecommendationView(),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Select the foods you ate:'),
        const SizedBox(height: 8),
        ...List.generate(_recommendedFoods.length, (index) {
          final f = _recommendedFoods[index];
          return CheckboxListTile(
            title: Text('${f.name} (${f.serving})'),
            subtitle: Text('${f.calories} kcal · P: ${f.protein}g'),
            value: _selectedFoodIndices.contains(index),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedFoodIndices.add(index);
                } else {
                  _selectedFoodIndices.remove(index);
                }
              });
            },
          );
        }),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _selectedFoodIndices.isEmpty ? null : _logSelectedFoods,
          icon: const Icon(Icons.check),
          label: const Text('Log Selected Foods'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _goToCustomFood,
          icon: const Icon(Icons.edit),
          label: const Text('Add Custom Food Instead'),
        ),
      ],
    );
  }
}

import 'package:fitquest/screens/live_workout_screen.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/data/massive_datasets.dart';
import 'dart:math';

class AiExerciseQuestionnaireScreen extends StatefulWidget {
  const AiExerciseQuestionnaireScreen({super.key});

  @override
  State<AiExerciseQuestionnaireScreen> createState() => _AiExerciseQuestionnaireScreenState();
}

class _AiExerciseQuestionnaireScreenState extends State<AiExerciseQuestionnaireScreen> {
  int _currentStep = 0;
  String? _energyLevel;
  String? _goal;
  int? _timeAvailable;
  
  List<Exercise> _recommendedExercises = [];
  final Set<Exercise> _selectedExercises = {};

  void _nextStep() {
    if (_currentStep == 2) {
      _generateRecommendations();
    }
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _generateRecommendations() {
    _recommendedExercises.clear();
    _selectedExercises.clear();

    int baseDuration = (_timeAvailable ?? 30) ~/ 3; // divide total time by 3 exercises
    if (baseDuration < 5) baseDuration = 5;

    // generate 3-4 exercises based on goal and energy
    if (_goal == 'Flexibility/Recovery') {
      _recommendedExercises.add(Exercise(name: 'Yoga Flows', duration: baseDuration, calories: baseDuration * 4, type: 'Flexibility', timestamp: DateTime.now()));
      _recommendedExercises.add(Exercise(name: 'Dynamic Stretching', duration: baseDuration, calories: baseDuration * 3, type: 'Flexibility', timestamp: DateTime.now()));
      _recommendedExercises.add(Exercise(name: 'Pranayama', duration: baseDuration, calories: baseDuration * 2, type: 'Flexibility', timestamp: DateTime.now()));
    } else if (_goal == 'Build Strength') {
      if (_energyLevel == 'Low Energy') {
        _recommendedExercises.add(Exercise(name: 'Plank', duration: baseDuration, calories: baseDuration * 6, type: 'Strength', timestamp: DateTime.now(), sets: 3, reps: 1)); // 1 min holds
        _recommendedExercises.add(Exercise(name: 'Wall Sits', duration: baseDuration, calories: baseDuration * 5, type: 'Strength', timestamp: DateTime.now(), sets: 3, reps: 1));
        _recommendedExercises.add(Exercise(name: 'Light Lunges', duration: baseDuration, calories: baseDuration * 7, type: 'Strength', timestamp: DateTime.now(), sets: 3, reps: 10));
      } else {
        _recommendedExercises.add(Exercise(name: 'Push-ups', duration: baseDuration, calories: baseDuration * 8, type: 'Strength', timestamp: DateTime.now(), sets: 4, reps: 15));
        _recommendedExercises.add(Exercise(name: 'Squat Jumps', duration: baseDuration, calories: baseDuration * 10, type: 'Strength', timestamp: DateTime.now(), sets: 4, reps: 20));
        _recommendedExercises.add(Exercise(name: 'Burpees', duration: baseDuration, calories: baseDuration * 12, type: 'Strength', timestamp: DateTime.now(), sets: 3, reps: 10));
      }
    } else {
      if (_energyLevel == 'Low Energy') {
        _recommendedExercises.add(Exercise(name: 'Brisk Walking', duration: baseDuration, calories: baseDuration * 5, type: 'Cardio', timestamp: DateTime.now()));
        _recommendedExercises.add(Exercise(name: 'Cycling (Low Gear)', duration: baseDuration, calories: baseDuration * 6, type: 'Cardio', timestamp: DateTime.now()));
      } else {
        _recommendedExercises.add(Exercise(name: 'Running', duration: baseDuration, calories: baseDuration * 12, type: 'Cardio', timestamp: DateTime.now()));
        _recommendedExercises.add(Exercise(name: 'Jumping Jacks', duration: baseDuration, calories: baseDuration * 10, type: 'Cardio', timestamp: DateTime.now()));
        _recommendedExercises.add(Exercise(name: 'High Knees', duration: baseDuration, calories: baseDuration * 11, type: 'Cardio', timestamp: DateTime.now()));
      }
    }

    // pre-select all
    _selectedExercises.addAll(_recommendedExercises);
  }

  Future<void> _logAsPrevious() async {
    final appState = context.read<AppState>();
    // Filter to retain exact sequence from ReorderableListView
    final toLog = _recommendedExercises.where((ex) => _selectedExercises.contains(ex)).toList();
    for (var ex in toLog) {
      await appState.addExercise(ex);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged to previous workouts!')));
      Navigator.pop(context);
    }
  }

  void _startLiveWorkout() {
    final selectedExercises = _recommendedExercises.where((ex) => _selectedExercises.contains(ex)).toList();
    if (selectedExercises.isEmpty) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LiveWorkoutScreen(exercises: selectedExercises),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Personalization')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _currentStep < 3 ? _nextStep : null,
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          if (_currentStep == 3) {
            return const SizedBox.shrink(); // Hide default controls for the last step
          }
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                FilledButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 2 ? 'Generate Plan' : 'Continue'),
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
            title: const Text('How are you feeling today?'),
            content: DropdownButtonFormField<String>(
              value: _energyLevel,
              hint: const Text('Select Energy Level'),
              items: ['Low Energy', 'Normal', 'High Energy']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _energyLevel = v),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('What is your primary goal?'),
            content: DropdownButtonFormField<String>(
              value: _goal,
              hint: const Text('Select Goal'),
              items: ['Build Strength', 'Cardio/Fat Burn', 'Flexibility/Recovery']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _goal = v),
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('How much time do you have?'),
            content: DropdownButtonFormField<int>(
              value: _timeAvailable,
              hint: const Text('Select Duration'),
              items: [10, 20, 30, 45, 60]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e minutes')))
                  .toList(),
              onChanged: (v) => setState(() => _timeAvailable = v),
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Your Recommended Plan'),
            content: _buildRecommendationView(),
            isActive: _currentStep == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Select the exercises you want to include:'),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ReorderableListView.builder(
            shrinkWrap: true,
            itemCount: _recommendedExercises.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = _recommendedExercises.removeAt(oldIndex);
                _recommendedExercises.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) {
              final ex = _recommendedExercises[index];
              final hasSets = ex.sets != null;
              final title = hasSets ? '${ex.name} (${ex.sets}x${ex.reps})' : '${ex.name} (${ex.duration}m)';
              return CheckboxListTile(
                key: ValueKey(ex.name + index.toString()),
                title: Text(title),
                subtitle: Text('${ex.calories} kcal'),
                value: _selectedExercises.contains(ex),
                secondary: const Icon(Icons.drag_indicator, color: Colors.grey),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedExercises.add(ex);
                    } else {
                      _selectedExercises.remove(ex);
                    }
                  });
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _selectedExercises.isEmpty ? null : _startLiveWorkout,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Live Workout'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _selectedExercises.isEmpty ? null : _logAsPrevious,
          icon: const Icon(Icons.history),
          label: const Text('Log as Previous'),
        ),
      ],
    );
  }
}

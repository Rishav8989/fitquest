import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitquest/data/massive_datasets.dart';

const _types = ['cardio', 'strength', 'flexibility', 'sports', 'yoga'];



class AddExerciseScreen extends StatefulWidget {
  final String? name;
  final int? initialDuration;
  final int? initialCalories;
  final int? initialSets;
  final int? initialReps;
  
  const AddExerciseScreen({
    super.key, 
    this.name,
    this.initialDuration,
    this.initialCalories,
    this.initialSets,
    this.initialReps,
  });

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  late String exerciseName;
  late int duration;
  late int calories;
  late String type;
  int? sets;
  int? reps;
  double? weight;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    exerciseName = widget.name ?? '';
    duration = widget.initialDuration ?? 10;
    calories = widget.initialCalories ?? 50;
    type = _types.first;
    if (widget.name != null) {
      final m = MassiveDatasets.exercises.firstWhere((e) => e['name'] == widget.name, orElse: () => MassiveDatasets.exercises.first);
      type = m['type'];
    }
    sets = widget.initialSets;
    reps = widget.initialReps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Exercise'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              if (widget.name != null)
                TextFormField(
                  initialValue: widget.name,
                  decoration: const InputDecoration(
                    labelText: 'Exercise',
                  ),
                  readOnly: true,
                )
              else
                Autocomplete<Map<String, dynamic>>(
                  displayStringForOption: (option) => option['name'],
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Map<String, dynamic>>.empty();
                    }
                    return MassiveDatasets.exercises.where((ex) {
                      return ex['name'].toString().toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          );
                    });
                  },
                  onSelected: (Map<String, dynamic> selection) {
                    setState(() {
                      exerciseName = selection['name'];
                      duration = selection['duration'];
                      calories = selection['calories'];
                      type = selection['type'];
                    });
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    textEditingController.addListener(() {
                        exerciseName = textEditingController.text.isNotEmpty ? textEditingController.text : '';
                    });
                    if (exerciseName.isNotEmpty && textEditingController.text.isEmpty) {
                        textEditingController.text = exerciseName;
                    }
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Search Exercises or enter Custom...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    );
                  },
                ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                ),
                items: _types
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => type = v ?? type),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: duration.toString(),
                      decoration: const InputDecoration(labelText: 'Duration (min)'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Invalid duration';
                        return null;
                      },
                      onChanged: (v) {
                        final d = int.tryParse(v);
                        if (d != null) {
                          final p = MassiveDatasets.exercises.firstWhere((e) => e['name'] == exerciseName, orElse: () => {'duration': 1, 'calories': 5});
                          final caloriesPerMinute = p['calories'] / p['duration'];
                          setState(() {
                            duration = d;
                            calories = (d * caloriesPerMinute).round();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: ValueKey<int>(calories), // Forces rebuild when autocalc updates
                      initialValue: calories.toString(),
                      decoration: const InputDecoration(labelText: 'Calories burned'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (int.tryParse(v) == null || int.parse(v) < 0) return 'Invalid calories';
                        return null;
                      },
                      onChanged: (v) {
                        final c = int.tryParse(v);
                        if (c != null) calories = c;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Optional Variables', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: sets?.toString(),
                      decoration: const InputDecoration(labelText: 'Sets'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => sets = int.tryParse(v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: reps?.toString(),
                      decoration: const InputDecoration(labelText: 'Reps'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => reps = int.tryParse(v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Weight (kg)'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (v) => weight = double.tryParse(v),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                if (formKey.currentState?.validate() == true) {
                  final item = Exercise(
                    name: exerciseName,
                    duration: duration,
                    calories: calories,
                    type: type,
                    timestamp: DateTime.now(),
                    sets: sets,
                    reps: reps,
                    weight: weight,
                  );
                  final ok = await showConfirmDialog(
                    context,
                    title: 'Add exercise?',
                    message: 'Add "$exerciseName" ($duration min, $calories kcal) to your log?',
                    confirmText: 'Add',
                  );
                  if (ok && context.mounted) {
                    await context.read<AppState>().addExercise(item);
                    Navigator.of(context).pop();
                  }
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

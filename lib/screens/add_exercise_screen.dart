import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _types = ['cardio', 'strength', 'flexibility', 'sports', 'yoga'];

final _presets = [
  ('Running', 30, 300, 'cardio'),
  ('Walking', 45, 150, 'cardio'),
  ('Surya Namaskar', 20, 100, 'yoga'),
  ('Weight Lifting', 60, 400, 'strength'),
  ('Cricket', 60, 350, 'sports'),
  ('Badminton', 45, 280, 'sports'),
  ('Cycling', 30, 250, 'cardio'),
  ('Pranayama', 15, 50, 'yoga'),
];

class AddExerciseScreen extends StatefulWidget {
  final String? name;
  const AddExerciseScreen({super.key, this.name});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  late String exerciseName;
  late int duration;
  late int calories;
  late String type;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    exerciseName = widget.name ?? _presets.first.$1;
    final preset = _presets.firstWhere((p) => p.$1 == exerciseName, orElse: () => _presets.first);
    duration = preset.$2;
    calories = preset.$3;
    type = preset.$4;
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
                DropdownButtonFormField<String>(
                  value: exerciseName,
                  decoration: const InputDecoration(
                    labelText: 'Exercise',
                  ),
                  items: _presets
                      .map((p) => DropdownMenuItem(
                            value: p.$1,
                            child: Text('${p.$1} (${p.$2} min, ${p.$3} kcal)'),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    final p = _presets.firstWhere((e) => e.$1 == v);
                    setState(() {
                      exerciseName = p.$1;
                      duration = p.$2;
                      calories = p.$3;
                      type = p.$4;
                    });
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
              TextFormField(
                initialValue: duration.toString(),
                decoration: const InputDecoration(
                  labelText: 'Duration (min)',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Invalid duration';
                  return null;
                },
                onChanged: (v) {
                  final d = int.tryParse(v);
                  if (d != null) {
                    final p = _presets.firstWhere((e) => e.$1 == exerciseName, orElse: () => _presets.first);
                    final caloriesPerMinute = p.$3 / p.$2;
                    setState(() {
                      duration = d;
                      calories = (d * caloriesPerMinute).round();
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: calories.toString(),
                decoration: const InputDecoration(
                  labelText: 'Calories burned',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null || int.parse(v) < 0) return 'Invalid calories';
                  return null;
                },
                onChanged: (v) {
                  final c = int.tryParse(v);
                  if (c != null) setState(() => calories = c);
                },
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

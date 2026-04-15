import re

file_path = '/home/server/etc/fitquest/lib/screens/add_exercise_screen.dart'
with open(file_path, 'r') as f:
    content = f.read()

# Add imports
content = content.replace("import 'package:provider/provider.dart';", "import 'package:provider/provider.dart';\nimport 'package:fitquest/data/massive_datasets.dart';")

# Remove _presets
content = re.sub(r'final _presets = \[.*?\];', '', content, flags=re.DOTALL)

# Refactor _AddExerciseScreenState
state_class_start = content.find('class _AddExerciseScreenState extends State<AddExerciseScreen> {')
if state_class_start != -1:
    content = content.replace(
        "    exerciseName = widget.name ?? _presets.first.$1;\n    final preset = _presets.firstWhere((p) => p.$1 == exerciseName, orElse: () => _presets.first);\n    duration = widget.initialDuration ?? preset.$2;\n    calories = widget.initialCalories ?? preset.$3;\n    type = preset.$4;",
        "    exerciseName = widget.name ?? '';\n    duration = widget.initialDuration ?? 10;\n    calories = widget.initialCalories ?? 50;\n    type = _types.first;\n    if (widget.name != null) {\n      final m = MassiveDatasets.exercises.firstWhere((e) => e['name'] == widget.name, orElse: () => MassiveDatasets.exercises.first);\n      type = m['type'];\n    }"
    )

    old_dropdown = '''              else
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
                ),'''

    new_autocomplete = '''              else
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
                ),'''
    content = content.replace(old_dropdown, new_autocomplete)

    old_onchanged = '''                      onChanged: (v) {
                        final d = int.tryParse(v);
                        if (d != null) {
                          final p = _presets.firstWhere((e) => e.$1 == exerciseName, orElse: () => _presets.first);
                          final caloriesPerMinute = p.$3 / p.$2;
                          setState(() {
                            duration = d;
                            calories = (d * caloriesPerMinute).round();
                          });'''

    new_onchanged = '''                      onChanged: (v) {
                        final d = int.tryParse(v);
                        if (d != null) {
                          final p = MassiveDatasets.exercises.firstWhere((e) => e['name'] == exerciseName, orElse: () => {'duration': 1, 'calories': 5});
                          final caloriesPerMinute = p['calories'] / p['duration'];
                          setState(() {
                            duration = d;
                            calories = (d * caloriesPerMinute).round();
                          });'''
    content = content.replace(old_onchanged, new_onchanged)

with open(file_path, 'w') as f:
    f.write(content)

print('Updated add_exercise_screen.dart')

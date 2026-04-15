import os

file_path = '/home/server/etc/fitquest/lib/screens/ai_exercise_questionnaire_screen.dart'
with open(file_path, 'r') as f:
    text = f.read()

# Replace _selectedExerciseIndices with _selectedExercises
text = text.replace('final Set<int> _selectedExerciseIndices = {};', 'final Set<Exercise> _selectedExercises = {};')

text = text.replace('_selectedExerciseIndices.clear();', '_selectedExercises.clear();')

text = text.replace('''    // pre-select all
    for (int i = 0; i < _recommendedExercises.length; i++) {
      _selectedExerciseIndices.add(i);
    }''', '''    // pre-select all
    _selectedExercises.addAll(_recommendedExercises);''')

text = text.replace('''  Future<void> _logAsPrevious() async {
    final appState = context.read<AppState>();
    for (var index in _selectedExerciseIndices) {
      await appState.addExercise(_recommendedExercises[index]);
    }''', '''  Future<void> _logAsPrevious() async {
    final appState = context.read<AppState>();
    // Filter to retain exact sequence from ReorderableListView
    final toLog = _recommendedExercises.where((ex) => _selectedExercises.contains(ex)).toList();
    for (var ex in toLog) {
      await appState.addExercise(ex);
    }''')

text = text.replace('''  void _startLiveWorkout() {
    final selectedExercises = _selectedExerciseIndices.map((i) => _recommendedExercises[i]).toList();
    if (selectedExercises.isEmpty) return;''', '''  void _startLiveWorkout() {
    final selectedExercises = _recommendedExercises.where((ex) => _selectedExercises.contains(ex)).toList();
    if (selectedExercises.isEmpty) return;''')

text = text.replace('''        ...List.generate(_recommendedExercises.length, (index) {
          final ex = _recommendedExercises[index];
          final hasSets = ex.sets != null;
          final title = hasSets ? '${ex.name} (${ex.sets}x${ex.reps})' : '${ex.name} (${ex.duration}m)';
          return CheckboxListTile(
            title: Text(title),
            subtitle: Text('${ex.calories} kcal'),
            value: _selectedExerciseIndices.contains(index),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedExerciseIndices.add(index);
                } else {
                  _selectedExerciseIndices.remove(index);
                }
              });
            },
          );
        }),''', '''        SizedBox(
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
        ),''')

text = text.replace('_selectedExerciseIndices.isEmpty', '_selectedExercises.isEmpty')

with open(file_path, 'w') as f:
    f.write(text)

print('Updated ai_exercise_questionnaire_screen.dart to use ReorderableListView')

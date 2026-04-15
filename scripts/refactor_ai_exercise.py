import os
import re

file_path = '/home/server/etc/fitquest/lib/screens/ai_exercise_questionnaire_screen.dart'
with open(file_path, 'r') as f:
    content = f.read()

content = content.replace("import 'package:provider/provider.dart';", "import 'package:provider/provider.dart';\nimport 'package:fitquest/data/massive_datasets.dart';\nimport 'dart:math';")

# Remove _presets
content = re.sub(r'final _presets = \[.*?\];', '', content, flags=re.DOTALL)

old_generate = '''  void _generateRecommendations() {
    _recommendedExercises.clear();
    _selectedExerciseIndices.clear();

    // Determine target based on focus
    String idealType = 'cardio';
    if (_focus == 'Build Muscle') idealType = 'strength';
    if (_focus == 'Flexibility') idealType = 'yoga';
    
    // Pick 3-4 exercises
    int count = (_duration! >= 45) ? 4 : 3;
    int durationPerExercise = (_duration! / count).floor();

    var candidates = List.from(_presets);
    candidates.shuffle();

    // Try to pick at least 2 of idealType
    var primaryCandidates = candidates.where((p) => p.$4 == idealType).toList();
    var secondaryCandidates = candidates.where((p) => p.$4 != idealType).toList();

    for (int i = 0; i < count; i++) {
      var source = (i < 2 && primaryCandidates.isNotEmpty) ? primaryCandidates : secondaryCandidates;
      if (source.isEmpty) source = candidates;
      var chosen = source.removeAt(0);

      // Adjust calories proportionately
      int calculatedCalories = (chosen.$3 * (durationPerExercise / chosen.$2)).round();

      _recommendedExercises.add(Exercise(
        name: chosen.$1,
        duration: durationPerExercise,
        calories: calculatedCalories,
        type: chosen.$4,
        timestamp: DateTime.now(),
      ));
    }
  }'''

new_generate = '''  void _generateRecommendations() {
    _recommendedExercises.clear();
    _selectedExerciseIndices.clear();

    String idealType = 'Cardio';
    if (_focus == 'Build Muscle') idealType = 'Strength';
    if (_focus == 'Flexibility') idealType = 'Flexibility';
    
    int count = (_duration! >= 45) ? 4 : 3;
    int durationPerExercise = (_duration! / count).floor();

    var candidates = List<Map<String, dynamic>>.from(MassiveDatasets.exercises);
    candidates.shuffle(Random());

    var primaryCandidates = candidates.where((p) => p['type'] == idealType).toList();
    var secondaryCandidates = candidates.where((p) => p['type'] != idealType).toList();

    for (int i = 0; i < count; i++) {
      var source = (i < 2 && primaryCandidates.isNotEmpty) ? primaryCandidates : secondaryCandidates;
      if (source.isEmpty) source = candidates;
      var chosen = source.removeAt(0);

      int splitDuration = durationPerExercise;
      // Recalculate roughly using precomputed / base ratio
      double calsPerMin = chosen['calories'] / chosen['duration'];
      int calculatedCalories = (splitDuration * calsPerMin).round();

      _recommendedExercises.add(Exercise(
        name: '${chosen['baseName']}',
        duration: splitDuration,
        calories: calculatedCalories,
        type: chosen['type'].toString().toLowerCase(),
        timestamp: DateTime.now(),
      ));
    }
  }'''

content = content.replace(old_generate, new_generate)

with open(file_path, 'w') as f:
    f.write(content)

print('Updated ai_exercise_questionnaire_screen.dart')

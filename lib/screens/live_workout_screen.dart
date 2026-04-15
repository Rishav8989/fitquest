import 'dart:async';
import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LiveWorkoutScreen extends StatefulWidget {
  final List<Exercise> exercises;
  const LiveWorkoutScreen({super.key, required this.exercises});

  @override
  State<LiveWorkoutScreen> createState() => _LiveWorkoutScreenState();
}

class _LiveWorkoutScreenState extends State<LiveWorkoutScreen> {
  int _currentIndex = 0;
  int _currentSet = 1;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentExercise();
  }

  void _loadCurrentExercise() {
    final ex = widget.exercises[_currentIndex];
    _remainingSeconds = ex.duration * 60;
    _currentSet = 1;
    _isRunning = false;
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _timer?.cancel();
          _nextExercise();
        }
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _nextSet() {
    final ex = widget.exercises[_currentIndex];
    if (ex.sets != null && _currentSet < ex.sets!) {
      setState(() {
        _currentSet++;
      });
    } else {
      _nextExercise();
    }
  }

  void _nextExercise() {
    _timer?.cancel();
    if (_currentIndex < widget.exercises.length - 1) {
      setState(() {
        _currentIndex++;
        _loadCurrentExercise();
      });
    } else {
      _finishWorkout();
    }
  }

  Future<void> _finishWorkout() async {
    final appState = context.read<AppState>();
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    for (var ex in widget.exercises) {
      final bundledEx = Exercise(
        name: ex.name,
        duration: ex.duration,
        calories: ex.calories,
        type: ex.type,
        timestamp: ex.timestamp,
        sets: ex.sets,
        reps: ex.reps,
        weight: ex.weight,
        sessionId: sessionId,
      );
      await appState.addExercise(bundledEx);
    }
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Workout Complete!'),
          content: const Text('Great job! Your exercises have been logged.'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context); // pop dialog
                Navigator.pop(context); // pop screen back to QuickAdd/Workouts
              },
              child: const Text('Return'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    int m = totalSeconds ~/ 60;
    int s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) return const Scaffold(body: Center(child: Text('No exercises')));

    final ex = widget.exercises[_currentIndex];
    final bool isStrength = ex.sets != null && ex.reps != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise ${_currentIndex + 1} of ${widget.exercises.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ex.name, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${ex.calories} kcal', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
            
            const SizedBox(height: 48),

            if (isStrength) ...[
              Text('Set $_currentSet of ${ex.sets}', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('${ex.reps} Reps', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: _nextSet,
                icon: const Icon(Icons.check),
                label: const Text('Log Set'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ] else ...[
              Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'minus_10',
                    onPressed: () {
                      setState(() {
                         _remainingSeconds -= 10;
                         if (_remainingSeconds < 0) _remainingSeconds = 0;
                      });
                    },
                    child: const Text('-10s'),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton.large(
                    heroTag: 'timer_fab',
                    onPressed: _toggleTimer,
                    child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton(
                    heroTag: 'plus_10',
                    onPressed: () { setState(() { _remainingSeconds += 10; }); },
                    child: const Text('+10s'),
                  ),
                ],
              ),
            ],

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel Workout', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: _nextExercise,
                  child: const Text('Skip Exercise'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

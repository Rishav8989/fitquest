import 'dart:async';

import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  final List<String> _laps = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      setState(() {});
    }
  }

  void _stop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      setState(() {});
    }
  }

  void _reset() {
    _stopwatch.reset();
    _laps.clear();
    setState(() {});
  }

  void _lap() {
    if (_stopwatch.isRunning) {
      setState(() {
        _laps.insert(0, _formattedTime());
      });
    }
  }

  String _formattedTime() {
    final milliseconds = _stopwatch.elapsedMilliseconds;
    final hundreds = (milliseconds / 10).truncate();
    final seconds = (hundreds / 100).truncate();
    final minutes = (seconds / 60).truncate();

    final minutesStr = (minutes % 60).toString().padLeft(2, '0');
    final secondsStr = (seconds % 60).toString().padLeft(2, '0');
    final hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr:$hundredsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30.0),
          Text(
            _formattedTime(),
            style: const TextStyle(fontSize: 80.0),
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: _start,
                child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: _stop,
                child: const Text('Stop'),
              ),
              ElevatedButton(
                onPressed: _lap,
                child: const Text('Lap'),
              ),
              ElevatedButton(
                onPressed: _reset,
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: ListView.builder(
              itemCount: _laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text('Lap ${index + 1}'),
                  trailing: Text(_laps[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

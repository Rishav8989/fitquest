import 'dart:async';

import 'package:fitquest/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SleepTrackingScreen extends StatefulWidget {
  const SleepTrackingScreen({super.key});

  @override
  State<SleepTrackingScreen> createState() => _SleepTrackingScreenState();
}

class _SleepTrackingScreenState extends State<SleepTrackingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final sleepSessions = appState.sleepSessions;
        final currentSleep = sleepSessions.firstWhere(
          (s) => s.end == null,
          orElse: () => SleepSession(start: DateTime.now()),
        );
        final isSleeping = currentSleep.id != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Sleep Tracking'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (isSleeping)
                  _buildSleepTimer(context, currentSleep)
                else
                  _buildStartSleepButton(context, appState),
                const SizedBox(height: 24),
                Expanded(
                  child: _buildSleepLog(sleepSessions),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartSleepButton(BuildContext context, AppState appState) {
    return ElevatedButton(
      onPressed: () {
        final sleep = SleepSession(start: DateTime.now());
        appState.addSleep(sleep);
      },
      child: const Text('Start Sleep'),
    );
  }

  Widget _buildSleepTimer(BuildContext context, SleepSession currentSleep) {
    final duration = DateTime.now().difference(currentSleep.start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final formattedDuration =
        '$hours h ${minutes.toString().padLeft(2, '0')} m ${seconds.toString().padLeft(2, '0')} s';

    return Column(
      children: [
        Text(
          formattedDuration,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final updatedSleep = currentSleep.copyWith(end: DateTime.now());
            context.read<AppState>().updateSleep(updatedSleep);
          },
          child: const Text('Wake Up'),
        ),
      ],
    );
  }

  Widget _buildSleepLog(List<SleepSession> sleepSessions) {
    final completedSessions =
        sleepSessions.where((s) => s.end != null).toList();

    return ListView.builder(
      itemCount: completedSessions.length,
      itemBuilder: (context, index) {
        final session = completedSessions[index];
        final duration = session.end!.difference(session.start);
        final hours = duration.inHours;
        final minutes = duration.inMinutes.remainder(60);
        final formattedDuration = '$hours h ${minutes} m';

        return ListTile(
          title: Text(
              '${DateFormat.yMd().format(session.start)} - ${DateFormat.jm().format(session.start)}'),
          subtitle: Text('Duration: $formattedDuration'),
        );
      },
    );
  }
}

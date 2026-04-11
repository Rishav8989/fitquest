import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Uses device motion / step counter (Android) for accurate step tracking.
/// No external devices — phone sensor only. Resets at midnight.
class StepCountService {
  StepCountService({required this.onStepsUpdated});

  final void Function(int todaySteps) onStepsUpdated;

  static const _keyTodaySteps = 'fitquest_today_steps';
  static const _keyStepDate = 'fitquest_step_date';
  static const _keyLastSensorValue = 'fitquest_last_sensor_value';

  StreamSubscription<StepCount>? _subscription;
  int _lastSensorValue = 0;
  int _todaySteps = 0;
  String _stepDate = '';

  bool _initialized = false;
  String? _error;

  String? get error => _error;

  /// Call from main after AppState is ready. Safe to call on non-Android (no-op).
  Future<void> start() async {
    if (_initialized) return;
    await _loadPersisted();
    _applyMidnightReset();
    onStepsUpdated(_todaySteps);
    if (!defaultTargetPlatform.toString().contains('Android')) {
      debugPrint('FitQuest: Step tracking uses device sensor on Android.');
      return;
    }
    try {
      final stream = Pedometer.stepCountStream;
      _subscription = stream.listen(
        _onStepCount,
        onError: _onError,
        cancelOnError: false,
      );
      _initialized = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('FitQuest: Pedometer error: $e');
    }
  }

  void _onStepCount(StepCount event) {
    final newValue = event.steps;
    if (_stepDate != _todayString()) {
      _todaySteps = 0;
      _stepDate = _todayString();
    }
    int delta = newValue - _lastSensorValue;
    if (delta < 0) {
      _lastSensorValue = 0;
      delta = newValue;
    }
    _todaySteps += delta;
    _lastSensorValue = newValue;
    _persist();
    onStepsUpdated(_todaySteps);
  }

  void _onError(dynamic e) {
    _error = e.toString();
    onStepsUpdated(_todaySteps);
  }

  String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  void _applyMidnightReset() {
    final today = _todayString();
    if (_stepDate != today) {
      _todaySteps = 0;
      _stepDate = today;
      _persist();
    }
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    _todaySteps = prefs.getInt(_keyTodaySteps) ?? 0;
    _stepDate = prefs.getString(_keyStepDate) ?? _todayString();
    _lastSensorValue = prefs.getInt(_keyLastSensorValue) ?? 0;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTodaySteps, _todaySteps);
    await prefs.setString(_keyStepDate, _stepDate);
    await prefs.setInt(_keyLastSensorValue, _lastSensorValue);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

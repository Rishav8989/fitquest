import 'dart:async';
import 'package:fitquest/services/database_helper.dart';
import 'package:flutter/foundation.dart';

class FoodItem {
  final int? id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final String serving;
  final String mealType;
  final String date;

  FoodItem({
    this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.serving,
    required this.mealType,
    required this.date,
  });

  FoodItem copyWith({
    int? id,
    String? name,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    int? fiber,
    String? serving,
    String? mealType,
    String? date,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      serving: serving ?? this.serving,
      mealType: mealType ?? this.mealType,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'fiber': fiber,
        'serving': serving,
        'mealType': mealType,
        'date': date,
      };

  static FoodItem fromJson(Map<String, dynamic> json) => FoodItem(
        id: json['id'] as int?,
        name: json['name'] as String,
        calories: json['calories'] as int,
        protein: json['protein'] as int,
        carbs: json['carbs'] as int,
        fat: json['fat'] as int,
        fiber: json['fiber'] as int,
        serving: json['serving'] as String,
        mealType: json['mealType'] as String,
        date: json['date'] as String,
      );
}

class Exercise {
  final int? id;
  final String name;
  final int duration;
  final int calories;
  final String type;
  final DateTime timestamp;
  final int? sets;
  final int? reps;
  final double? weight;
  final String? sessionId;

  Exercise({
    this.id,
    required this.name,
    required this.duration,
    required this.calories,
    required this.type,
    required this.timestamp,
    this.sets,
    this.reps,
    this.weight,
    this.sessionId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'duration': duration,
        'calories': calories,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
        'sets': sets,
        'reps': reps,
        'weight': weight,
        'sessionId': sessionId,
      };

  static Exercise fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as int?,
        name: json['name'] as String,
        duration: json['duration'] as int,
        calories: json['calories'] as int,
        type: json['type'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        sets: json['sets'] as int?,
        reps: json['reps'] as int?,
        weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
        sessionId: json['sessionId'] as String?,
      );
}

class BodyMeasurement {
  final int? id;
  final DateTime date;
  final double weight;
  final double chest;
  final double waist;
  final double arms;
  final double thighs;
  final double? bodyFat;

  BodyMeasurement({
    this.id,
    required this.date,
    required this.weight,
    required this.chest,
    required this.waist,
    required this.arms,
    required this.thighs,
    this.bodyFat,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'weight': weight,
        'chest': chest,
        'waist': waist,
        'arms': arms,
        'thighs': thighs,
        'bodyFat': bodyFat,
      };

  static BodyMeasurement fromJson(Map<String, dynamic> json) => BodyMeasurement(
        id: json['id'] as int?,
        date: DateTime.parse(json['date'] as String),
        weight: (json['weight'] as num).toDouble(),
        chest: (json['chest'] as num).toDouble(),
        waist: (json['waist'] as num).toDouble(),
        arms: (json['arms'] as num).toDouble(),
        thighs: (json['thighs'] as num).toDouble(),
        bodyFat: json['bodyFat'] != null ? (json['bodyFat'] as num).toDouble() : null,
      );
}

class UserProfile {
  int? id;
  String name;
  String email;
  int age;
  String gender;
  double heightCm;
  double weightKg;
  String activityLevel;
  String dietPlan;
  String goal;

  UserProfile({
    this.id,
    this.name = 'John Doe',
    this.email = 'john.doe@example.com',
    this.age = 30,
    this.gender = 'Male',
    this.heightCm = 180,
    this.weightKg = 80,
    this.activityLevel = 'Active',
    this.dietPlan = 'Balanced',
    this.goal = 'Lose Weight',
  });

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'age': age,
        'gender': gender,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'activityLevel': activityLevel,
        'dietPlan': dietPlan,
        'goal': goal,
      };

  static UserProfile fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as int?,
        name: json['name'] as String? ?? 'John Doe',
        email: json['email'] as String? ?? '',
        age: json['age'] as int? ?? 30,
        gender: json['gender'] as String? ?? 'Male',
        heightCm: (json['heightCm'] as num?)?.toDouble() ?? 180,
        weightKg: (json['weightKg'] as num?)?.toDouble() ?? 80,
        activityLevel: json['activityLevel'] as String? ?? 'Active',
        dietPlan: json['dietPlan'] as String? ?? 'Balanced',
        goal: json['goal'] as String? ?? 'Lose Weight',
      );
}

class SleepSession {
  final int? id;
  final DateTime start;
  final DateTime? end;

  SleepSession({this.id, required this.start, this.end});

  SleepSession copyWith({int? id, DateTime? start, DateTime? end}) {
    return SleepSession(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'start': start.toIso8601String(),
        'end': end?.toIso8601String(),
      };

  static SleepSession fromJson(Map<String, dynamic> json) => SleepSession(
        id: json['id'] as int?,
        start: DateTime.parse(json['start'] as String),
        end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      );
}

class AppState extends ChangeNotifier {
  late final DatabaseHelper dbHelper;

  int _steps = 0;
  final List<FoodItem> _foods = [];
  final List<Exercise> _exercises = [];
  final List<SleepSession> _sleepSessions = [];
  final List<BodyMeasurement> _measurements = [];
  UserProfile _profile = UserProfile();
  int _waterIntake = 0;

  int calorieGoal = 2000;
  int proteinGoal = 150;
  int carbsGoal = 200;
  int fatGoal = 65;
  int fiberGoal = 30;
  int waterGoal = 3000;

  int get steps => _steps;
  List<FoodItem> get foods => List.unmodifiable(_foods);
  List<Exercise> get exercises => List.unmodifiable(_exercises);
  List<SleepSession> get sleepSessions => List.unmodifiable(_sleepSessions);
  List<BodyMeasurement> get measurements => List.unmodifiable(_measurements);
  UserProfile get profile => _profile;
  int get waterIntake => _waterIntake;

  int get todayCalories =>
      _foods.fold(0, (sum, f) => sum + f.calories);
  int get todayProtein =>
      _foods.fold(0, (sum, f) => sum + f.protein);
  int get todayCarbs =>
      _foods.fold(0, (sum, f) => sum + f.carbs);
  int get todayFat =>
      _foods.fold(0, (sum, f) => sum + f.fat);
  int get todayFiber =>
      _foods.fold(0, (sum, f) => sum + f.fiber);
  int get todayExerciseCalories =>
      _exercises.fold(0, (sum, e) => sum + e.calories);
  int get todayActiveMinutes =>
      _exercises.fold(0, (sum, e) => sum + e.duration);

  AppState({DatabaseHelper? dbHelper}) {
    this.dbHelper = dbHelper ?? DatabaseHelper.instance;
    _load();
  }

  Future<void> _load() async {
    _foods.clear();
    _exercises.clear();
    _sleepSessions.clear();
    _measurements.clear();
    
    _foods.addAll(await dbHelper.getFoodLogs());
    _exercises.addAll(await dbHelper.getExerciseLogs());
    _sleepSessions.addAll(await dbHelper.getSleepSessions());
    _measurements.addAll(await dbHelper.getMeasurements());
    _steps = await dbHelper.getTodaySteps();
    
    final userProfile = await dbHelper.getProfile();
    if (userProfile != null) {
      _profile = userProfile;
    } else {
      await dbHelper.saveProfile(_profile);
    }

    final goals = await dbHelper.getGoals();
    calorieGoal = goals['calorieGoal'] ?? 2000;
    proteinGoal = goals['proteinGoal'] ?? 150;
    carbsGoal = goals['carbsGoal'] ?? 200;
    fatGoal = goals['fatGoal'] ?? 65;
    fiberGoal = goals['fiberGoal'] ?? 30;
    waterGoal = goals['waterGoal'] ?? 3000;
    
    _waterIntake = await dbHelper.getWaterIntake();

    if (_foods.isEmpty) {
      _seedFoods();
    }
    if (_exercises.isEmpty) {
      _seedExercises();
    }
    
    notifyListeners();
  }
  
  Future<void> setTodaySteps(int steps) async {
    await dbHelper.setTodaySteps(steps);
    _steps = await dbHelper.getTodaySteps();
    notifyListeners();
  }

  Future<void> addMeasurement(BodyMeasurement measurement) async {
    await dbHelper.addMeasurement(measurement);
    await _load();
  }

  void _seedFoods() async {
    final seedItems = [
      FoodItem(
          name: 'Chicken Salad',
          calories: 350,
          protein: 30,
          carbs: 10,
          fat: 20,
          fiber: 5,
          serving: '1 bowl',
          mealType: 'Lunch',
          date: _todayString()),
      FoodItem(
          name: 'Apple',
          calories: 95,
          protein: 0,
          carbs: 25,
          fat: 0,
          fiber: 4,
          serving: '1 medium',
          mealType: 'Snack',
          date: _todayString()),
    ];
    for (var item in seedItems) {
      await addFood(item);
    }
  }

  void _seedExercises() async {
    final now = DateTime.now();
    final seedItems = [
      Exercise(
          name: 'Running',
          duration: 30,
          calories: 300,
          type: 'cardio',
          timestamp: now),
      Exercise(
          name: 'Weight Lifting',
          duration: 60,
          calories: 400,
          type: 'strength',
          timestamp: now),
    ];
    for (var item in seedItems) {
      await addExercise(item);
    }
  }

  Future<void> addFood(FoodItem item) async {
    await dbHelper.addFood(item);
    await _load();
  }

  Future<void> removeFood(FoodItem item) async {
    if(item.id != null) {
      await dbHelper.removeFood(item.id!);
      await _load();
    }
  }

  Future<void> updateFood(FoodItem item) async {
    await dbHelper.updateFood(item);
    await _load();
  }

  Future<void> addExercise(Exercise item) async {
    await dbHelper.addExercise(item);
    await _load();
  }

  Future<void> removeExercise(Exercise item) async {
    if(item.id != null) {
      await dbHelper.removeExercise(item.id!);
      await _load();
    }
  }

  Future<void> addSleep(SleepSession sleep) async {
    await dbHelper.addSleep(sleep);
    await _load();
  }

  Future<void> updateSleep(SleepSession sleep) async {
    await dbHelper.updateSleep(sleep);
    await _load();
  }

  Future<void> removeSleep(SleepSession sleep) async {
    if (sleep.id != null) {
      await dbHelper.removeSleep(sleep.id!);
      await _load();
    }
  }

  Future<void> updateProfile(UserProfile p) async {
    await dbHelper.saveProfile(p);
    await _load();
  }
  
  Future<void> addWater(int amount) async {
    await dbHelper.addWater(amount);
    await _load();
  }
  
  Future<void> removeWater(int amount) async {
    await dbHelper.removeWater(amount);
    await _load();
  }

  String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}

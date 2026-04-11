import 'package:fitquest/services/app_state.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitquest.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 3, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    await _upgradeDB(db, 1, version);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE food_logs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          calories INTEGER NOT NULL,
          protein INTEGER NOT NULL,
          carbs INTEGER NOT NULL,
          fat INTEGER NOT NULL,
          fiber INTEGER NOT NULL,
          serving TEXT NOT NULL,
          mealType TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE water_logs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          amount INTEGER NOT NULL,
          date TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE exercise_logs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          duration INTEGER NOT NULL,
          calories INTEGER NOT NULL,
          type TEXT NOT NULL,
          timestamp TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE user_profile(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          age INTEGER NOT NULL,
          gender TEXT NOT NULL,
          heightCm REAL NOT NULL,
          weightKg REAL NOT NULL,
          activityLevel TEXT NOT NULL,
          dietPlan TEXT NOT NULL,
          goal TEXT NOT NULL
        )
      ''');
       await db.execute('''
        CREATE TABLE goals(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          calorieGoal INTEGER NOT NULL,
          proteinGoal INTEGER NOT NULL,
          carbsGoal INTEGER NOT NULL,
          fatGoal INTEGER NOT NULL,
          fiberGoal INTEGER NOT NULL,
          waterGoal INTEGER NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE steps(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          count INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE sleep_sessions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          start TEXT NOT NULL,
          end TEXT
        )
      ''');
    }
  }

  // Food Log CRUD
  Future<int> addFood(FoodItem food) async {
    final db = await instance.database;
    return await db.insert('food_logs', food.toJson()..remove('id'));
  }

  Future<List<FoodItem>> getFoodLogs() async {
    final db = await instance.database;
    final maps = await db.query('food_logs');
    return List.generate(maps.length, (i) {
      return FoodItem.fromJson(maps[i]);
    });
  }

  Future<int> removeFood(int id) async {
    final db = await instance.database;
    return await db.delete('food_logs', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateFood(FoodItem food) async {
    final db = await instance.database;
    return await db.update('food_logs', food.toJson(),
        where: 'id = ?', whereArgs: [food.id]);
  }

  // Sleep CRUD
  Future<int> addSleep(SleepSession sleep) async {
    final db = await instance.database;
    return await db.insert('sleep_sessions', sleep.toJson()..remove('id'));
  }

  Future<List<SleepSession>> getSleepSessions() async {
    final db = await instance.database;
    final maps = await db.query('sleep_sessions');
    return List.generate(maps.length, (i) {
      return SleepSession.fromJson(maps[i]);
    });
  }

  Future<int> removeSleep(int id) async {
    final db = await instance.database;
    return await db.delete('sleep_sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateSleep(SleepSession sleep) async {
    final db = await instance.database;
    return await db.update('sleep_sessions', sleep.toJson(),
        where: 'id = ?', whereArgs: [sleep.id]);
  }

  // Water Log CRUD
  Future<int> addWater(int amount) async {
    final db = await instance.database;
    return await db.insert('water_logs', {'amount': amount, 'date': DateTime.now().toIso8601String()});
  }

  Future<int> getWaterIntake() async {
    final db = await instance.database;
    final result = await db.query('water_logs',
        columns: ['SUM(amount) as total'],
        where: 'date(date) = date(?)',
        whereArgs: [DateTime.now().toIso8601String()]);
    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }
  
    Future<int> removeWater(int amount) async {
    final db = await instance.database;
    // Find the last water entry to remove from
    final lastEntry = await db.query('water_logs', orderBy: 'id DESC', limit: 1);
    if(lastEntry.isNotEmpty){
        final lastAmount = lastEntry.first['amount'] as int;
        final newAmount = lastAmount - amount;
        if (newAmount > 0) {
            return await db.update('water_logs', {'amount': newAmount}, where: 'id = ?', whereArgs: [lastEntry.first['id']]);
        } else {
            return await db.delete('water_logs', where: 'id = ?', whereArgs: [lastEntry.first['id']]);
        }
    }
    return 0;
  }

  // Exercise Log CRUD
  Future<int> addExercise(Exercise exercise) async {
    final db = await instance.database;
    return await db.insert('exercise_logs', exercise.toJson()..remove('id'));
  }

  Future<List<Exercise>> getExerciseLogs() async {
    final db = await instance.database;
    final maps = await db.query('exercise_logs');
    return List.generate(maps.length, (i) {
      return Exercise.fromJson(maps[i]);
    });
  }

  Future<int> removeExercise(int id) async {
    final db = await instance.database;
    return await db.delete('exercise_logs', where: 'id = ?', whereArgs: [id]);
  }

  // User Profile CRUD
  Future<int> saveProfile(UserProfile profile) async {
    final db = await instance.database;
    final existing = await getProfile();
    if (existing != null) {
      return await db.update('user_profile', profile.toJson()..remove('id'), where: 'id = ?', whereArgs: [existing.id]);
    } else {
      return await db.insert('user_profile', profile.toJson()..remove('id'));
    }
  }

  Future<UserProfile?> getProfile() async {
    final db = await instance.database;
    final maps = await db.query('user_profile');
    if (maps.isNotEmpty) {
      return UserProfile.fromJson(maps.first);
    }
    return null;
  }

  // Goals CRUD
  Future<int> saveGoals(Map<String, int> goals) async {
    final db = await instance.database;
    final existing = await getGoals();
    if (existing.isNotEmpty) {
      return await db.update('goals', goals, where: 'id = ?', whereArgs: [existing['id']]);
    } else {
      return await db.insert('goals', goals);
    }
  }

  Future<Map<String, dynamic>> getGoals() async {
    final db = await instance.database;
    final maps = await db.query('goals');
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return {
      'calorieGoal': 2000,
      'proteinGoal': 150,
      'carbsGoal': 200,
      'fatGoal': 65,
      'fiberGoal': 30,
      'waterGoal': 3000,
    };
  }

  // Steps CRUD
  Future<int> setTodaySteps(int steps) async {
    final db = await instance.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final existing = await db.query('steps', where: 'date = ?', whereArgs: [today]);
    if (existing.isNotEmpty) {
      return await db.update('steps', {'count': steps}, where: 'date = ?', whereArgs: [today]);
    } else {
      return await db.insert('steps', {'date': today, 'count': steps});
    }
  }

  Future<int> getTodaySteps() async {
    final db = await instance.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final result = await db.query('steps', where: 'date = ?', whereArgs: [today]);
    if (result.isNotEmpty) {
      return result.first['count'] as int;
    }
    return 0;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

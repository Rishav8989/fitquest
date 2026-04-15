import re

# Update AppState
app_state_path = '/home/server/etc/fitquest/lib/services/app_state.dart'
with open(app_state_path, 'r') as f:
    text = f.read()

# Add list
text = text.replace('final List<SleepSession> _sleepSessions = [];', 'final List<SleepSession> _sleepSessions = [];\n  final List<BodyMeasurement> _measurements = [];')
text = text.replace('List<SleepSession> get sleepSessions => List.unmodifiable(_sleepSessions);', 'List<SleepSession> get sleepSessions => List.unmodifiable(_sleepSessions);\n  List<BodyMeasurement> get measurements => List.unmodifiable(_measurements);')

# Load measurements
text = text.replace('await loadSleepSessions();', 'await loadSleepSessions();\n    await loadMeasurements();')

load_func = '''  Future<void> loadMeasurements() async {
    final List<BodyMeasurement> dbMeasurements = await dbHelper.getMeasurements();
    _measurements.clear();
    _measurements.addAll(dbMeasurements);
    notifyListeners();
  }

  Future<void> addMeasurement(BodyMeasurement measurement) async {
    final id = await dbHelper.addMeasurement(measurement);
    _measurements.add(BodyMeasurement(
      id: id,
      date: measurement.date,
      weight: measurement.weight,
      chest: measurement.chest,
      waist: measurement.waist,
      arms: measurement.arms,
      thighs: measurement.thighs,
      bodyFat: measurement.bodyFat,
    ));
    notifyListeners();
  }
'''
text = text.replace('  Future<void> loadFoods() async {', load_func + '\n  Future<void> loadFoods() async {')

with open(app_state_path, 'w') as f:
    f.write(text)

# Update DatabaseHelper
db_helper_path = '/home/server/etc/fitquest/lib/services/database_helper.dart'
with open(db_helper_path, 'r') as f:
    db_text = f.read()

crud_func = '''  // Body Measurements CRUD
  Future<int> addMeasurement(BodyMeasurement measurement) async {
    final db = await instance.database;
    return await db.insert('body_measurements', measurement.toJson()..remove('id'));
  }

  Future<List<BodyMeasurement>> getMeasurements() async {
    final db = await instance.database;
    final maps = await db.query('body_measurements', orderBy: 'date ASC');
    return List.generate(maps.length, (i) {
      return BodyMeasurement.fromJson(maps[i]);
    });
  }

'''

db_text = db_text.replace('  // Food Log CRUD', crud_func + '  // Food Log CRUD')

with open(db_helper_path, 'w') as f:
    f.write(db_text)

print('Updated app_state.dart and database_helper.dart for BodyMeasurements')

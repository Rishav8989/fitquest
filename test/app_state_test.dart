import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/services/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_state_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  test('AppState adds food to the database', () async {
    final mockDbHelper = MockDatabaseHelper();

    // The AppState constructor calls _load(), which in turn calls dbHelper methods.
    // We need to provide mock responses for these calls.
    when(mockDbHelper.getFoodLogs()).thenAnswer((_) async => []);
    when(mockDbHelper.getExerciseLogs()).thenAnswer((_) async => []);
    when(mockDbHelper.getSleepSessions()).thenAnswer((_) async => []);
    when(mockDbHelper.getTodaySteps()).thenAnswer((_) async => 0);
    when(mockDbHelper.getProfile()).thenAnswer((_) async => null);
    when(mockDbHelper.saveProfile(any)).thenAnswer((_) async => 1);
    when(mockDbHelper.getGoals()).thenAnswer((_) async => {});
    when(mockDbHelper.getWaterIntake()).thenAnswer((_) async => 0);
    when(mockDbHelper.addFood(any)).thenAnswer((_) async => 1);
    when(mockDbHelper.addExercise(any)).thenAnswer((_) async => 1);

    final appState = AppState(dbHelper: mockDbHelper);

    final foodItem = FoodItem(
      name: 'Test Food',
      calories: 100,
      protein: 10,
      carbs: 10,
      fat: 10,
      fiber: 10,
      serving: '1',
      mealType: 'Snack',
      date: '2024-01-01',
    );

    await appState.addFood(foodItem);

    verify(mockDbHelper.addFood(foodItem)).called(1);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fitquest/main.dart';
import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/services/database_helper.dart';
import 'package:fitquest/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'app_state_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
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

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AppState(dbHelper: mockDbHelper)),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

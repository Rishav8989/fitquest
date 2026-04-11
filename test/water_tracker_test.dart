import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/widgets/water_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'water_tracker_test.mocks.dart';

@GenerateMocks([AppState])
void main() {
  testWidgets('WaterTracker adds water when add button is tapped', (WidgetTester tester) async {
    final mockAppState = MockAppState();

    when(mockAppState.waterIntake).thenReturn(0);
    when(mockAppState.waterGoal).thenReturn(3000);
    when(mockAppState.addWater(any)).thenAnswer((_) async {});

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: mockAppState,
        child: const MaterialApp(
          home: Scaffold(
            body: WaterTracker(),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '250');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pump();

    verify(mockAppState.addWater(250)).called(1);
  });
}

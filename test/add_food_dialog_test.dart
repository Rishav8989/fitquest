import 'package:fitquest/services/app_state.dart';
import 'package:fitquest/screens/add_food_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'add_food_dialog_test.mocks.dart';

@GenerateMocks([AppState])
void main() {
  testWidgets('AddFoodScreen adds food when add button is tapped', (WidgetTester tester) async {
    final mockAppState = MockAppState();
    when(mockAppState.addFood(any)).thenAnswer((_) async {});

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: mockAppState,
        child: const MaterialApp(
          home: AddFoodScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap the "Add" button
    final addButton = find.widgetWithText(FilledButton, 'Add');
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Find the "Add food?" confirmation dialog
    final confirmDialog = find.byWidgetPredicate((widget) => widget is AlertDialog && widget.title is Text && (widget.title as Text).data == 'Add food?');
    expect(confirmDialog, findsOneWidget);

    // Tap the "Add" button in the confirmation dialog
    final addButtonInConfirmDialog = find.descendant(of: confirmDialog, matching: find.widgetWithText(FilledButton, 'Add'));
    await tester.tap(addButtonInConfirmDialog);
    await tester.pumpAndSettle();

    verify(mockAppState.addFood(any)).called(1);
  });
}

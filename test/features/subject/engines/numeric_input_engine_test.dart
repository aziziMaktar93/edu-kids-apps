import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/numeric_input_engine.dart';

void main() {
  const payload = NumericInputPayload(prompt: 'Berapa banyak epal?', itemIcon: Icons.circle, itemCount: 3);

  testWidgets('entering the correct count and checking calls onAnswered(true)', (tester) async {
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.5;

    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: NumericInputEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.widgetWithText(ElevatedButton, '3'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(result, isTrue);
  });

  testWidgets('entering the wrong count and checking calls onAnswered(false)', (tester) async {
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.5;

    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: NumericInputEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.widgetWithText(ElevatedButton, '5'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(result, isFalse);
  });

  testWidgets('backspace removes the last entered digit', (tester) async {
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.5;

    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: NumericInputEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.widgetWithText(ElevatedButton, '5'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, '3'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(result, isTrue);
  });
}

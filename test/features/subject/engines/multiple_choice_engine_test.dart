import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/multiple_choice_engine.dart';

void main() {
  const payload = MultipleChoicePayload(
    prompt: 'Apakah nama planet ini?',
    icon: Icons.public,
    options: ['Bumi', 'Marikh', 'Zuhal', 'Musytari'],
    correctIndex: 2,
  );

  testWidgets('tapping the correct option calls onAnswered(true)', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MultipleChoiceEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.text('Zuhal'));
    await tester.pump();

    expect(result, isTrue);
  });

  testWidgets('tapping a wrong option calls onAnswered(false)', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MultipleChoiceEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.text('Bumi'));
    await tester.pump();

    expect(result, isFalse);
  });

  testWidgets('a second tap after answering does not call onAnswered again', (tester) async {
    var callCount = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MultipleChoiceEngine(payload: payload, onAnswered: (_) => callCount++)),
    ));

    await tester.tap(find.text('Zuhal'));
    await tester.pump();
    await tester.tap(find.text('Bumi'));
    await tester.pump();

    expect(callCount, 1);
  });
}

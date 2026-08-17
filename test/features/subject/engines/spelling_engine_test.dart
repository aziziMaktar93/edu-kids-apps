import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/spelling_engine.dart';

void main() {
  testWidgets('spelling the target word correctly calls onAnswered(true)', (tester) async {
    bool? result;
    const payload = SpellingPayload(prompt: 'Eja!', icon: Icons.pets, targetWord: 'CAT', letterBank: ['T', 'C', 'A']);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SpellingEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    // bank_1 = 'C', bank_2 = 'A', bank_0 = 'T' -> spells CAT
    await tester.tap(find.byKey(const ValueKey('bank_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_2')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_0')));
    await tester.pump();

    expect(result, isTrue);
  });

  testWidgets('spelling the wrong word calls onAnswered(false)', (tester) async {
    bool? result;
    const payload = SpellingPayload(prompt: 'Eja!', icon: Icons.pets, targetWord: 'CAT', letterBank: ['T', 'C', 'A']);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SpellingEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    // bank_0 = 'T', bank_1 = 'C', bank_2 = 'A' -> spells TCA
    await tester.tap(find.byKey(const ValueKey('bank_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_2')));
    await tester.pump();

    expect(result, isFalse);
  });

  testWidgets('handles duplicate letters correctly (BUKU)', (tester) async {
    bool? result;
    const payload = SpellingPayload(
      prompt: 'Eja!',
      icon: Icons.menu_book,
      targetWord: 'BUKU',
      letterBank: ['U', 'K', 'B', 'U', 'A', 'T'],
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SpellingEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    // bank_2='B', bank_0='U', bank_1='K', bank_3='U' -> spells BUKU
    await tester.tap(find.byKey(const ValueKey('bank_2')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_3')));
    await tester.pump();

    expect(result, isTrue);
  });

  testWidgets('reset clears the blanks and re-enables the bank', (tester) async {
    const payload = SpellingPayload(prompt: 'Eja!', icon: Icons.pets, targetWord: 'CAT', letterBank: ['T', 'C', 'A']);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SpellingEngine(payload: payload, onAnswered: (_) {})),
    ));

    await tester.tap(find.byKey(const ValueKey('bank_1')));
    await tester.pump();
    await tester.tap(find.text('Semula'));
    await tester.pump();

    final bankButton = tester.widget<ElevatedButton>(find.byKey(const ValueKey('bank_1')));
    expect(bankButton.onPressed, isNotNull);
  });
}

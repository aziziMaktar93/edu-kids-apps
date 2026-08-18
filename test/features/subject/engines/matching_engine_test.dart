import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/matching_engine.dart';

void main() {
  const payload = MatchingPayload(
    prompt: 'Padankan!',
    pairs: [
      MatchPair(left: 'A', rightLabel: 'Apple', rightIcon: Icons.circle),
      MatchPair(left: 'B', rightLabel: 'Ball', rightIcon: Icons.sports_soccer),
    ],
  );

  testWidgets('matching all pairs correctly calls onAnswered(true) exactly once', (tester) async {
    var callCount = 0;
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MatchingEngine(
          payload: payload,
          onAnswered: (v) {
            callCount++;
            result = v;
          },
        ),
      ),
    ));

    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('left_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_1')));
    await tester.pump();

    expect(callCount, 1);
    expect(result, isTrue);
  });

  testWidgets('a wrong attempt does not call onAnswered and can be retried', (tester) async {
    var callCount = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MatchingEngine(payload: payload, onAnswered: (_) => callCount++)),
    ));

    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_1'))); // wrong
    await tester.pump();

    expect(callCount, 0);

    // Retry correctly.
    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('left_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_1')));
    await tester.pump();

    expect(callCount, 1);
  });

  testWidgets('a wrong attempt shows red feedback on both cards, which clears on retry', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MatchingEngine(payload: payload, onAnswered: (_) {})),
    ));

    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_1'))); // wrong
    await tester.pump();

    Card cardAt(String key) => tester.widget<Card>(find.byKey(ValueKey(key)));
    expect(cardAt('left_0').color, Colors.red.shade100);
    expect(cardAt('right_1').color, Colors.red.shade100);

    // Retrying a left card clears the red feedback immediately, no waiting required.
    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    expect(cardAt('left_0').color, Colors.blue.shade100);
    expect(cardAt('right_1').color, isNull);
  });

  testWidgets('wrong feedback auto-clears on its own after a short delay', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MatchingEngine(payload: payload, onAnswered: (_) {})),
    ));

    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_1'))); // wrong
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final card = tester.widget<Card>(find.byKey(const ValueKey('left_0')));
    expect(card.color, isNull);
  });
}

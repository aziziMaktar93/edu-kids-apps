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
}

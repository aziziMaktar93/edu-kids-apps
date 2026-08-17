import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/activity_engine_view.dart';
import 'package:edukids/features/subject/engines/multiple_choice_engine.dart';
import 'package:edukids/features/subject/engines/numeric_input_engine.dart';
import 'package:edukids/features/subject/engines/spelling_engine.dart';
import 'package:edukids/features/subject/engines/matching_engine.dart';

void main() {
  Future<void> pumpFor(WidgetTester tester, Activity activity) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ActivityEngineView(activity: activity, onAnswered: (_) {})),
    ));
  }

  testWidgets('renders MultipleChoiceEngine for multipleChoice activities', (tester) async {
    const activity = Activity(
      id: 'a',
      subject: SubjectId.science,
      type: ActivityType.multipleChoice,
      payload: MultipleChoicePayload(prompt: 'p', icon: Icons.pets, options: ['1', '2', '3', '4'], correctIndex: 0),
    );
    await pumpFor(tester, activity);
    expect(find.byType(MultipleChoiceEngine), findsOneWidget);
  });

  testWidgets('renders NumericInputEngine for numericInput activities', (tester) async {
    const activity = Activity(
      id: 'a',
      subject: SubjectId.math,
      type: ActivityType.numericInput,
      payload: NumericInputPayload(prompt: 'p', itemIcon: Icons.star, itemCount: 3),
    );
    await pumpFor(tester, activity);
    expect(find.byType(NumericInputEngine), findsOneWidget);
  });

  testWidgets('renders SpellingEngine for spelling activities', (tester) async {
    const activity = Activity(
      id: 'a',
      subject: SubjectId.english,
      type: ActivityType.spelling,
      payload: SpellingPayload(prompt: 'p', icon: Icons.pets, targetWord: 'CAT', letterBank: ['C', 'A', 'T']),
    );
    await pumpFor(tester, activity);
    expect(find.byType(SpellingEngine), findsOneWidget);
  });

  testWidgets('renders MatchingEngine for matching activities', (tester) async {
    const activity = Activity(
      id: 'a',
      subject: SubjectId.jawi,
      type: ActivityType.matching,
      payload: MatchingPayload(pairs: [
        MatchPair(left: 'a', rightLabel: 'b', rightIcon: Icons.circle),
        MatchPair(left: 'c', rightLabel: 'd', rightIcon: Icons.circle),
      ], prompt: 'p'),
    );
    await pumpFor(tester, activity);
    expect(find.byType(MatchingEngine), findsOneWidget);
  });
}

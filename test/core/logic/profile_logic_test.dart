import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/logic/profile_logic.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/profile_state.dart';
import 'package:flutter/material.dart';

const _mathActivity1 = Activity(
  id: 'm1',
  subject: SubjectId.math,
  type: ActivityType.numericInput,
  payload: NumericInputPayload(prompt: 'p', itemIcon: Icons.star, itemCount: 1),
);
const _mathActivity2 = Activity(
  id: 'm2',
  subject: SubjectId.math,
  type: ActivityType.numericInput,
  payload: NumericInputPayload(prompt: 'p', itemIcon: Icons.star, itemCount: 2),
);

final _content = {
  SubjectId.math: [_mathActivity1, _mathActivity2],
  SubjectId.science: <Activity>[],
  SubjectId.english: <Activity>[],
  SubjectId.bahasaMelayu: <Activity>[],
  SubjectId.jawi: <Activity>[],
};

void main() {
  test('an incorrect answer does not change state', () {
    final start = ProfileState.initial();
    final result = applyActivityResult(start, activity: _mathActivity1, wasCorrect: false, contentBySubject: _content);
    expect(result.stars, start.stars);
    expect(result.completedActivityIds, start.completedActivityIds);
  });

  test('a correct answer adds a star, smart points, and marks the activity complete', () {
    final start = ProfileState.initial();
    final result = applyActivityResult(start, activity: _mathActivity1, wasCorrect: true, contentBySubject: _content);
    expect(result.stars, start.stars + 1);
    expect(result.smartPoints, start.smartPoints + 5);
    expect(result.completedActivityIds, contains('m1'));
  });

  test('subjectProgress reflects fraction of that subject completed', () {
    var state = ProfileState.initial();
    state = applyActivityResult(state, activity: _mathActivity1, wasCorrect: true, contentBySubject: _content);
    expect(state.subjectProgress(SubjectId.math, _content), 0.5);

    state = applyActivityResult(state, activity: _mathActivity2, wasCorrect: true, contentBySubject: _content);
    expect(state.subjectProgress(SubjectId.math, _content), 1.0);
  });

  test('Math Master badge unlocks once all math activities are completed', () {
    var state = ProfileState.initial();
    state = applyActivityResult(state, activity: _mathActivity1, wasCorrect: true, contentBySubject: _content);
    expect(state.unlockedBadgeIds, isNot(contains('math_master')));

    state = applyActivityResult(state, activity: _mathActivity2, wasCorrect: true, contentBySubject: _content);
    expect(state.unlockedBadgeIds, contains('math_master'));
  });

  test('Champion badge unlocks after 10 distinct completed activities', () {
    var state = ProfileState.initial();
    for (var i = 0; i < 10; i++) {
      final activity = Activity(
        id: 'extra_$i',
        subject: SubjectId.math,
        type: ActivityType.numericInput,
        payload: const NumericInputPayload(prompt: 'p', itemIcon: Icons.star, itemCount: 1),
      );
      state = applyActivityResult(state, activity: activity, wasCorrect: true, contentBySubject: _content);
    }
    expect(state.unlockedBadgeIds, contains('champion'));
  });
}

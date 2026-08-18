import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';

void main() {
  test('subjectCatalog has an entry for every SubjectId', () {
    for (final id in SubjectId.values) {
      expect(subjectCatalog.containsKey(id), isTrue, reason: '$id missing from subjectCatalog');
      expect(subjectCatalog[id]!.id, id);
    }
  });

  test('MultipleChoicePayload activity carries its fields', () {
    const payload = MultipleChoicePayload(
      prompt: 'Q?',
      icon: Icons.pets,
      options: ['A', 'B', 'C', 'D'],
      correctIndex: 2,
    );
    final activity = Activity(
      id: 'test_1',
      subject: SubjectId.science,
      type: ActivityType.multipleChoice,
      payload: payload,
    );

    expect(activity.subject, SubjectId.science);
    expect((activity.payload as MultipleChoicePayload).correctIndex, 2);
  });
}

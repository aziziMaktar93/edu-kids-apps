import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/content/all_content.dart';
import 'package:edukids/core/models/activity.dart';

bool _bankContainsWord(List<String> bank, String word) {
  final available = Map<String, int>.from({});
  for (final letter in bank) {
    available[letter] = (available[letter] ?? 0) + 1;
  }
  for (final letter in word.split('')) {
    final remaining = available[letter] ?? 0;
    if (remaining <= 0) return false;
    available[letter] = remaining - 1;
  }
  return true;
}

void main() {
  test('every subject has at least 5 activities', () {
    for (final id in SubjectId.values) {
      final activities = contentBySubject[id] ?? [];
      expect(activities.length, greaterThanOrEqualTo(5), reason: '$id has too few activities');
    }
  });

  test('activity ids are unique across the whole catalog', () {
    final allIds = contentBySubject.values.expand((list) => list.map((a) => a.id)).toList();
    expect(allIds.toSet().length, allIds.length);
  });

  test('multiple choice activities have 4 options and a valid correctIndex', () {
    final all = contentBySubject.values.expand((l) => l).where((a) => a.type == ActivityType.multipleChoice);
    for (final activity in all) {
      final payload = activity.payload as MultipleChoicePayload;
      expect(payload.options.length, 4, reason: activity.id);
      expect(payload.correctIndex, inInclusiveRange(0, 3), reason: activity.id);
    }
  });

  test('numeric input activities have a positive item count', () {
    final all = contentBySubject.values.expand((l) => l).where((a) => a.type == ActivityType.numericInput);
    for (final activity in all) {
      final payload = activity.payload as NumericInputPayload;
      expect(payload.itemCount, greaterThan(0), reason: activity.id);
    }
  });

  test('spelling activities have a letter bank that can spell the target word', () {
    final all = contentBySubject.values.expand((l) => l).where((a) => a.type == ActivityType.spelling);
    for (final activity in all) {
      final payload = activity.payload as SpellingPayload;
      expect(
        _bankContainsWord(payload.letterBank, payload.targetWord),
        isTrue,
        reason: '${activity.id}: bank ${payload.letterBank} cannot spell ${payload.targetWord}',
      );
    }
  });

  test('matching activities have at least 2 pairs', () {
    final all = contentBySubject.values.expand((l) => l).where((a) => a.type == ActivityType.matching);
    for (final activity in all) {
      final payload = activity.payload as MatchingPayload;
      expect(payload.pairs.length, greaterThanOrEqualTo(2), reason: activity.id);
    }
  });
}

import 'package:flutter/material.dart';
import 'subject.dart';

export 'subject.dart';

enum ActivityType { multipleChoice, numericInput, spelling, matching }

class Activity {
  final String id;
  final SubjectId subject;
  final ActivityType type;
  final Object payload;

  const Activity({
    required this.id,
    required this.subject,
    required this.type,
    required this.payload,
  });
}

class MultipleChoicePayload {
  final String prompt;
  final IconData icon;
  final List<String> options;
  final int correctIndex;

  const MultipleChoicePayload({
    required this.prompt,
    required this.icon,
    required this.options,
    required this.correctIndex,
  });
}

class NumericInputPayload {
  final String prompt;
  final IconData itemIcon;
  final int itemCount;

  const NumericInputPayload({
    required this.prompt,
    required this.itemIcon,
    required this.itemCount,
  });
}

class SpellingPayload {
  final String prompt;
  final IconData icon;
  final String targetWord;
  final List<String> letterBank;

  const SpellingPayload({
    required this.prompt,
    required this.icon,
    required this.targetWord,
    required this.letterBank,
  });
}

class MatchPair {
  final String left;
  final String rightLabel;
  final IconData rightIcon;

  const MatchPair({
    required this.left,
    required this.rightLabel,
    required this.rightIcon,
  });
}

class MatchingPayload {
  final String prompt;
  final List<MatchPair> pairs;

  const MatchingPayload({required this.prompt, required this.pairs});
}

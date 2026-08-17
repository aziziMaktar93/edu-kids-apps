import 'package:flutter/material.dart';
import '../../../core/models/activity.dart';
import 'matching_engine.dart';
import 'multiple_choice_engine.dart';
import 'numeric_input_engine.dart';
import 'spelling_engine.dart';

class ActivityEngineView extends StatelessWidget {
  final Activity activity;
  final ValueChanged<bool> onAnswered;

  const ActivityEngineView({super.key, required this.activity, required this.onAnswered});

  @override
  Widget build(BuildContext context) {
    switch (activity.type) {
      case ActivityType.multipleChoice:
        return MultipleChoiceEngine(payload: activity.payload as MultipleChoicePayload, onAnswered: onAnswered);
      case ActivityType.numericInput:
        return NumericInputEngine(payload: activity.payload as NumericInputPayload, onAnswered: onAnswered);
      case ActivityType.spelling:
        return SpellingEngine(payload: activity.payload as SpellingPayload, onAnswered: onAnswered);
      case ActivityType.matching:
        return MatchingEngine(payload: activity.payload as MatchingPayload, onAnswered: onAnswered);
    }
  }
}

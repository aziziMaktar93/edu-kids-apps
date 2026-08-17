import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/profile_state.dart';
import '../models/subject.dart';

class BadgeDefinition {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final bool Function(ProfileState state, Map<SubjectId, List<Activity>> contentBySubject) isUnlocked;

  const BadgeDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}

final List<BadgeDefinition> badgeCatalog = [
  BadgeDefinition(
    id: 'math_master',
    name: 'Math Master',
    description: 'Jago Matematik',
    icon: Icons.calculate,
    isUnlocked: (state, content) => state.subjectProgress(SubjectId.math, content) >= 1.0,
  ),
  BadgeDefinition(
    id: 'science_hero',
    name: 'Science Hero',
    description: 'Ahli Sains',
    icon: Icons.science,
    isUnlocked: (state, content) => state.subjectProgress(SubjectId.science, content) >= 1.0,
  ),
  BadgeDefinition(
    id: 'spelling_master',
    name: 'Spelling Master',
    description: 'Pakar Mengeja',
    icon: Icons.spellcheck,
    isUnlocked: (state, content) =>
        state.subjectProgress(SubjectId.bahasaMelayu, content) >= 1.0 &&
        state.subjectProgress(SubjectId.english, content) >= 1.0,
  ),
  BadgeDefinition(
    id: 'champion',
    name: 'Champion',
    description: 'Selesai 10 Kuiz',
    icon: Icons.emoji_events,
    isUnlocked: (state, content) => state.totalActivitiesCompleted >= 10,
  ),
];

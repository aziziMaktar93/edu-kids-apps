import 'package:flutter/material.dart';
import '../core/models/activity.dart';
import '../core/models/subject.dart';

final List<Activity> mathActivities = [
  const Activity(
    id: 'math_count_stars',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak bintang yang anda nampak?', itemIcon: Icons.star, itemCount: 3),
  ),
  const Activity(
    id: 'math_count_hearts',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak hati yang anda nampak?', itemIcon: Icons.favorite, itemCount: 5),
  ),
  const Activity(
    id: 'math_count_paws',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak tapak kaki yang anda nampak?', itemIcon: Icons.pets, itemCount: 7),
  ),
  const Activity(
    id: 'math_count_flowers',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak bunga yang anda nampak?', itemIcon: Icons.local_florist, itemCount: 4),
  ),
  const Activity(
    id: 'math_count_balls',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak bola yang anda nampak?', itemIcon: Icons.sports_soccer, itemCount: 6),
  ),
  const Activity(
    id: 'math_count_circles',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak bulatan yang anda nampak?', itemIcon: Icons.circle, itemCount: 2),
  ),
  const Activity(
    id: 'math_count_cupcakes',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak kek cawan yang anda nampak?', itemIcon: Icons.cake, itemCount: 8),
  ),
  const Activity(
    id: 'math_count_suns',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak matahari yang anda nampak?', itemIcon: Icons.wb_sunny, itemCount: 5),
  ),
];

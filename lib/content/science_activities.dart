import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> scienceActivities = [
  const Activity(
    id: 'science_saturn',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Apakah nama planet yang mempunyai cincin?',
      icon: Icons.public,
      options: ['Zuhal', 'Marikh', 'Bumi', 'Musytari'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_sunlight',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Dari manakah tumbuhan mendapat cahaya untuk membesar?',
      icon: Icons.wb_sunny,
      options: ['Matahari', 'Bulan', 'Bintang', 'Awan'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_breathing',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Apakah yang kita hirup untuk bernafas?',
      icon: Icons.air,
      options: ['Oksigen', 'Karbon Dioksida', 'Nitrogen', 'Hidrogen'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_eggs',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Haiwan manakah yang bertelur?',
      icon: Icons.egg,
      options: ['Ayam', 'Kucing', 'Anjing', 'Kambing'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_ice',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Apakah keadaan air apabila ia sejuk beku?',
      icon: Icons.ac_unit,
      options: ['Ais', 'Wap', 'Gas', 'Minyak'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_planets',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Berapa banyak planet dalam Sistem Suria kita?',
      icon: Icons.public,
      options: ['8', '5', '10', '6'],
      correctIndex: 0,
    ),
  ),
];

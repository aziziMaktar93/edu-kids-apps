import 'package:flutter/material.dart';
import '../core/models/activity.dart';
import '../core/models/subject.dart';

final List<Activity> bahasaMelayuSpellingActivities = [
  const Activity(
    id: 'bm_spelling_kucing',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama haiwan ini!', icon: Icons.pets, targetWord: 'KUCING', letterBank: ['C', 'I', 'N', 'G', 'A', 'B', 'K', 'U']),
  ),
  const Activity(
    id: 'bm_spelling_bola',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama benda ini!', icon: Icons.sports_soccer, targetWord: 'BOLA', letterBank: ['L', 'A', 'B', 'O', 'T', 'K']),
  ),
  const Activity(
    id: 'bm_spelling_buku',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama benda ini!', icon: Icons.menu_book, targetWord: 'BUKU', letterBank: ['U', 'K', 'B', 'U', 'A', 'T']),
  ),
  const Activity(
    id: 'bm_spelling_ikan',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama haiwan ini!', icon: Icons.set_meal, targetWord: 'IKAN', letterBank: ['A', 'N', 'I', 'K', 'O', 'S']),
  ),
  const Activity(
    id: 'bm_spelling_rumah',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama benda ini!', icon: Icons.house, targetWord: 'RUMAH', letterBank: ['M', 'A', 'H', 'R', 'U', 'T', 'B']),
  ),
];

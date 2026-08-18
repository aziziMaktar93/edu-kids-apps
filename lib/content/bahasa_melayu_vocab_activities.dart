import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> bahasaMelayuVocabActivities = [
  const Activity(
    id: 'bm_vocab_kucing',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.pets, options: ['Kucing', 'Anjing', 'Arnab', 'Burung'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_ayam',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.egg, options: ['Ayam', 'Itik', 'Angsa', 'Burung'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_ikan',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.set_meal, options: ['Ikan', 'Udang', 'Ketam', 'Sotong'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_lembu',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.pets, options: ['Lembu', 'Kambing', 'Kuda', 'Kerbau'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_katak',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.pets, options: ['Katak', 'Ular', 'Buaya', 'Kura-kura'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_singa',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.pets, options: ['Singa', 'Harimau', 'Gajah', 'Monyet'], correctIndex: 0),
  ),
];

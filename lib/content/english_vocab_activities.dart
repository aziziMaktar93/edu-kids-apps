import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> englishVocabActivities = [
  const Activity(
    id: 'english_vocab_lion',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.pets, options: ['Lion', 'Tiger', 'Elephant', 'Monkey'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_elephant',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.pets, options: ['Elephant', 'Giraffe', 'Lion', 'Zebra'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_fish',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.set_meal, options: ['Fish', 'Bird', 'Cat', 'Dog'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_bird',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.egg, options: ['Bird', 'Fish', 'Snake', 'Frog'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_rabbit',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.cruelty_free, options: ['Rabbit', 'Cat', 'Dog', 'Mouse'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_cow',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.pets, options: ['Cow', 'Horse', 'Sheep', 'Goat'], correctIndex: 0),
  ),
];

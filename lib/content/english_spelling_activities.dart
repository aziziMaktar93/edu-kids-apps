import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> englishSpellingActivities = [
  const Activity(
    id: 'english_spelling_cat',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell this animal's name!", icon: Icons.pets, targetWord: 'CAT', letterBank: ['T', 'C', 'A', 'D', 'O']),
  ),
  const Activity(
    id: 'english_spelling_sun',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell what shines in the sky!", icon: Icons.wb_sunny, targetWord: 'SUN', letterBank: ['N', 'S', 'U', 'O', 'B']),
  ),
  const Activity(
    id: 'english_spelling_dog',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell this animal's name!", icon: Icons.pets, targetWord: 'DOG', letterBank: ['G', 'D', 'O', 'A', 'T']),
  ),
  const Activity(
    id: 'english_spelling_fish',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell this animal's name!", icon: Icons.set_meal, targetWord: 'FISH', letterBank: ['S', 'H', 'F', 'I', 'O', 'T']),
  ),
  const Activity(
    id: 'english_spelling_book',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell what you read!", icon: Icons.menu_book, targetWord: 'BOOK', letterBank: ['O', 'K', 'B', 'O', 'A', 'T']),
  ),
];

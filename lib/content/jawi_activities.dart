import 'package:flutter/material.dart';
import '../core/models/activity.dart';

// Letter/word pairings follow each word's genuine Jawi spelling: vowel-
// initial words (Ayam, Epal, Ikan) start with alif (ا) as the vowel
// carrier; Bola/Bakul/Buku/Baju start with ba (ب); Topi starts with ta
// (ت); Kucing/Kereta/Kerusi/Kasut start with kaf (ك); Rumah starts with
// ra (ر); Meja starts with mim (م); Pen starts with pa (ڤ), the
// Malay-specific Jawi letter for the "p" sound Arabic lacks. Each letter
// reappears across activities with a different example word for
// reinforcement. Reviewed against standard beginner Jawi conventions, but
// not by a certified Jawi/Bahasa Melayu curriculum expert — have one
// review before using with real students.
final List<Activity> jawiActivities = [
  const Activity(
    id: 'jawi_match_1',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ا', rightLabel: 'Ayam', rightIcon: Icons.egg),
        MatchPair(left: 'ب', rightLabel: 'Bola', rightIcon: Icons.sports_soccer),
        MatchPair(left: 'ت', rightLabel: 'Topi', rightIcon: Icons.style),
      ],
    ),
  ),
  const Activity(
    id: 'jawi_match_2',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ا', rightLabel: 'Epal', rightIcon: Icons.circle),
        MatchPair(left: 'ب', rightLabel: 'Bakul', rightIcon: Icons.shopping_basket),
        MatchPair(left: 'ك', rightLabel: 'Kucing', rightIcon: Icons.pets),
      ],
    ),
  ),
  const Activity(
    id: 'jawi_match_3',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ا', rightLabel: 'Ikan', rightIcon: Icons.set_meal),
        MatchPair(left: 'ب', rightLabel: 'Buku', rightIcon: Icons.menu_book),
        MatchPair(left: 'ك', rightLabel: 'Kereta', rightIcon: Icons.directions_car),
      ],
    ),
  ),
  const Activity(
    id: 'jawi_match_4',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ب', rightLabel: 'Baju', rightIcon: Icons.checkroom),
        MatchPair(left: 'ك', rightLabel: 'Kerusi', rightIcon: Icons.chair),
        MatchPair(left: 'ر', rightLabel: 'Rumah', rightIcon: Icons.house),
      ],
    ),
  ),
  const Activity(
    id: 'jawi_match_5',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ك', rightLabel: 'Kasut', rightIcon: Icons.directions_walk),
        MatchPair(left: 'م', rightLabel: 'Meja', rightIcon: Icons.table_restaurant),
        MatchPair(left: 'ڤ', rightLabel: 'Pen', rightIcon: Icons.edit),
      ],
    ),
  ),
];

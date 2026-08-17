import 'package:flutter/material.dart';
import '../core/models/activity.dart';
import '../core/models/subject.dart';

// Letter/word pairings here are for demo purposes (matching-game mechanics
// only, not phonetically accurate Jawi spelling) — have a Bahasa
// Melayu/Jawi curriculum expert review before shipping to real users.
final List<Activity> jawiActivities = [
  const Activity(
    id: 'jawi_match_1',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ا', rightLabel: 'Epal', rightIcon: Icons.circle),
        MatchPair(left: 'ب', rightLabel: 'Bola', rightIcon: Icons.sports_soccer),
        MatchPair(left: 'ت', rightLabel: 'Bakul', rightIcon: Icons.shopping_basket),
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
        MatchPair(left: 'ث', rightLabel: 'Ayam', rightIcon: Icons.egg),
        MatchPair(left: 'ج', rightLabel: 'Ikan', rightIcon: Icons.set_meal),
        MatchPair(left: 'ح', rightLabel: 'Kucing', rightIcon: Icons.pets),
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
        MatchPair(left: 'خ', rightLabel: 'Rumah', rightIcon: Icons.house),
        MatchPair(left: 'د', rightLabel: 'Kereta', rightIcon: Icons.directions_car),
        MatchPair(left: 'ذ', rightLabel: 'Buku', rightIcon: Icons.menu_book),
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
        MatchPair(left: 'ر', rightLabel: 'Pen', rightIcon: Icons.edit),
        MatchPair(left: 'ز', rightLabel: 'Meja', rightIcon: Icons.table_restaurant),
        MatchPair(left: 'س', rightLabel: 'Kerusi', rightIcon: Icons.chair),
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
        MatchPair(left: 'ش', rightLabel: 'Baju', rightIcon: Icons.checkroom),
        MatchPair(left: 'ص', rightLabel: 'Topi', rightIcon: Icons.style),
        MatchPair(left: 'ض', rightLabel: 'Kasut', rightIcon: Icons.directions_walk),
      ],
    ),
  ),
];

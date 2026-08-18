import '../core/models/activity.dart';
import 'bahasa_melayu_spelling_activities.dart';
import 'bahasa_melayu_vocab_activities.dart';
import 'english_spelling_activities.dart';
import 'english_vocab_activities.dart';
import 'jawi_activities.dart';
import 'math_activities.dart';
import 'science_activities.dart';

final Map<SubjectId, List<Activity>> contentBySubject = {
  SubjectId.math: mathActivities,
  SubjectId.science: scienceActivities,
  SubjectId.english: [...englishVocabActivities, ...englishSpellingActivities],
  SubjectId.bahasaMelayu: [...bahasaMelayuVocabActivities, ...bahasaMelayuSpellingActivities],
  SubjectId.jawi: jawiActivities,
};

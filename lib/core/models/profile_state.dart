import 'activity.dart';
import 'age_group.dart';

class ProfileState {
  final String childName;
  final int stars;
  final int smartPoints;
  final int daysLearning;
  final int chestStars;
  final Set<String> completedActivityIds;
  final Set<String> unlockedBadgeIds;
  final AgeGroup? ageGroup;

  const ProfileState({
    required this.childName,
    required this.stars,
    required this.smartPoints,
    required this.daysLearning,
    required this.chestStars,
    required this.completedActivityIds,
    required this.unlockedBadgeIds,
    this.ageGroup,
  });

  factory ProfileState.initial() => const ProfileState(
        childName: 'Adli',
        stars: 0,
        smartPoints: 0,
        daysLearning: 1,
        chestStars: 0,
        completedActivityIds: {},
        unlockedBadgeIds: {},
        ageGroup: null,
      );

  double subjectProgress(SubjectId subject, Map<SubjectId, List<Activity>> contentBySubject) {
    final activities = contentBySubject[subject] ?? const [];
    if (activities.isEmpty) return 0;
    final completed = activities.where((a) => completedActivityIds.contains(a.id)).length;
    return completed / activities.length;
  }

  int get totalActivitiesCompleted => completedActivityIds.length;

  ProfileState copyWith({
    String? childName,
    int? stars,
    int? smartPoints,
    int? daysLearning,
    int? chestStars,
    Set<String>? completedActivityIds,
    Set<String>? unlockedBadgeIds,
    AgeGroup? ageGroup,
  }) {
    return ProfileState(
      childName: childName ?? this.childName,
      stars: stars ?? this.stars,
      smartPoints: smartPoints ?? this.smartPoints,
      daysLearning: daysLearning ?? this.daysLearning,
      chestStars: chestStars ?? this.chestStars,
      completedActivityIds: completedActivityIds ?? this.completedActivityIds,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
      ageGroup: ageGroup ?? this.ageGroup,
    );
  }

  Map<String, dynamic> toMap() => {
        'childName': childName,
        'stars': stars,
        'smartPoints': smartPoints,
        'daysLearning': daysLearning,
        'chestStars': chestStars,
        'completedActivityIds': completedActivityIds.toList(),
        'unlockedBadgeIds': unlockedBadgeIds.toList(),
        'ageGroup': ageGroup?.name,
      };

  factory ProfileState.fromMap(Map<dynamic, dynamic> map) => ProfileState(
        childName: map['childName'] as String,
        stars: map['stars'] as int,
        smartPoints: map['smartPoints'] as int,
        daysLearning: map['daysLearning'] as int,
        chestStars: map['chestStars'] as int,
        completedActivityIds: Set<String>.from(map['completedActivityIds'] as List),
        unlockedBadgeIds: Set<String>.from(map['unlockedBadgeIds'] as List),
        ageGroup: map['ageGroup'] == null ? null : AgeGroup.values.byName(map['ageGroup'] as String),
      );
}

import '../models/activity.dart';
import '../models/profile_state.dart';
import '../models/subject.dart';
import 'badges.dart';

ProfileState applyActivityResult(
  ProfileState state, {
  required Activity activity,
  required bool wasCorrect,
  required Map<SubjectId, List<Activity>> contentBySubject,
}) {
  if (!wasCorrect) return state;

  final updated = state.copyWith(
    stars: state.stars + 1,
    smartPoints: state.smartPoints + 5,
    chestStars: (state.chestStars + 1).clamp(0, 100),
    completedActivityIds: {...state.completedActivityIds, activity.id},
  );

  final newlyUnlocked = badgeCatalog
      .where((b) => !updated.unlockedBadgeIds.contains(b.id))
      .where((b) => b.isUnlocked(updated, contentBySubject))
      .map((b) => b.id);

  return updated.copyWith(unlockedBadgeIds: {...updated.unlockedBadgeIds, ...newlyUnlocked});
}

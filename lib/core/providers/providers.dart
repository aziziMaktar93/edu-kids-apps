import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/profile_logic.dart';
import '../models/activity.dart';
import '../models/age_group.dart';
import '../models/profile_state.dart';
import '../storage/profile_repository.dart';
import '../../content/all_content.dart';

export '../models/age_group.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  throw UnimplementedError('Override profileRepositoryProvider in main() after ProfileRepository.init()');
});

final contentProvider = Provider<Map<SubjectId, List<Activity>>>((ref) => contentBySubject);

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => ref.read(profileRepositoryProvider).load();

  void answerActivity(Activity activity, bool wasCorrect) {
    final content = ref.read(contentProvider);
    final updated = applyActivityResult(
      state,
      activity: activity,
      wasCorrect: wasCorrect,
      contentBySubject: content,
    );
    state = updated;
    _persist(updated);
  }

  /// Persists the child's chosen [AgeGroup] on the profile so it survives
  /// app restarts (see the router redirect in `core/router/app_router.dart`,
  /// which uses this to skip straight to `/learn` on subsequent launches).
  void setAgeGroup(AgeGroup ageGroup) {
    final updated = state.copyWith(ageGroup: ageGroup);
    state = updated;
    _persist(updated);
  }

  // Fire-and-forget with an error handler: a failed write shouldn't become an
  // uncaught async error and crash the app. The in-memory `state` above has
  // already been updated, so the UI stays usable for this session even if
  // the write to disk fails.
  void _persist(ProfileState state) {
    ref.read(profileRepositoryProvider).save(state).catchError((Object error, StackTrace stackTrace) {
      debugPrint('ProfileNotifier: failed to persist profile state. $error\n$stackTrace');
    });
  }
}

final selectedAgeGroupProvider = StateProvider<AgeGroup?>((ref) => null);

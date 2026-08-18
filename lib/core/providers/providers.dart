import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/profile_logic.dart';
import '../models/activity.dart';
import '../models/profile_state.dart';
import '../storage/profile_repository.dart';
import '../../content/all_content.dart';

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
    ref.read(profileRepositoryProvider).save(updated);
  }
}

enum AgeGroup { prasekolah, tahapSatu, tahapDua }

final selectedAgeGroupProvider = StateProvider<AgeGroup?>((ref) => null);

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/profile_state.dart';

class ProfileRepository {
  static const _boxName = 'profile_box';
  static const _key = 'profile';

  late Box _box;

  /// Opens the Hive box, recovering from a corrupt box file instead of
  /// leaving the app unable to start (a black screen forever is worse than
  /// losing local progress data).
  Future<void> init() async {
    try {
      _box = await Hive.openBox(_boxName);
    } catch (error, stackTrace) {
      debugPrint('ProfileRepository.init: box "$_boxName" failed to open, recreating it. $error\n$stackTrace');
      await Hive.deleteBoxFromDisk(_boxName);
      _box = await Hive.openBox(_boxName);
    }
  }

  /// Loads the saved profile, falling back to [ProfileState.initial] if the
  /// stored data is missing, malformed, or otherwise fails to deserialize
  /// (e.g. a corrupt box entry or an unexpected field type/shape).
  ProfileState load() {
    final raw = _box.get(_key);
    if (raw == null) return ProfileState.initial();
    try {
      return ProfileState.fromMap(raw as Map);
    } catch (error, stackTrace) {
      debugPrint('ProfileRepository.load: stored profile was malformed, falling back to initial state. $error\n$stackTrace');
      return ProfileState.initial();
    }
  }

  Future<void> save(ProfileState state) => _box.put(_key, state.toMap());

  /// Writes a raw, possibly-malformed map directly into the box, bypassing
  /// [ProfileState.toMap]. Exists only so tests can simulate a corrupt/old
  /// on-disk schema and assert that [load] degrades gracefully instead of
  /// throwing.
  @visibleForTesting
  Future<void> rawBoxPutForTest(Map<String, dynamic> raw) => _box.put(_key, raw);
}

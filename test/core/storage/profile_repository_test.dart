import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/profile_state.dart';
import 'package:edukids/core/storage/profile_repository.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_hive_test_');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('load() returns ProfileState.initial() when nothing was saved yet', () async {
    final repo = ProfileRepository();
    await repo.init();
    final loaded = repo.load();
    expect(loaded.childName, ProfileState.initial().childName);
    expect(loaded.stars, 0);
  });

  test('save() then load() round-trips the profile state', () async {
    final repo = ProfileRepository();
    await repo.init();

    final state = ProfileState.initial().copyWith(
      stars: 42,
      smartPoints: 100,
      completedActivityIds: {'a', 'b'},
      unlockedBadgeIds: {'math_master'},
    );
    await repo.save(state);

    final reloaded = repo.load();
    expect(reloaded.stars, 42);
    expect(reloaded.smartPoints, 100);
    expect(reloaded.completedActivityIds, {'a', 'b'});
    expect(reloaded.unlockedBadgeIds, {'math_master'});
  });
}

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/age_group.dart';
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
      ageGroup: AgeGroup.tahapDua,
    );
    await repo.save(state);

    final reloaded = repo.load();
    expect(reloaded.stars, 42);
    expect(reloaded.smartPoints, 100);
    expect(reloaded.completedActivityIds, {'a', 'b'});
    expect(reloaded.unlockedBadgeIds, {'math_master'});
    expect(reloaded.ageGroup, AgeGroup.tahapDua);
  });

  test('load() degrades to ProfileState.initial() instead of throwing when the stored map is malformed', () async {
    final repo = ProfileRepository();
    await repo.init();

    // Missing required fields and a wrong type for a field that is present:
    // this should never be able to crash ProfileNotifier.build() just
    // because the on-disk box got corrupted or written by an older schema.
    await repo.rawBoxPutForTest({'childName': 'Adli', 'stars': 'not-a-number'});

    final loaded = repo.load();
    expect(loaded.childName, ProfileState.initial().childName);
    expect(loaded.stars, ProfileState.initial().stars);
  });

  test('load() degrades to ProfileState.initial() when ageGroup is an unrecognized value', () async {
    final repo = ProfileRepository();
    await repo.init();

    final validMapWithBadAgeGroup = ProfileState.initial().toMap()..['ageGroup'] = 'not_a_real_age_group';
    await repo.rawBoxPutForTest(validMapWithBadAgeGroup);

    final loaded = repo.load();
    expect(loaded.ageGroup, isNull);
  });
}

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/subject.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/content/all_content.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_providers_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('profileProvider loads the initial state from the repository', () {
    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    expect(container.read(profileProvider).stars, 0);
  });

  test('answerActivity updates profile state and persists it', () {
    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    final activity = contentBySubject[SubjectId.math]!.first;
    container.read(profileProvider.notifier).answerActivity(activity, true);

    expect(container.read(profileProvider).stars, 1);
    expect(repository.load().stars, 1);
  });

  test('contentProvider exposes the seeded content catalog', () {
    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    expect(container.read(contentProvider), contentBySubject);
  });

  test('selectedAgeGroupProvider defaults to null and can be set', () {
    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    expect(container.read(selectedAgeGroupProvider), isNull);
    container.read(selectedAgeGroupProvider.notifier).state = AgeGroup.tahapSatu;
    expect(container.read(selectedAgeGroupProvider), AgeGroup.tahapSatu);
  });
}

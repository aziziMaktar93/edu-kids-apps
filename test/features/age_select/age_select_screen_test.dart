import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/age_select/age_select_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_age_select_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('Teruskan is disabled until an age group is picked, then navigates to /learn and persists it',
      (tester) async {
    String? location;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const AgeSelectScreen()),
      GoRoute(
        path: '/learn',
        builder: (context, state) {
          location = state.uri.toString();
          return const Scaffold(body: Text('learn'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    ));

    final continueButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Teruskan'));
    expect(continueButton.onPressed, isNull);

    await tester.tap(find.text('Tahap Satu'));
    await tester.pump();
    // Tapping "Teruskan" now calls ProfileNotifier.setAgeGroup, which fires a
    // real (unawaited) Hive box write via ProfileRepository.save(). Widget
    // tests run inside a fake-time zone, so a real dart:io/Hive Future
    // started outside runAsync never completes -- nothing ever advances real
    // time for it -- which then hangs tearDown's Hive.deleteFromDisk()
    // forever. Wrapping the tap in runAsync switches to a real zone so the
    // write actually finishes. Same pattern as
    // test/features/subject/activity_session_screen_test.dart (Task 14).
    await tester.runAsync(() async {
      await tester.tap(find.text('Teruskan'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    expect(location, '/learn');
    expect(repository.load().ageGroup, AgeGroup.tahapSatu);
  });
}

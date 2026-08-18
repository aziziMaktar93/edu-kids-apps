import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/router/app_router.dart';
import 'package:edukids/core/storage/profile_repository.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_router_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('app starts at the splash screen and can reach the Learn tab with bottom nav visible', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: appRouter),
    ));

    expect(find.text('EduKids'), findsOneWidget);
    expect(find.text('Mula'), findsOneWidget);

    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Umur Kamu'), findsOneWidget);

    await tester.tap(find.text('Tahap Satu'));
    await tester.pump();
    // Tapping "Teruskan" calls ProfileNotifier.setAgeGroup, which fires a
    // real (unawaited) Hive box write via ProfileRepository.save(). A real
    // dart:io/Hive Future started outside runAsync never completes inside
    // flutter_test's fake-time zone, which then hangs tearDown's
    // Hive.deleteFromDisk() forever. Wrapping the tap in runAsync switches to
    // a real zone so the write actually finishes. Same pattern as
    // test/features/subject/activity_session_screen_test.dart (Task 14).
    await tester.runAsync(() async {
      await tester.tap(find.text('Teruskan'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    expect(find.text('Jom Belajar!'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('nested subject route and bottom nav destinations are reachable through the real router', (tester) async {
    // appRouter is a top-level singleton, so its navigation state can carry
    // over from a previous test in this file (e.g. left at /learn). Reset it
    // to the app's real entry point before pumping so this test starts fresh
    // regardless of run order.
    appRouter.go('/splash');

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: appRouter),
    ));

    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tahap Satu'));
    await tester.pump();
    // See the runAsync comment in the first test above: setAgeGroup's
    // real (unawaited) Hive write must be allowed to actually complete.
    await tester.runAsync(() async {
      await tester.tap(find.text('Teruskan'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    // Nested route: tapping a subject on the hub should push /learn/:subjectId
    // and keep the shell (bottom nav) mounted.
    await tester.tap(find.text('Matematik'));
    await tester.pumpAndSettle();
    expect(find.text('Mula'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    // Bottom nav destination: tapping "Pencapaian" should goBranch to /awards.
    await tester.tap(find.text('Pencapaian'));
    await tester.pumpAndSettle();
    expect(find.text('Pencapaian Kamu'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}

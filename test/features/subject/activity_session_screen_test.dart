import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/subject.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/subject/activity_session_screen.dart';
import 'package:edukids/features/subject/result_screen.dart';
import 'package:edukids/features/subject/session_result.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  const testActivities = [
    Activity(
      id: 't1',
      subject: SubjectId.math,
      type: ActivityType.numericInput,
      payload: NumericInputPayload(prompt: 'Berapa?', itemIcon: Icons.star, itemCount: 2),
    ),
    Activity(
      id: 't2',
      subject: SubjectId.math,
      type: ActivityType.numericInput,
      payload: NumericInputPayload(prompt: 'Berapa?', itemIcon: Icons.star, itemCount: 1),
    ),
  ];

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_session_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  // Answers the currently visible NumericInputEngine activity by scrolling
  // the digit + check buttons into view (the screen body is a
  // SingleChildScrollView, so the keypad may render below the fold) and
  // tapping them.
  //
  // The tap + check button are wrapped in `tester.runAsync` because tapping
  // "check" synchronously triggers ActivitySessionScreen's
  // ProfileNotifier.answerActivity(), which fires a real (unawaited) Hive
  // box write (ProfileRepository.save). Widget tests run inside a fake-time
  // zone; a real asynchronous Hive/dart:io operation started in that zone
  // never completes because nothing ever advances real time for it, which
  // is what caused `Hive.deleteFromDisk()` in tearDown to hang forever.
  // `runAsync` switches to a real zone for the duration of the callback so
  // that real Future (and the 500ms `Future.delayed` in
  // `_handleAnswered`) can actually run and complete.
  Future<void> answerVisibleActivity(WidgetTester tester, String digit) async {
    final digitButton = find.widgetWithText(ElevatedButton, digit);
    await tester.ensureVisible(digitButton);
    await tester.pump();
    await tester.tap(digitButton);
    await tester.pump();

    final checkIcon = find.byIcon(Icons.check);
    await tester.ensureVisible(checkIcon);
    await tester.pump();
    await tester.runAsync(() async {
      await tester.tap(checkIcon);
      // Let the widget's real 500ms Future.delayed (advance-or-navigate)
      // actually fire, since it was created in this same real zone.
      await Future<void>.delayed(const Duration(milliseconds: 600));
    });
    // One pump reflects the setState/pushReplacement that happened during
    // runAsync; a second is needed for go_router's Router to finish
    // rebuilding into the new page.
    await tester.pump();
    await tester.pump();
  }

  testWidgets('completing all activities in a session navigates to the result screen', (tester) async {
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const ActivitySessionScreen(subject: SubjectId.math)),
      GoRoute(
        path: '/learn/:subjectId/result',
        builder: (context, state) => ResultScreen(result: state.extra as SessionResult),
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        contentProvider.overrideWithValue({
          SubjectId.math: testActivities,
          SubjectId.science: const [],
          SubjectId.english: const [],
          SubjectId.bahasaMelayu: const [],
          SubjectId.jawi: const [],
        }),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pump();

    // Answer question 1 (itemCount 2) correctly.
    await answerVisibleActivity(tester, '2');

    // Answer question 2 (itemCount 1) correctly.
    await answerVisibleActivity(tester, '1');

    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.text('2 / 2 betul'), findsOneWidget);
  });
}

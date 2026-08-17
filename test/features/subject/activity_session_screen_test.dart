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

    // Scroll down to reveal buttons.
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pump();

    // Answer question 1 (itemCount 2) correctly.
    await tester.tap(find.widgetWithText(ElevatedButton, '2'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump(const Duration(milliseconds: 600));

    // Scroll down again for second question.
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pump();

    // Answer question 2 (itemCount 1) correctly.
    await tester.tap(find.widgetWithText(ElevatedButton, '1'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.text('2 / 2 betul'), findsOneWidget);
  });
}

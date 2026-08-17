import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/subject.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/subject/subject_activity_list_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_list_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows the subject name, progress, and a Mula button that navigates to the session route', (tester) async {
    String? pushedRoute;
    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SubjectActivityListScreen(subject: SubjectId.math),
      ),
      GoRoute(
        path: '/learn/math/session',
        builder: (context, state) {
          pushedRoute = state.uri.toString();
          return const Scaffold(body: Text('session screen'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    ));

    expect(find.text('Matematik'), findsWidgets);
    expect(find.text('Mula'), findsOneWidget);

    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();

    expect(pushedRoute, '/learn/math/session');
  });
}

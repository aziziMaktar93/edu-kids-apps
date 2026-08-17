import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/profile/profile_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_profile_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows child name, stats, subject progress bars, and stub buttons', (tester) async {
    String? pushedRoute;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const ProfileScreen()),
      GoRoute(
        path: '/profile/avatar',
        builder: (context, state) {
          pushedRoute = state.uri.toString();
          return const Scaffold(body: Text('avatar screen'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    ));

    expect(find.text('Adli'), findsOneWidget);
    expect(find.text('Kemajuan Saya'), findsOneWidget);
    expect(find.text('Matematik'), findsOneWidget);
    expect(find.text('Tukar Avatar'), findsOneWidget);
    expect(find.text('Ibu Bapa'), findsOneWidget);

    // Scroll to make button visible
    await tester.dragUntilVisible(
      find.text('Tukar Avatar'),
      find.byType(ListView),
      const Offset(0, -100),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tukar Avatar'));
    await tester.pumpAndSettle();

    expect(pushedRoute, '/profile/avatar');
  });
}

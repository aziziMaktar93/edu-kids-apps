import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/hub/hub_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_hub_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows all 5 subject cards and navigates on tap', (tester) async {
    String? pushedRoute;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const HubScreen()),
      GoRoute(
        path: '/learn/math',
        builder: (context, state) {
          pushedRoute = state.uri.toString();
          return const Scaffold(body: Text('math screen'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    ));

    // Check that first 4 subjects are visible
    for (final name in ['Matematik', 'Sains', 'English', 'Bahasa Melayu']) {
      expect(find.text(name), findsOneWidget);
    }

    // Scroll to find the 5th subject
    await tester.drag(find.byType(GridView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('Jawi'), findsOneWidget);

    // Scroll back up to tap Matematik
    await tester.drag(find.byType(GridView), const Offset(0, 300));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Matematik'));
    await tester.pumpAndSettle();

    expect(pushedRoute, '/learn/math');
  });
}

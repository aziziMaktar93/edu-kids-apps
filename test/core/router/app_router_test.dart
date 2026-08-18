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
    await tester.tap(find.text('Teruskan'));
    await tester.pumpAndSettle();

    expect(find.text('Jom Belajar!'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}

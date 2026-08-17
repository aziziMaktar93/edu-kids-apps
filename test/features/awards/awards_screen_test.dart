import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/awards/awards_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_awards_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows chest progress, stats, and the full badge catalog', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: AwardsScreen()),
    ));

    expect(find.text('Peti Harta Karun'), findsOneWidget);
    expect(find.text('0 / 100 Bintang'), findsOneWidget);
    expect(find.text('Math Master'), findsOneWidget);
    expect(find.text('Champion'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsWidgets); // all locked initially
  });
}

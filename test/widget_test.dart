import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:edukids/app.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';

// Hive/tempDir setup and teardown must run in setUp/tearDown (a real async
// zone), not inside the testWidgets callback body. testWidgets runs its
// callback inside flutter_test's fake-async zone from the very first line
// (not just after pumpWidget), so a real dart:io/Hive operation awaited
// directly in the callback body never completes -- nothing ever advances
// real time for it. This bit the brief's original inline version of this
// test (Hive.init/repository.init/Hive.deleteFromDisk called directly
// inside testWidgets), which hung for the full 10-minute test timeout. See
// every other Hive-using test in this suite (e.g.
// test/features/hub/hub_screen_test.dart, test/app_smoke_test.dart) for the
// same setUp/tearDown pattern, and
// test/features/subject/activity_session_screen_test.dart for the sibling
// issue with real Futures created mid-test (fixed there with
// tester.runAsync).
void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tempDir = await Directory.systemTemp.createTemp('edukids_widget_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('EduKidsApp boots to the splash screen', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: const EduKidsApp(),
    ));

    expect(find.text('EduKids'), findsOneWidget);
    expect(find.text('Mula'), findsOneWidget);
  });
}

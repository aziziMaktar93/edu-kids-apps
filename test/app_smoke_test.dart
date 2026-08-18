import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:edukids/app.dart';
import 'package:edukids/content/all_content.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';

// Answers the currently visible NumericInputEngine activity by scrolling the
// digit + check buttons into view and tapping them.
//
// The check-button tap is wrapped in `tester.runAsync` because tapping it
// synchronously triggers ActivitySessionScreen's
// ProfileNotifier.answerActivity(), which fires a real (unawaited) Hive box
// write (ProfileRepository.save). Widget tests run inside a fake-time zone;
// a real asynchronous Hive/dart:io operation started in that zone never
// completes because nothing ever advances real time for it, which hangs
// `Hive.deleteFromDisk()` in tearDown forever. `runAsync` switches to a real
// zone for the duration of the callback so that real Future (and the 500ms
// `Future.delayed` in `_handleAnswered`) can actually run and complete. See
// test/features/subject/activity_session_screen_test.dart for the same
// pattern and a fuller explanation (established in Task 14).
Future<void> _answerNumericInput(WidgetTester tester, int itemCount) async {
  final digitButton = find.widgetWithText(ElevatedButton, '$itemCount');
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

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tempDir = await Directory.systemTemp.createTemp('edukids_smoke_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('full journey: splash -> age select -> hub -> math quiz -> result -> awards -> profile', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: const EduKidsApp(),
    ));

    // Splash -> age select.
    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();

    // Age select -> hub.
    await tester.tap(find.text('Tahap Satu'));
    await tester.pump();
    await tester.tap(find.text('Teruskan'));
    await tester.pumpAndSettle();
    expect(find.text('Jom Belajar!'), findsOneWidget);

    // Hub -> Math activity list -> session.
    await tester.tap(find.text('Matematik'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();

    // Answer every math activity correctly.
    final mathActivities = contentBySubject[SubjectId.math]!;
    for (final activity in mathActivities) {
      final payload = activity.payload as NumericInputPayload;
      await _answerNumericInput(tester, payload.itemCount);
    }
    await tester.pumpAndSettle();

    expect(find.text('${mathActivities.length} / ${mathActivities.length} betul'), findsOneWidget);

    // Result -> back to Math list. This route is nested inside the
    // StatefulShellRoute, so the bottom NavigationBar (with the
    // 'Pencapaian'/'Profil' destinations) stays visible without an extra
    // hop through the Learn tab.
    await tester.tap(find.text('Teruskan'));
    await tester.pumpAndSettle();

    // The bottom-nav destination label is 'Pencapaian' (translated to
    // Bahasa Melayu in Task 20) -- see lib/core/router/app_shell.dart. It's
    // the only 'Pencapaian' on screen right now (Math list's AppBar title
    // is 'Matematik'), so the tap target is unambiguous.
    await tester.tap(find.text('Pencapaian'));
    await tester.pumpAndSettle();
    // AwardsScreen renders every badge's name unconditionally regardless of
    // unlock state -- only the icon switches, via
    // `Icon(unlocked ? badge.icon : Icons.lock)` (see
    // lib/features/awards/awards_screen.dart). So `find.text('Jaguh
    // Matematik')` would pass even at zero progress, and it wouldn't prove
    // profile.unlockedBadgeIds actually got updated. Assert on the icon
    // instead: Icons.calculate is the math_master badge's icon (see
    // lib/core/logic/badges.dart) and is shown only when unlocked, and it
    // appears nowhere else on this screen.
    expect(find.byIcon(Icons.calculate), findsOneWidget);
    // The other three badges (science_hero, spelling_master, champion) are
    // still locked.
    expect(find.byIcon(Icons.lock), findsNWidgets(3));

    // The bottom-nav destination label is 'Profil'. Right now (still on
    // AwardsScreen, whose AppBar title is 'Pencapaian Kamu') 'Profil' only
    // appears once, in the nav bar, so this tap is unambiguous even though
    // ProfileScreen's own AppBar title is also 'Profil'.
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('100%'), findsOneWidget);
  });
}

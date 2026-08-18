import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/providers/providers.dart';
import 'core/storage/profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // EduKids is offline-only, and release Android builds don't grant
  // INTERNET, so runtime fetching from fonts.gstatic.com must stay disabled
  // rather than be left as an implicit, sometimes-silently-failing network
  // dependency. The Plus Jakarta Sans / Quicksand weights buildAppTheme()
  // (lib/core/theme/app_theme.dart) needs are bundled as local assets (see
  // assets/fonts/ and the `fonts:`-free `assets:` entry in pubspec.yaml, per
  // the google_fonts package's local-asset-manifest lookup convention), so
  // this flag only forces use of those bundled files -- it does not fall
  // back to the system font.
  GoogleFonts.config.allowRuntimeFetching = false;
  await Hive.initFlutter();
  final repository = ProfileRepository();
  await repository.init();

  runApp(
    ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: const EduKidsApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/providers/providers.dart';
import 'core/storage/profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // EduKids is offline-only: no font assets are bundled (see pubspec.yaml),
  // and release Android builds don't grant INTERNET, so runtime fetching
  // from fonts.gstatic.com must be disabled rather than left as an
  // implicit, silently-failing network dependency. This makes buildAppTheme()
  // (lib/core/theme/app_theme.dart) fall back to the default system font
  // deterministically instead of depending on network access.
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

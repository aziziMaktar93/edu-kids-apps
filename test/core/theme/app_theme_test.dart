import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edukids/core/theme/app_colors.dart';
import 'package:edukids/core/theme/app_theme.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('theme exposes the design-token primary color', (tester) async {
    final theme = buildAppTheme();
    await tester.pumpWidget(MaterialApp(
      theme: theme,
      home: Builder(
        builder: (context) => Scaffold(
          body: Text('hi', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
    ));

    final text = tester.widget<Text>(find.text('hi'));
    expect(text.style?.color, AppColors.primary);
    expect(theme.colorScheme.error, AppColors.error);
    expect(theme.useMaterial3, isTrue);
  });
}

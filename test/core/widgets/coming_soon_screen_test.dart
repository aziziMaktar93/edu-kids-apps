import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/widgets/coming_soon_screen.dart';

void main() {
  testWidgets('ComingSoonScreen shows the given title in the app bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ComingSoonScreen(title: 'Tukar Avatar')));
    expect(find.widgetWithText(AppBar, 'Tukar Avatar'), findsOneWidget);
  });
}

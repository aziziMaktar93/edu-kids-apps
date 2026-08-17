import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/main.dart';

void main() {
  testWidgets('placeholder shows EduKids', (tester) async {
    await tester.pumpWidget(const EduKidsPlaceholder());
    expect(find.text('EduKids'), findsOneWidget);
  });
}

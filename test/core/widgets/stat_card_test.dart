import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/widgets/stat_card.dart';

void main() {
  testWidgets('StatCard shows its label and value', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: StatCard(label: 'BINTANG', value: '1,250')),
    ));
    expect(find.text('BINTANG'), findsOneWidget);
    expect(find.text('1,250'), findsOneWidget);
  });
}

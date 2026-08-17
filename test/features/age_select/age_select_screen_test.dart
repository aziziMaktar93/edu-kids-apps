import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:edukids/features/age_select/age_select_screen.dart';

void main() {
  testWidgets('Teruskan is disabled until an age group is picked, then navigates to /learn', (tester) async {
    String? location;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const AgeSelectScreen()),
      GoRoute(
        path: '/learn',
        builder: (context, state) {
          location = state.uri.toString();
          return const Scaffold(body: Text('learn'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));

    final continueButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Teruskan'));
    expect(continueButton.onPressed, isNull);

    await tester.tap(find.text('Tahap Satu'));
    await tester.pump();
    await tester.tap(find.text('Teruskan'));
    await tester.pumpAndSettle();

    expect(location, '/learn');
  });
}

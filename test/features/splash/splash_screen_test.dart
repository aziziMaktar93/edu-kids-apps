import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:edukids/features/splash/splash_screen.dart';

void main() {
  testWidgets('tapping Mula navigates to /age-select', (tester) async {
    String? location;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/age-select',
        builder: (context, state) {
          location = state.uri.toString();
          return const Scaffold(body: Text('age select'));
        },
      ),
    ]);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    expect(find.text('EduKids'), findsOneWidget);

    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();

    expect(location, '/age-select');
  });
}

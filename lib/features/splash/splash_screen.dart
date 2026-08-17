import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'EduKids',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            const Text("Let's learn and play!"),
            const SizedBox(height: 48),
            const Icon(Icons.child_care, size: 120, color: Colors.blue),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () => context.go('/age-select'),
                child: const Text('Mula'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

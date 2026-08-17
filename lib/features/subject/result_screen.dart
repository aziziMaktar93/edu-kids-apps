import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/subject.dart';
import 'session_result.dart';

class ResultScreen extends StatelessWidget {
  final SessionResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final info = subjectCatalog[result.subject]!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 96, color: info.color),
            const SizedBox(height: 16),
            Text('Syabas!', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 8),
            Text('${result.correctCount} / ${result.totalCount} betul', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/learn/${result.subject.name}'),
              child: const Text('Teruskan'),
            ),
          ],
        ),
      ),
    );
  }
}

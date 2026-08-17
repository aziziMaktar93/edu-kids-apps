import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/subject.dart';
import '../../core/providers/providers.dart';

class SubjectActivityListScreen extends ConsumerWidget {
  final SubjectId subject;

  const SubjectActivityListScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = subjectCatalog[subject]!;
    final activities = ref.watch(contentProvider)[subject]!;
    final profile = ref.watch(profileProvider);
    final completedCount = activities.where((a) => profile.completedActivityIds.contains(a.id)).length;

    return Scaffold(
      appBar: AppBar(title: Text(info.name), backgroundColor: info.color),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(info.tagline, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: activities.isEmpty ? 0 : completedCount / activities.length),
                Text('$completedCount / ${activities.length} selesai'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, i) {
                final done = profile.completedActivityIds.contains(activities[i].id);
                return ListTile(
                  leading: Icon(done ? Icons.check_circle : Icons.radio_button_unchecked, color: done ? Colors.green : Colors.grey),
                  title: Text('Soalan ${i + 1}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => context.push('/learn/${subject.name}/session'),
              style: ElevatedButton.styleFrom(backgroundColor: info.color),
              child: const Text('Mula'),
            ),
          ),
        ],
      ),
    );
  }
}

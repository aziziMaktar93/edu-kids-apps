import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/subject.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/stat_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final content = ref.watch(contentProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(radius: 48, child: Icon(Icons.face, size: 48)),
                const SizedBox(height: 8),
                Text(profile.childName, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatCard(label: 'BINTANG', value: '${profile.stars}')),
              const SizedBox(width: 8),
              Expanded(child: StatCard(label: 'HARI BELAJAR', value: '${profile.daysLearning}')),
              const SizedBox(width: 8),
              Expanded(child: StatCard(label: 'LENCANA', value: '${profile.unlockedBadgeIds.length}')),
            ],
          ),
          const SizedBox(height: 16),
          Text('Kemajuan Saya', style: Theme.of(context).textTheme.headlineMedium),
          ...subjectCatalog.values.map((info) {
            final progress = profile.subjectProgress(info.id, content);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(info.name), Text('${(progress * 100).round()}%')],
                  ),
                  LinearProgressIndicator(value: progress, color: info.color),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/profile/avatar'),
                  child: const Text('Tukar Avatar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/profile/parents'),
                  child: const Text('Ibu Bapa'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

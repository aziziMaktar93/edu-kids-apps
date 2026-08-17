import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logic/badges.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/stat_card.dart';

class AwardsScreen extends ConsumerWidget {
  const AwardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pencapaian Kamu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.card_giftcard, size: 48, color: Colors.amber),
                  const Text('Peti Harta Karun'),
                  LinearProgressIndicator(value: profile.chestStars / 100),
                  Text('${profile.chestStars} / 100 Bintang'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: StatCard(label: 'TOTAL BINTANG', value: '${profile.stars}')),
              const SizedBox(width: 12),
              Expanded(child: StatCard(label: 'POIN PINTAR', value: '${profile.smartPoints}')),
            ],
          ),
          const SizedBox(height: 16),
          Text('Lencana Koleksimu', style: Theme.of(context).textTheme.headlineMedium),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: badgeCatalog.map((badge) {
              final unlocked = profile.unlockedBadgeIds.contains(badge.id);
              return Card(
                color: unlocked ? null : Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(unlocked ? badge.icon : Icons.lock, color: unlocked ? Colors.amber : Colors.grey),
                      Text(badge.name, textAlign: TextAlign.center),
                      Text(badge.description, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

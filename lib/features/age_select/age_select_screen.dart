import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/providers.dart';

class AgeSelectScreen extends ConsumerWidget {
  const AgeSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedAgeGroupProvider);
    final options = [
      (AgeGroup.prasekolah, 'Prasekolah', '4 - 6 Tahun', Icons.child_care),
      (AgeGroup.tahapSatu, 'Tahap Satu', '7 - 9 Tahun', Icons.school),
      (AgeGroup.tahapDua, 'Tahap Dua', '10 - 12 Tahun', Icons.psychology),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Umur Kamu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Pilih tahap umur kamu untuk mula belajar dan bermain!'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: options.map((o) {
                  final isSelected = selected == o.$1;
                  return Card(
                    color: isSelected ? Colors.blue.shade50 : null,
                    child: ListTile(
                      leading: Icon(o.$4),
                      title: Text(o.$2),
                      subtitle: Text(o.$3),
                      onTap: () => ref.read(selectedAgeGroupProvider.notifier).state = o.$1,
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: selected == null ? null : () => context.go('/learn'),
              child: const Text('Teruskan'),
            ),
          ],
        ),
      ),
    );
  }
}

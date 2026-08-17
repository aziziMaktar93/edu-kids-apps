import 'package:flutter/material.dart';
import '../../../core/models/activity.dart';

class MultipleChoiceEngine extends StatefulWidget {
  final MultipleChoicePayload payload;
  final ValueChanged<bool> onAnswered;

  const MultipleChoiceEngine({super.key, required this.payload, required this.onAnswered});

  @override
  State<MultipleChoiceEngine> createState() => _MultipleChoiceEngineState();
}

class _MultipleChoiceEngineState extends State<MultipleChoiceEngine> {
  int? _selectedIndex;

  void _select(int index) {
    if (_selectedIndex != null) return;
    setState(() => _selectedIndex = index);
    widget.onAnswered(index == widget.payload.correctIndex);
  }

  @override
  Widget build(BuildContext context) {
    final payload = widget.payload;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(payload.icon, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text(payload.prompt, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: List.generate(payload.options.length, (i) {
            final isSelected = _selectedIndex == i;
            final isCorrect = i == payload.correctIndex;
            Color? bg;
            if (_selectedIndex != null) {
              if (isCorrect) {
                bg = Colors.green.shade400;
              } else if (isSelected) {
                bg = Colors.red.shade300;
              }
            }
            return ElevatedButton(
              onPressed: () => _select(i),
              style: ElevatedButton.styleFrom(backgroundColor: bg),
              child: Text(payload.options[i]),
            );
          }),
        ),
      ],
    );
  }
}

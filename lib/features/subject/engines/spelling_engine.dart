import 'package:flutter/material.dart';
import '../../../core/models/activity.dart';

class SpellingEngine extends StatefulWidget {
  final SpellingPayload payload;
  final ValueChanged<bool> onAnswered;

  const SpellingEngine({super.key, required this.payload, required this.onAnswered});

  @override
  State<SpellingEngine> createState() => _SpellingEngineState();
}

class _SpellingEngineState extends State<SpellingEngine> {
  late List<int?> _blankBankIndex;
  late Set<int> _usedBankIndices;
  bool _submitted = false;
  // Correct/wrong feedback shown briefly on the blanks before the caller
  // advances to the next activity (mirrors MultipleChoiceEngine's green/red
  // button feedback, which this engine and NumericInputEngine previously
  // lacked).
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _blankBankIndex = List<int?>.filled(widget.payload.targetWord.length, null);
    _usedBankIndices = {};
  }

  int get _nextEmptyBlank => _blankBankIndex.indexOf(null);

  void _tapBank(int bankIndex) {
    if (_submitted || _usedBankIndices.contains(bankIndex)) return;
    final slot = _nextEmptyBlank;
    if (slot == -1) return;
    setState(() {
      _blankBankIndex[slot] = bankIndex;
      _usedBankIndices.add(bankIndex);
    });
    if (!_blankBankIndex.contains(null)) {
      _check();
    }
  }

  void _reset() {
    if (_submitted) return;
    setState(() {
      _blankBankIndex = List<int?>.filled(widget.payload.targetWord.length, null);
      _usedBankIndices = {};
    });
  }

  void _check() {
    final letters = widget.payload.letterBank;
    final attempt = _blankBankIndex.map((i) => letters[i!]).join();
    final isCorrect = attempt == widget.payload.targetWord;
    setState(() {
      _submitted = true;
      _isCorrect = isCorrect;
    });
    widget.onAnswered(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    final payload = widget.payload;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(payload.icon, size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(payload.prompt, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: List.generate(_blankBankIndex.length, (slot) {
            final bankIndex = _blankBankIndex[slot];
            final letter = bankIndex == null ? '' : payload.letterBank[bankIndex];
            return Container(
              key: ValueKey('blank_$slot'),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: switch (_isCorrect) { true => Colors.green.shade400, false => Colors.red.shade300, null => null },
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                letter,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: _isCorrect == null ? null : Colors.white),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: List.generate(payload.letterBank.length, (i) {
            final used = _usedBankIndices.contains(i);
            return SizedBox(
              width: 40,
              height: 40,
              child: ElevatedButton(
                key: ValueKey('bank_$i'),
                onPressed: used ? null : () => _tapBank(i),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(payload.letterBank[i]),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        TextButton.icon(onPressed: _reset, icon: const Icon(Icons.refresh), label: const Text('Semula')),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/models/activity.dart';

class NumericInputEngine extends StatefulWidget {
  final NumericInputPayload payload;
  final ValueChanged<bool> onAnswered;

  const NumericInputEngine({super.key, required this.payload, required this.onAnswered});

  @override
  State<NumericInputEngine> createState() => _NumericInputEngineState();
}

class _NumericInputEngineState extends State<NumericInputEngine> {
  String _entered = '';
  bool _submitted = false;

  void _tapDigit(String digit) {
    if (_submitted) return;
    setState(() => _entered += digit);
  }

  void _backspace() {
    if (_submitted || _entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  void _check() {
    if (_submitted || _entered.isEmpty) return;
    setState(() => _submitted = true);
    final value = int.tryParse(_entered);
    widget.onAnswered(value == widget.payload.itemCount);
  }

  @override
  Widget build(BuildContext context) {
    final payload = widget.payload;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(payload.prompt, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          children: List.generate(payload.itemCount, (_) => Icon(payload.itemIcon, size: 24, color: Colors.orange)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
          child: Text(_entered.isEmpty ? '?' : _entered, style: Theme.of(context).textTheme.headlineMedium),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 2.4,
          children: [
            for (final d in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
              ElevatedButton(onPressed: () => _tapDigit(d), child: Text(d)),
            ElevatedButton(onPressed: _backspace, child: const Icon(Icons.backspace)),
            ElevatedButton(onPressed: () => _tapDigit('0'), child: const Text('0')),
            ElevatedButton(onPressed: _check, child: const Icon(Icons.check)),
          ],
        ),
      ],
    );
  }
}

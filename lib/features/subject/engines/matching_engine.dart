import 'package:flutter/material.dart';
import '../../../core/models/activity.dart';

class MatchingEngine extends StatefulWidget {
  final MatchingPayload payload;
  final ValueChanged<bool> onAnswered;

  const MatchingEngine({super.key, required this.payload, required this.onAnswered});

  @override
  State<MatchingEngine> createState() => _MatchingEngineState();
}

class _MatchingEngineState extends State<MatchingEngine> {
  int? _selectedLeft;
  final Set<int> _matched = {};
  bool _completed = false;
  late List<int> _rightOrder;

  @override
  void initState() {
    super.initState();
    _rightOrder = List.generate(widget.payload.pairs.length, (i) => i)..shuffle();
  }

  void _tapLeft(int index) {
    if (_matched.contains(index)) return;
    setState(() => _selectedLeft = index);
  }

  void _tapRight(int index) {
    if (_selectedLeft == null || _matched.contains(index)) return;
    final isMatch = _selectedLeft == index;
    if (isMatch) {
      setState(() {
        _matched.add(index);
        _selectedLeft = null;
      });
      if (_matched.length == widget.payload.pairs.length && !_completed) {
        _completed = true;
        widget.onAnswered(true);
      }
    } else {
      setState(() => _selectedLeft = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pairs = widget.payload.pairs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.payload.prompt, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: List.generate(pairs.length, (i) {
                      final matched = _matched.contains(i);
                      final selected = _selectedLeft == i;
                      return Card(
                        key: ValueKey('left_$i'),
                        color: matched ? Colors.green.shade100 : (selected ? Colors.blue.shade100 : null),
                        child: InkWell(
                          onTap: () => _tapLeft(i),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(pairs[i].left, style: Theme.of(context).textTheme.headlineMedium),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: _rightOrder.map((originalIndex) {
                      final matched = _matched.contains(originalIndex);
                      final pair = pairs[originalIndex];
                      return Card(
                        key: ValueKey('right_$originalIndex'),
                        color: matched ? Colors.green.shade100 : null,
                        child: InkWell(
                          onTap: () => _tapRight(originalIndex),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Icon(pair.rightIcon), const SizedBox(width: 8), Text(pair.rightLabel)],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

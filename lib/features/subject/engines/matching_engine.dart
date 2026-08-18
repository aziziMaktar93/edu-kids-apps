import 'dart:async';
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
  int? _wrongLeft;
  int? _wrongRight;
  final Set<int> _matched = {};
  bool _completed = false;
  late List<int> _rightOrder;
  Timer? _wrongFeedbackTimer;

  @override
  void initState() {
    super.initState();
    _rightOrder = List.generate(widget.payload.pairs.length, (i) => i)..shuffle();
  }

  @override
  void dispose() {
    _wrongFeedbackTimer?.cancel();
    super.dispose();
  }

  void _clearWrongFeedback() {
    _wrongFeedbackTimer?.cancel();
    _wrongFeedbackTimer = null;
    _wrongLeft = null;
    _wrongRight = null;
  }

  void _tapLeft(int index) {
    if (_matched.contains(index)) return;
    setState(() {
      _clearWrongFeedback();
      _selectedLeft = index;
    });
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
      final wrongLeft = _selectedLeft;
      setState(() {
        _wrongLeft = wrongLeft;
        _wrongRight = index;
        _selectedLeft = null;
      });
      _wrongFeedbackTimer?.cancel();
      _wrongFeedbackTimer = Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _wrongLeft = null;
          _wrongRight = null;
        });
      });
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: List.generate(pairs.length, (i) {
                  final matched = _matched.contains(i);
                  final selected = _selectedLeft == i;
                  final wrong = _wrongLeft == i;
                  Color? bg;
                  Color? fg;
                  if (matched) {
                    bg = Colors.green.shade400;
                    fg = Colors.white;
                  } else if (wrong) {
                    bg = Colors.red.shade300;
                    fg = Colors.white;
                  } else if (selected) {
                    bg = Colors.blue.shade100;
                  }
                  return Card(
                    key: ValueKey('left_$i'),
                    color: bg,
                    child: InkWell(
                      onTap: () => _tapLeft(i),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          pairs[i].left,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: fg),
                        ),
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
                  final wrong = _wrongRight == originalIndex;
                  final pair = pairs[originalIndex];
                  Color? bg;
                  Color? fg;
                  if (matched) {
                    bg = Colors.green.shade400;
                    fg = Colors.white;
                  } else if (wrong) {
                    bg = Colors.red.shade300;
                    fg = Colors.white;
                  }
                  return Card(
                    key: ValueKey('right_$originalIndex'),
                    color: bg,
                    child: InkWell(
                      onTap: () => _tapRight(originalIndex),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(pair.rightIcon, color: fg),
                            const SizedBox(width: 8),
                            Text(pair.rightLabel, style: TextStyle(color: fg)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

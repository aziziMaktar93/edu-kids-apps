import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/activity.dart';
import '../../core/models/subject.dart';
import '../../core/providers/providers.dart';
import 'engines/activity_engine_view.dart';
import 'session_result.dart';

class ActivitySessionScreen extends ConsumerStatefulWidget {
  final SubjectId subject;

  const ActivitySessionScreen({super.key, required this.subject});

  @override
  ConsumerState<ActivitySessionScreen> createState() => _ActivitySessionScreenState();
}

class _ActivitySessionScreenState extends ConsumerState<ActivitySessionScreen> {
  int _index = 0;
  int _correct = 0;
  bool _advancing = false;

  void _handleAnswered(Activity activity, List<Activity> activities, bool wasCorrect) {
    if (_advancing) return;
    _advancing = true;
    ref.read(profileProvider.notifier).answerActivity(activity, wasCorrect);
    if (wasCorrect) _correct++;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (_index + 1 < activities.length) {
        setState(() {
          _index++;
          _advancing = false;
        });
      } else {
        context.pushReplacement(
          '/learn/${widget.subject.name}/result',
          extra: SessionResult(subject: widget.subject, correctCount: _correct, totalCount: activities.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = ref.watch(contentProvider);
    final activities = content[widget.subject]!;
    final info = subjectCatalog[widget.subject]!;
    final activity = activities[_index];

    return Scaffold(
      appBar: AppBar(title: Text(info.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tahap 1'),
                  Text('${_index + 1} / ${activities.length}'),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: (_index + 1) / activities.length),
              const SizedBox(height: 24),
              ActivityEngineView(
                key: ValueKey(activity.id),
                activity: activity,
                onAnswered: (correct) => _handleAnswered(activity, activities, correct),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

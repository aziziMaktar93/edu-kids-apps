import '../../core/models/subject.dart';

class SessionResult {
  final SubjectId subject;
  final int correctCount;
  final int totalCount;

  const SessionResult({required this.subject, required this.correctCount, required this.totalCount});
}

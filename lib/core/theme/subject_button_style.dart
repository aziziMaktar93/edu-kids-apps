import 'package:flutter/material.dart';

/// Style for buttons/app-bars painted with a subject's accent color (see
/// `subjectCatalog` in `lib/core/models/subject.dart`) or with a transient
/// correct/wrong feedback color in the quiz engines.
///
/// The theme's default button/app-bar text color is a blue-ish primary that
/// is illegible on several subject accent colors (e.g. purple Jawi, pink
/// English) and on the green/red feedback fills, so callers painting a
/// custom [backgroundColor] must always pair it with an explicit contrasting
/// [foregroundColor] too.
ButtonStyle subjectButtonStyle(Color backgroundColor) {
  return ElevatedButton.styleFrom(backgroundColor: backgroundColor, foregroundColor: Colors.white);
}

/// Same idea as [subjectButtonStyle], but for the brief correct/wrong
/// highlight the quiz engines show on an answer button. `null` means "no
/// feedback yet" and leaves the button's normal theme style untouched.
ButtonStyle answerFeedbackButtonStyle(Color? feedbackColor) {
  return ElevatedButton.styleFrom(
    backgroundColor: feedbackColor,
    foregroundColor: feedbackColor == null ? null : Colors.white,
  );
}

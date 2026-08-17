# EduKids Flutter App — Design

## Overview

EduKids is a bilingual (Bahasa Melayu-first, with English content) multi-subject
learning app for kids aged 4-12. This build implements the full navigation flow
and all screens from the Stitch design export
(`C:\Users\User\Downloads\stitch_smart_kids_multi_subject_academy`) as a working
Flutter app with locally-seeded quiz content — no backend, no auth.

**Reference material:** the Stitch export's `code.html` files (Tailwind markup)
and `screen.png` mockups per screen, plus `kinetic_learning/DESIGN.md` for the
design token source of truth (colors, type scale, spacing, shape, elevation).

## Goals

- Implement all 13 designed screens with working navigation.
- Implement 4 subject learning flows (Math, Science, English, Bahasa Melayu)
  plus Jawi, each backed by real (if small) quiz content.
- Implement the 2 spelling mini-games (Bahasa Melayu, English).
- Implement achievements (treasure chest progress + badges) and profile
  (stats, per-subject progress bars) driven by real local state — actions in
  quizzes actually move these numbers.
- Match the Stitch design system's look (colors, type, shape, elevation)
  using Material 3 theming, substituting icon-based visuals for the
  session-bound photo/mascot URLs in the mockups.

## Out of scope (future phases)

- Backend sync / cloud save, authentication, multi-device profiles.
- Parent PIN-gated dashboard (button present, stubbed to a placeholder).
- Avatar picker (button present, stubbed to a placeholder).
- "Play" tab content — mockups reference it via bottom nav but no screen
  was designed for it; stubbed as a placeholder tab.
- Localization/language toggle — UI chrome stays Bahasa Melayu, matching
  the mockups as designed.
- Sound effects, animations beyond simple Flutter implicit animations.

## Tech stack

- Flutter (stable channel), targeting Android + iOS.
- State management: **Riverpod** (`flutter_riverpod` + `riverpod_annotation`/codegen
  optional — plain providers are fine at this scale).
- Routing: **go_router**, using `StatefulShellRoute.indexedStack` for the
  4-tab bottom nav (Play / Learn / Awards / Profile) so each tab keeps its
  own navigation stack, matching the mockups' persistent bottom nav.
- Local persistence: **Hive** for typed local storage (profile, stars/points,
  badge unlocks, per-subject progress). Chosen over raw `shared_preferences`
  because progress data is nested/structured; chosen over `sqflite` because
  there's no relational querying need.
- Fonts: Plus Jakarta Sans (headlines) + Quicksand (body/labels) via
  `google_fonts` package (avoids bundling font files manually).
- Icons: `Icons`/Material Symbols equivalents already in Flutter's Material
  icon set, standing in for the mockups' `material-symbols-outlined` usage.

## Package/app identity

- App name: **EduKids**
- Package/bundle id: `com.edukids.app`

## Project structure

```
lib/
  main.dart
  app.dart                     # MaterialApp.router + theme wiring
  core/
    theme/                     # ColorScheme, TextTheme built from DESIGN.md tokens
    router/                    # go_router config, shell route
    models/                    # Activity, Subject, Profile, Badge, ProgressState
    storage/                   # Hive boxes + adapters, repository wrappers
  features/
    splash/
    age_select/
    hub/                       # subject hub (Learn tab root)
    subject/
      subject_activity_list_screen.dart
      engines/
        multiple_choice_engine.dart
        numeric_input_engine.dart
        spelling_engine.dart
        matching_engine.dart
      result_screen.dart
    awards/
    profile/
      profile_screen.dart
      avatar_stub_screen.dart
      parents_stub_screen.dart
    play/
      play_placeholder_screen.dart
  content/
    math_activities.dart
    science_activities.dart
    english_vocab_activities.dart
    bahasa_melayu_vocab_activities.dart
    jawi_activities.dart
    bahasa_melayu_spelling_activities.dart
    english_spelling_activities.dart
```

## Data model

```dart
enum SubjectId { math, science, english, bahasaMelayu, jawi }

enum ActivityType { multipleChoice, numericInput, spelling, matching }

// Common envelope; `payload` is one of the type-specific classes below.
class Activity {
  final String id;
  final SubjectId subject;
  final ActivityType type;
  final Object payload;
}

class MultipleChoicePayload {
  final String prompt;          // e.g. "Apakah nama planet ini?"
  final String? imageIcon;      // Material icon name shown in the card
  final List<String> options;   // exactly 4
  final int correctIndex;
}

class NumericInputPayload {
  final String prompt;          // e.g. "Berapa banyak epal yang anda nampak?"
  final int itemCount;          // drives icon-grid render, e.g. 5 apple icons
  final int correctAnswer;
}

class SpellingPayload {
  final String prompt;          // e.g. "Jom eja nama haiwan ini!"
  final String targetWord;      // e.g. "KUCING"
  final String subjectIcon;     // icon standing in for the reference image
  final List<String> letterBank; // target letters + distractors, shuffled
}

class MatchingPayload {
  final String prompt;
  final List<MatchPair> pairs;  // e.g. Jawi letter <-> word label
}

class MatchPair {
  final String left;   // e.g. Jawi glyph
  final String rightLabel; // e.g. "Epal"
  final String rightIcon;  // icon standing in for the reference image
}
```

Each subject's content file exposes `List<Activity> activities` (5-10 items,
mixing activity types where the mockups show mixed mechanics per subject —
e.g. Bahasa Melayu has both vocab multiple-choice and spelling activities).

## State & persistence

- `ProfileState` (Hive-backed, via a `ProfileRepository` + Riverpod
  `NotifierProvider`): child name, avatar id (fixed default for now), total
  stars, "smart points", days learning, unlocked badge ids, per-subject
  progress percentage, treasure chest star count (0-100).
- `ActivitySessionNotifier` (in-memory, per attempt): current activity index,
  current score, current answer state — not persisted, scoped to the quiz
  screen's provider lifetime.
- On completing an activity screen: session results are committed to
  `ProfileRepository` (increments stars, updates subject progress %, checks
  badge-unlock thresholds, updates chest progress), then navigates to a
  shared `ResultScreen`.
- Badges are simple threshold rules evaluated on each commit (e.g. "Math
  Master" unlocks at 100% Math progress, "Champion" unlocks after 10
  completed quizzes total) — defined as plain Dart data, not configurable UI.

## Navigation map

```
/splash
  -> /age-select
/age-select (Prasekolah 4-6 / Tahap Satu 7-9 / Tahap Dua 10-12; selection stored, no gating logic yet)
  -> shell (persistent bottom nav: Play, Learn, Awards, Profile)

shell
  /play            -> placeholder "coming soon"
  /learn           -> subject hub (5 subject cards)
  /learn/:subject  -> activity list / progress for that subject
  /learn/:subject/play/:activityIndex -> quiz engine (routes to the right
                       engine widget based on Activity.type)
  /learn/:subject/result -> result screen (stars earned, correct/total, continue)
  /awards          -> treasure chest + badge grid
  /profile         -> stats, per-subject progress bars
  /profile/avatar  -> stub placeholder
  /profile/parents -> stub placeholder
```

## Theming

`core/theme/` builds a Material 3 `ThemeData` directly from
`kinetic_learning/DESIGN.md`'s token block:
- `ColorScheme` fields mapped 1:1 from the `colors:` YAML (primary
  `#0058bd`, secondary `#7a5900`/container `#fcbc05`, tertiary `#1f6a00`/
  container `#298600`, error `#ba1a1a`, surfaces, etc).
- `TextTheme` built from the `typography:` block (display/headline in Plus
  Jakarta Sans via `google_fonts`, body/label in Quicksand).
- Shape: 16px corner radius for standard cards/buttons, 24px for hero/
  featured containers, matching the `rounded:` tokens.
- Big buttons use the mockups' "3D tactile" bottom-border effect (solid
  color + a `BoxShadow` offset with no blur, using a darker shade) rather
  than a literal CSS `box-shadow` translation.
- Subject cards keep their signature colors: Math = primary blue/orange
  (mockup shows orange for Math, teal for Science, pink/red for English,
  green for Bahasa Melayu, purple for Jawi) — colors taken directly from
  each screen's mockup rather than re-deriving.

## Testing approach

- Widget tests for each of the 4 quiz engines (multiple choice, numeric
  input, spelling, matching): render with sample `Activity` data, simulate
  correct/incorrect answers, assert callback/state transitions.
- Unit tests for `ProfileRepository` badge-unlock and progress-update logic
  (pure functions over `ProfileState`), since that's the app's only real
  business logic.
- No golden-image/pixel tests — visual fidelity is judged manually against
  the `screen.png` mockups during implementation.

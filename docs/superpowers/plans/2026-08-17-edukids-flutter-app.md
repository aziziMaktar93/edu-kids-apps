# EduKids Flutter App Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a working, offline, bilingual (Bahasa Melayu-first) Flutter app called EduKids implementing all 13 screens from the Stitch design export, with 5 subjects (Math, Science, English, Bahasa Melayu, Jawi) driven by 4 reusable quiz engines and real local progress/achievement tracking.

**Architecture:** Feature-first Flutter app. `go_router` `StatefulShellRoute.indexedStack` drives the 4-tab bottom nav (Play/Learn/Awards/Profile). Subject content is plain Dart data (`Activity` objects tagged by `ActivityType`) consumed by 4 reusable engine widgets (multiple choice, numeric input, spelling, matching) — adding a question means editing a data list, not writing new UI. `Riverpod` holds app state; a pure `applyActivityResult` function (no I/O) computes profile/badge updates and is persisted via a `Hive`-backed repository.

**Tech Stack:** Flutter (stable, Android+iOS), `flutter_riverpod`, `go_router`, `hive`/`hive_flutter`, `google_fonts`.

## Global Constraints

- App name: **EduKids**. Package/bundle id: `com.edukids.app`.
- Platforms: Android + iOS only (no web/desktop scaffolding).
- Offline only for this build: no backend, no auth, no network calls except Google Fonts' normal runtime font fetch.
- UI copy stays Bahasa Melayu-first (matching the Stitch mockups), English only where the mockups show English (e.g. English subject content).
- Visuals are Material icons in colored shapes — no photo/mascot assets (the mockups' image URLs are session-bound Google CDN links and cannot be bundled).
- "Play" tab, avatar picker, and "Ibu Bapa" (parents) area are stubbed as a "coming soon" placeholder screen — not implemented for real in this build.
- Design tokens (colors, type, shape) come from `C:\Users\User\Downloads\stitch_smart_kids_multi_subject_academy\kinetic_learning\DESIGN.md`; subject accent colors come from each subject's `screen.png` mockup in that same folder.
- Every task's tests are run with `flutter test`; every task ends with a commit.

---

## Task 1: Project scaffold

**Files:**
- Create: entire Flutter project via `flutter create` (pubspec.yaml, android/, ios/, lib/main.dart, test/widget_test.dart, etc.)
- Modify: `lib/main.dart`, `test/widget_test.dart`

**Interfaces:**
- Produces: a runnable Flutter project at the repo root with `flutter_riverpod`, `go_router`, `hive`, `hive_flutter`, `google_fonts` as dependencies.

- [ ] **Step 1: Create the Flutter project**

Run in the repo root (`C:\laragon\www\edu-kids-apps`):

```bash
flutter create --platforms=android,ios --org com.edukids --project-name edukids .
```

This scaffolds `pubspec.yaml`, `lib/main.dart`, `test/widget_test.dart`, `android/`, `ios/` without touching the existing `docs/` folder or `.git`.

- [ ] **Step 2: Add dependencies**

```bash
flutter pub add flutter_riverpod go_router hive hive_flutter google_fonts
```

- [ ] **Step 3: Replace the default counter app with a minimal placeholder**

Replace `lib/main.dart`:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const EduKidsPlaceholder());
}

class EduKidsPlaceholder extends StatelessWidget {
  const EduKidsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('EduKids')),
      ),
    );
  }
}
```

Replace `test/widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/main.dart';

void main() {
  testWidgets('placeholder shows EduKids', (tester) async {
    await tester.pumpWidget(const EduKidsPlaceholder());
    expect(find.text('EduKids'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Run the test**

Run: `flutter test`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "chore: scaffold EduKids Flutter project"
```

---

## Task 2: Design tokens and theme

**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_theme.dart`
- Test: `test/core/theme/app_theme_test.dart`

**Interfaces:**
- Produces: `AppColors` (static `Color` constants), `ThemeData buildAppTheme()`.

- [ ] **Step 1: Write the failing test**

`test/core/theme/app_theme_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edukids/core/theme/app_colors.dart';
import 'package:edukids/core/theme/app_theme.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('theme exposes the design-token primary color', (tester) async {
    final theme = buildAppTheme();
    await tester.pumpWidget(MaterialApp(
      theme: theme,
      home: Builder(
        builder: (context) => Scaffold(
          body: Text('hi', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
    ));

    final text = tester.widget<Text>(find.text('hi'));
    expect(text.style?.color, AppColors.primary);
    expect(theme.colorScheme.error, AppColors.error);
    expect(theme.useMaterial3, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/theme/app_theme_test.dart`
Expected: FAIL (`app_colors.dart`/`app_theme.dart` not found)

- [ ] **Step 3: Implement**

`lib/core/theme/app_colors.dart`:

```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF0058BD);
  static const primaryContainer = Color(0xFF1470E8);
  static const onPrimaryContainer = Color(0xFFFEFCFF);
  static const secondary = Color(0xFF7A5900);
  static const secondaryContainer = Color(0xFFFCBC05);
  static const onSecondaryContainer = Color(0xFF6B4E00);
  static const tertiary = Color(0xFF1F6A00);
  static const tertiaryContainer = Color(0xFF298600);
  static const error = Color(0xFFBA1A1A);
  static const surface = Color(0xFFF8F9FA);
  static const onSurface = Color(0xFF191C1D);
  static const onSurfaceVariant = Color(0xFF414754);
  static const outline = Color(0xFF727785);

  // Subject accent colors, taken from each subject's screen.png mockup.
  static const subjectMath = Color(0xFFF2994A);
  static const subjectScience = Color(0xFF17B3C7);
  static const subjectEnglish = Color(0xFFE3126F);
  static const subjectBahasaMelayu = Color(0xFF2E9E44);
  static const subjectJawi = Color(0xFF7B2D9E);
}
```

`lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData buildAppTheme() {
  final headlineFont = GoogleFonts.plusJakartaSansTextTheme();
  final bodyFont = GoogleFonts.quicksandTextTheme();

  final textTheme = bodyFont.copyWith(
    displayLarge: headlineFont.displayLarge?.copyWith(fontWeight: FontWeight.w800),
    headlineMedium: headlineFont.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
    titleLarge: headlineFont.titleLarge?.copyWith(fontWeight: FontWeight.w700),
  );

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    error: AppColors.error,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.surface,
    textTheme: textTheme,
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/theme/app_theme_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/core/theme test/core/theme
git commit -m "feat: add design-token theme"
```

---

## Task 3: Domain models — Activity, SubjectId, payloads

**Files:**
- Create: `lib/core/models/subject.dart`
- Create: `lib/core/models/activity.dart`
- Test: `test/core/models/activity_test.dart`

**Interfaces:**
- Consumes: `AppColors` from Task 2.
- Produces: `enum SubjectId { math, science, english, bahasaMelayu, jawi }`, `class SubjectInfo { id, name, tagline, color, icon }`, `final Map<SubjectId, SubjectInfo> subjectCatalog`, `enum ActivityType { multipleChoice, numericInput, spelling, matching }`, `class Activity { id, subject, type, payload }`, `MultipleChoicePayload { prompt, icon, options, correctIndex }`, `NumericInputPayload { prompt, itemIcon, itemCount }`, `SpellingPayload { prompt, icon, targetWord, letterBank }`, `MatchPair { left, rightLabel, rightIcon }`, `MatchingPayload { prompt, pairs }`.

- [ ] **Step 1: Write the failing test**

`test/core/models/activity_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/subject.dart';

void main() {
  test('subjectCatalog has an entry for every SubjectId', () {
    for (final id in SubjectId.values) {
      expect(subjectCatalog.containsKey(id), isTrue, reason: '$id missing from subjectCatalog');
      expect(subjectCatalog[id]!.id, id);
    }
  });

  test('MultipleChoicePayload activity carries its fields', () {
    const payload = MultipleChoicePayload(
      prompt: 'Q?',
      icon: Icons.pets,
      options: ['A', 'B', 'C', 'D'],
      correctIndex: 2,
    );
    final activity = Activity(
      id: 'test_1',
      subject: SubjectId.science,
      type: ActivityType.multipleChoice,
      payload: payload,
    );

    expect(activity.subject, SubjectId.science);
    expect((activity.payload as MultipleChoicePayload).correctIndex, 2);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/models/activity_test.dart`
Expected: FAIL (files not found)

- [ ] **Step 3: Implement**

`lib/core/models/subject.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum SubjectId { math, science, english, bahasaMelayu, jawi }

class SubjectInfo {
  final SubjectId id;
  final String name;
  final String tagline;
  final Color color;
  final IconData icon;

  const SubjectInfo({
    required this.id,
    required this.name,
    required this.tagline,
    required this.color,
    required this.icon,
  });
}

final Map<SubjectId, SubjectInfo> subjectCatalog = {
  SubjectId.math: const SubjectInfo(
    id: SubjectId.math,
    name: 'Matematik',
    tagline: 'Kira dan selesaikan!',
    color: AppColors.subjectMath,
    icon: Icons.calculate,
  ),
  SubjectId.science: const SubjectInfo(
    id: SubjectId.science,
    name: 'Sains',
    tagline: 'Terokai alam semula jadi!',
    color: AppColors.subjectScience,
    icon: Icons.rocket_launch,
  ),
  SubjectId.english: const SubjectInfo(
    id: SubjectId.english,
    name: 'English',
    tagline: 'Learn new words!',
    color: AppColors.subjectEnglish,
    icon: Icons.sort_by_alpha,
  ),
  SubjectId.bahasaMelayu: const SubjectInfo(
    id: SubjectId.bahasaMelayu,
    name: 'Bahasa Melayu',
    tagline: 'Perkaya kosa kata!',
    color: AppColors.subjectBahasaMelayu,
    icon: Icons.local_offer,
  ),
  SubjectId.jawi: const SubjectInfo(
    id: SubjectId.jawi,
    name: 'Jawi',
    tagline: 'Belajar menulis dan membaca Jawi',
    color: AppColors.subjectJawi,
    icon: Icons.translate,
  ),
};
```

`lib/core/models/activity.dart`:

```dart
import 'package:flutter/material.dart';
import 'subject.dart';

enum ActivityType { multipleChoice, numericInput, spelling, matching }

class Activity {
  final String id;
  final SubjectId subject;
  final ActivityType type;
  final Object payload;

  const Activity({
    required this.id,
    required this.subject,
    required this.type,
    required this.payload,
  });
}

class MultipleChoicePayload {
  final String prompt;
  final IconData icon;
  final List<String> options;
  final int correctIndex;

  const MultipleChoicePayload({
    required this.prompt,
    required this.icon,
    required this.options,
    required this.correctIndex,
  });
}

class NumericInputPayload {
  final String prompt;
  final IconData itemIcon;
  final int itemCount;

  const NumericInputPayload({
    required this.prompt,
    required this.itemIcon,
    required this.itemCount,
  });
}

class SpellingPayload {
  final String prompt;
  final IconData icon;
  final String targetWord;
  final List<String> letterBank;

  const SpellingPayload({
    required this.prompt,
    required this.icon,
    required this.targetWord,
    required this.letterBank,
  });
}

class MatchPair {
  final String left;
  final String rightLabel;
  final IconData rightIcon;

  const MatchPair({
    required this.left,
    required this.rightLabel,
    required this.rightIcon,
  });
}

class MatchingPayload {
  final String prompt;
  final List<MatchPair> pairs;

  const MatchingPayload({required this.prompt, required this.pairs});
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/models/activity_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/core/models test/core/models
git commit -m "feat: add Activity/SubjectId domain models"
```

---

## Task 4: Subject content data + validation

**Files:**
- Create: `lib/content/math_activities.dart`
- Create: `lib/content/science_activities.dart`
- Create: `lib/content/english_vocab_activities.dart`
- Create: `lib/content/english_spelling_activities.dart`
- Create: `lib/content/bahasa_melayu_vocab_activities.dart`
- Create: `lib/content/bahasa_melayu_spelling_activities.dart`
- Create: `lib/content/jawi_activities.dart`
- Create: `lib/content/all_content.dart`
- Test: `test/content/content_validation_test.dart`

**Interfaces:**
- Consumes: `Activity`, `ActivityType`, `SubjectId`, payload classes from Task 3.
- Produces: `final Map<SubjectId, List<Activity>> contentBySubject`.

- [ ] **Step 1: Write the failing test**

`test/content/content_validation_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/content/all_content.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/subject.dart';

bool _bankContainsWord(List<String> bank, String word) {
  final available = Map<String, int>.from({});
  for (final letter in bank) {
    available[letter] = (available[letter] ?? 0) + 1;
  }
  for (final letter in word.split('')) {
    final remaining = available[letter] ?? 0;
    if (remaining <= 0) return false;
    available[letter] = remaining - 1;
  }
  return true;
}

void main() {
  test('every subject has at least 5 activities', () {
    for (final id in SubjectId.values) {
      final activities = contentBySubject[id] ?? [];
      expect(activities.length, greaterThanOrEqualTo(5), reason: '$id has too few activities');
    }
  });

  test('activity ids are unique across the whole catalog', () {
    final allIds = contentBySubject.values.expand((list) => list.map((a) => a.id)).toList();
    expect(allIds.toSet().length, allIds.length);
  });

  test('multiple choice activities have 4 options and a valid correctIndex', () {
    final all = contentBySubject.values.expand((l) => l).where((a) => a.type == ActivityType.multipleChoice);
    for (final activity in all) {
      final payload = activity.payload as MultipleChoicePayload;
      expect(payload.options.length, 4, reason: activity.id);
      expect(payload.correctIndex, inInclusiveRange(0, 3), reason: activity.id);
    }
  });

  test('numeric input activities have a positive item count', () {
    final all = contentBySubject.values.expand((l) => l).where((a) => a.type == ActivityType.numericInput);
    for (final activity in all) {
      final payload = activity.payload as NumericInputPayload;
      expect(payload.itemCount, greaterThan(0), reason: activity.id);
    }
  });

  test('spelling activities have a letter bank that can spell the target word', () {
    final all = contentBySubject.values.expand((l) => l).where((a) => a.type == ActivityType.spelling);
    for (final activity in all) {
      final payload = activity.payload as SpellingPayload;
      expect(
        _bankContainsWord(payload.letterBank, payload.targetWord),
        isTrue,
        reason: '${activity.id}: bank ${payload.letterBank} cannot spell ${payload.targetWord}',
      );
    }
  });

  test('matching activities have at least 2 pairs', () {
    final all = contentBySubject.values.expand((l) => l).where((a) => a.type == ActivityType.matching);
    for (final activity in all) {
      final payload = activity.payload as MatchingPayload;
      expect(payload.pairs.length, greaterThanOrEqualTo(2), reason: activity.id);
    }
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/content/content_validation_test.dart`
Expected: FAIL (`all_content.dart` not found)

- [ ] **Step 3: Implement content files**

`lib/content/math_activities.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> mathActivities = [
  const Activity(
    id: 'math_count_stars',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak bintang yang anda nampak?', itemIcon: Icons.star, itemCount: 3),
  ),
  const Activity(
    id: 'math_count_hearts',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak hati yang anda nampak?', itemIcon: Icons.favorite, itemCount: 5),
  ),
  const Activity(
    id: 'math_count_paws',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak tapak kaki yang anda nampak?', itemIcon: Icons.pets, itemCount: 7),
  ),
  const Activity(
    id: 'math_count_flowers',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak bunga yang anda nampak?', itemIcon: Icons.local_florist, itemCount: 4),
  ),
  const Activity(
    id: 'math_count_balls',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak bola yang anda nampak?', itemIcon: Icons.sports_soccer, itemCount: 6),
  ),
  const Activity(
    id: 'math_count_circles',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak bulatan yang anda nampak?', itemIcon: Icons.circle, itemCount: 2),
  ),
  const Activity(
    id: 'math_count_cupcakes',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak kek cawan yang anda nampak?', itemIcon: Icons.cake, itemCount: 8),
  ),
  const Activity(
    id: 'math_count_suns',
    subject: SubjectId.math,
    type: ActivityType.numericInput,
    payload: NumericInputPayload(prompt: 'Berapa banyak matahari yang anda nampak?', itemIcon: Icons.wb_sunny, itemCount: 5),
  ),
];
```

`lib/content/science_activities.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> scienceActivities = [
  const Activity(
    id: 'science_saturn',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Apakah nama planet yang mempunyai cincin?',
      icon: Icons.public,
      options: ['Zuhal', 'Marikh', 'Bumi', 'Musytari'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_sunlight',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Dari manakah tumbuhan mendapat cahaya untuk membesar?',
      icon: Icons.wb_sunny,
      options: ['Matahari', 'Bulan', 'Bintang', 'Awan'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_breathing',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Apakah yang kita hirup untuk bernafas?',
      icon: Icons.air,
      options: ['Oksigen', 'Karbon Dioksida', 'Nitrogen', 'Hidrogen'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_eggs',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Haiwan manakah yang bertelur?',
      icon: Icons.egg,
      options: ['Ayam', 'Kucing', 'Anjing', 'Kambing'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_ice',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Apakah keadaan air apabila ia sejuk beku?',
      icon: Icons.ac_unit,
      options: ['Ais', 'Wap', 'Gas', 'Minyak'],
      correctIndex: 0,
    ),
  ),
  const Activity(
    id: 'science_planets',
    subject: SubjectId.science,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(
      prompt: 'Berapa banyak planet dalam Sistem Suria kita?',
      icon: Icons.public,
      options: ['8', '5', '10', '6'],
      correctIndex: 0,
    ),
  ),
];
```

`lib/content/english_vocab_activities.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> englishVocabActivities = [
  const Activity(
    id: 'english_vocab_lion',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.pets, options: ['Lion', 'Tiger', 'Elephant', 'Monkey'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_elephant',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.pets, options: ['Elephant', 'Giraffe', 'Lion', 'Zebra'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_fish',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.set_meal, options: ['Fish', 'Bird', 'Cat', 'Dog'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_bird',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.egg, options: ['Bird', 'Fish', 'Snake', 'Frog'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_rabbit',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.cruelty_free, options: ['Rabbit', 'Cat', 'Dog', 'Mouse'], correctIndex: 0),
  ),
  const Activity(
    id: 'english_vocab_cow',
    subject: SubjectId.english,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'What animal is this?', icon: Icons.pets, options: ['Cow', 'Horse', 'Sheep', 'Goat'], correctIndex: 0),
  ),
];
```

`lib/content/english_spelling_activities.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> englishSpellingActivities = [
  const Activity(
    id: 'english_spelling_cat',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell this animal's name!", icon: Icons.pets, targetWord: 'CAT', letterBank: ['T', 'C', 'A', 'D', 'O']),
  ),
  const Activity(
    id: 'english_spelling_sun',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell what shines in the sky!", icon: Icons.wb_sunny, targetWord: 'SUN', letterBank: ['N', 'S', 'U', 'O', 'B']),
  ),
  const Activity(
    id: 'english_spelling_dog',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell this animal's name!", icon: Icons.pets, targetWord: 'DOG', letterBank: ['G', 'D', 'O', 'A', 'T']),
  ),
  const Activity(
    id: 'english_spelling_fish',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell this animal's name!", icon: Icons.set_meal, targetWord: 'FISH', letterBank: ['S', 'H', 'F', 'I', 'O', 'T']),
  ),
  const Activity(
    id: 'english_spelling_book',
    subject: SubjectId.english,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: "Let's spell what you read!", icon: Icons.menu_book, targetWord: 'BOOK', letterBank: ['O', 'K', 'B', 'O', 'A', 'T']),
  ),
];
```

`lib/content/bahasa_melayu_vocab_activities.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> bahasaMelayuVocabActivities = [
  const Activity(
    id: 'bm_vocab_kucing',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.pets, options: ['Kucing', 'Anjing', 'Arnab', 'Burung'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_ayam',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.egg, options: ['Ayam', 'Itik', 'Angsa', 'Burung'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_ikan',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.set_meal, options: ['Ikan', 'Udang', 'Ketam', 'Sotong'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_lembu',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.pets, options: ['Lembu', 'Kambing', 'Kuda', 'Kerbau'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_katak',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.pets, options: ['Katak', 'Ular', 'Buaya', 'Kura-kura'], correctIndex: 0),
  ),
  const Activity(
    id: 'bm_vocab_singa',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.multipleChoice,
    payload: MultipleChoicePayload(prompt: 'Apakah nama haiwan ini?', icon: Icons.pets, options: ['Singa', 'Harimau', 'Gajah', 'Monyet'], correctIndex: 0),
  ),
];
```

`lib/content/bahasa_melayu_spelling_activities.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/activity.dart';

final List<Activity> bahasaMelayuSpellingActivities = [
  const Activity(
    id: 'bm_spelling_kucing',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama haiwan ini!', icon: Icons.pets, targetWord: 'KUCING', letterBank: ['C', 'I', 'N', 'G', 'A', 'B', 'K', 'U']),
  ),
  const Activity(
    id: 'bm_spelling_bola',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama benda ini!', icon: Icons.sports_soccer, targetWord: 'BOLA', letterBank: ['L', 'A', 'B', 'O', 'T', 'K']),
  ),
  const Activity(
    id: 'bm_spelling_buku',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama benda ini!', icon: Icons.menu_book, targetWord: 'BUKU', letterBank: ['U', 'K', 'B', 'U', 'A', 'T']),
  ),
  const Activity(
    id: 'bm_spelling_ikan',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama haiwan ini!', icon: Icons.set_meal, targetWord: 'IKAN', letterBank: ['A', 'N', 'I', 'K', 'O', 'S']),
  ),
  const Activity(
    id: 'bm_spelling_rumah',
    subject: SubjectId.bahasaMelayu,
    type: ActivityType.spelling,
    payload: SpellingPayload(prompt: 'Jom eja nama benda ini!', icon: Icons.house, targetWord: 'RUMAH', letterBank: ['M', 'A', 'H', 'R', 'U', 'T', 'B']),
  ),
];
```

`lib/content/jawi_activities.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/activity.dart';

// Letter/word pairings here are for demo purposes (matching-game mechanics
// only, not phonetically accurate Jawi spelling) — have a Bahasa
// Melayu/Jawi curriculum expert review before shipping to real users.
final List<Activity> jawiActivities = [
  const Activity(
    id: 'jawi_match_1',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ا', rightLabel: 'Epal', rightIcon: Icons.circle),
        MatchPair(left: 'ب', rightLabel: 'Bola', rightIcon: Icons.sports_soccer),
        MatchPair(left: 'ت', rightLabel: 'Bakul', rightIcon: Icons.shopping_basket),
      ],
    ),
  ),
  const Activity(
    id: 'jawi_match_2',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ث', rightLabel: 'Ayam', rightIcon: Icons.egg),
        MatchPair(left: 'ج', rightLabel: 'Ikan', rightIcon: Icons.set_meal),
        MatchPair(left: 'ح', rightLabel: 'Kucing', rightIcon: Icons.pets),
      ],
    ),
  ),
  const Activity(
    id: 'jawi_match_3',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'خ', rightLabel: 'Rumah', rightIcon: Icons.house),
        MatchPair(left: 'د', rightLabel: 'Kereta', rightIcon: Icons.directions_car),
        MatchPair(left: 'ذ', rightLabel: 'Buku', rightIcon: Icons.menu_book),
      ],
    ),
  ),
  const Activity(
    id: 'jawi_match_4',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ر', rightLabel: 'Pen', rightIcon: Icons.edit),
        MatchPair(left: 'ز', rightLabel: 'Meja', rightIcon: Icons.table_restaurant),
        MatchPair(left: 'س', rightLabel: 'Kerusi', rightIcon: Icons.chair),
      ],
    ),
  ),
  const Activity(
    id: 'jawi_match_5',
    subject: SubjectId.jawi,
    type: ActivityType.matching,
    payload: MatchingPayload(
      prompt: 'Padankan huruf Jawi dengan gambar yang betul!',
      pairs: [
        MatchPair(left: 'ش', rightLabel: 'Baju', rightIcon: Icons.checkroom),
        MatchPair(left: 'ص', rightLabel: 'Topi', rightIcon: Icons.style),
        MatchPair(left: 'ض', rightLabel: 'Kasut', rightIcon: Icons.directions_walk),
      ],
    ),
  ),
];
```

`lib/content/all_content.dart`:

```dart
import '../core/models/activity.dart';
import '../core/models/subject.dart';
import 'bahasa_melayu_spelling_activities.dart';
import 'bahasa_melayu_vocab_activities.dart';
import 'english_spelling_activities.dart';
import 'english_vocab_activities.dart';
import 'jawi_activities.dart';
import 'math_activities.dart';
import 'science_activities.dart';

final Map<SubjectId, List<Activity>> contentBySubject = {
  SubjectId.math: mathActivities,
  SubjectId.science: scienceActivities,
  SubjectId.english: [...englishVocabActivities, ...englishSpellingActivities],
  SubjectId.bahasaMelayu: [...bahasaMelayuVocabActivities, ...bahasaMelayuSpellingActivities],
  SubjectId.jawi: jawiActivities,
};
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/content/content_validation_test.dart`
Expected: PASS (5 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/content test/content
git commit -m "feat: seed subject content for all 5 subjects"
```

---

## Task 5: Profile state and pure business logic

**Files:**
- Create: `lib/core/models/profile_state.dart`
- Create: `lib/core/logic/badges.dart`
- Create: `lib/core/logic/profile_logic.dart`
- Test: `test/core/logic/profile_logic_test.dart`

**Interfaces:**
- Consumes: `Activity`, `SubjectId` (Task 3), `contentBySubject` (Task 4, test-only).
- Produces: `class ProfileState { childName, stars, smartPoints, daysLearning, chestStars, completedActivityIds, unlockedBadgeIds }` with `ProfileState.initial()`, `copyWith`, `toMap`/`fromMap`, `subjectProgress(SubjectId, Map<SubjectId, List<Activity>>)`, `totalActivitiesCompleted`; `class BadgeDefinition { id, name, description, icon, isUnlocked }`, `final List<BadgeDefinition> badgeCatalog`; `ProfileState applyActivityResult(ProfileState, {required Activity activity, required bool wasCorrect, required Map<SubjectId, List<Activity>> contentBySubject})`.

- [ ] **Step 1: Write the failing test**

`test/core/logic/profile_logic_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/logic/profile_logic.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/profile_state.dart';
import 'package:edukids/core/models/subject.dart';
import 'package:flutter/material.dart';

const _mathActivity1 = Activity(
  id: 'm1',
  subject: SubjectId.math,
  type: ActivityType.numericInput,
  payload: NumericInputPayload(prompt: 'p', itemIcon: Icons.star, itemCount: 1),
);
const _mathActivity2 = Activity(
  id: 'm2',
  subject: SubjectId.math,
  type: ActivityType.numericInput,
  payload: NumericInputPayload(prompt: 'p', itemIcon: Icons.star, itemCount: 2),
);

final _content = {
  SubjectId.math: [_mathActivity1, _mathActivity2],
  SubjectId.science: <Activity>[],
  SubjectId.english: <Activity>[],
  SubjectId.bahasaMelayu: <Activity>[],
  SubjectId.jawi: <Activity>[],
};

void main() {
  test('an incorrect answer does not change state', () {
    final start = ProfileState.initial();
    final result = applyActivityResult(start, activity: _mathActivity1, wasCorrect: false, contentBySubject: _content);
    expect(result.stars, start.stars);
    expect(result.completedActivityIds, start.completedActivityIds);
  });

  test('a correct answer adds a star, smart points, and marks the activity complete', () {
    final start = ProfileState.initial();
    final result = applyActivityResult(start, activity: _mathActivity1, wasCorrect: true, contentBySubject: _content);
    expect(result.stars, start.stars + 1);
    expect(result.smartPoints, start.smartPoints + 5);
    expect(result.completedActivityIds, contains('m1'));
  });

  test('subjectProgress reflects fraction of that subject completed', () {
    var state = ProfileState.initial();
    state = applyActivityResult(state, activity: _mathActivity1, wasCorrect: true, contentBySubject: _content);
    expect(state.subjectProgress(SubjectId.math, _content), 0.5);

    state = applyActivityResult(state, activity: _mathActivity2, wasCorrect: true, contentBySubject: _content);
    expect(state.subjectProgress(SubjectId.math, _content), 1.0);
  });

  test('Math Master badge unlocks once all math activities are completed', () {
    var state = ProfileState.initial();
    state = applyActivityResult(state, activity: _mathActivity1, wasCorrect: true, contentBySubject: _content);
    expect(state.unlockedBadgeIds, isNot(contains('math_master')));

    state = applyActivityResult(state, activity: _mathActivity2, wasCorrect: true, contentBySubject: _content);
    expect(state.unlockedBadgeIds, contains('math_master'));
  });

  test('Champion badge unlocks after 10 distinct completed activities', () {
    var state = ProfileState.initial();
    for (var i = 0; i < 10; i++) {
      final activity = Activity(
        id: 'extra_$i',
        subject: SubjectId.math,
        type: ActivityType.numericInput,
        payload: const NumericInputPayload(prompt: 'p', itemIcon: Icons.star, itemCount: 1),
      );
      state = applyActivityResult(state, activity: activity, wasCorrect: true, contentBySubject: _content);
    }
    expect(state.unlockedBadgeIds, contains('champion'));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/logic/profile_logic_test.dart`
Expected: FAIL (files not found)

- [ ] **Step 3: Implement**

`lib/core/models/profile_state.dart`:

```dart
import 'activity.dart';
import 'subject.dart';

class ProfileState {
  final String childName;
  final int stars;
  final int smartPoints;
  final int daysLearning;
  final int chestStars;
  final Set<String> completedActivityIds;
  final Set<String> unlockedBadgeIds;

  const ProfileState({
    required this.childName,
    required this.stars,
    required this.smartPoints,
    required this.daysLearning,
    required this.chestStars,
    required this.completedActivityIds,
    required this.unlockedBadgeIds,
  });

  factory ProfileState.initial() => const ProfileState(
        childName: 'Adli',
        stars: 0,
        smartPoints: 0,
        daysLearning: 1,
        chestStars: 0,
        completedActivityIds: {},
        unlockedBadgeIds: {},
      );

  double subjectProgress(SubjectId subject, Map<SubjectId, List<Activity>> contentBySubject) {
    final activities = contentBySubject[subject] ?? const [];
    if (activities.isEmpty) return 0;
    final completed = activities.where((a) => completedActivityIds.contains(a.id)).length;
    return completed / activities.length;
  }

  int get totalActivitiesCompleted => completedActivityIds.length;

  ProfileState copyWith({
    String? childName,
    int? stars,
    int? smartPoints,
    int? daysLearning,
    int? chestStars,
    Set<String>? completedActivityIds,
    Set<String>? unlockedBadgeIds,
  }) {
    return ProfileState(
      childName: childName ?? this.childName,
      stars: stars ?? this.stars,
      smartPoints: smartPoints ?? this.smartPoints,
      daysLearning: daysLearning ?? this.daysLearning,
      chestStars: chestStars ?? this.chestStars,
      completedActivityIds: completedActivityIds ?? this.completedActivityIds,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
    );
  }

  Map<String, dynamic> toMap() => {
        'childName': childName,
        'stars': stars,
        'smartPoints': smartPoints,
        'daysLearning': daysLearning,
        'chestStars': chestStars,
        'completedActivityIds': completedActivityIds.toList(),
        'unlockedBadgeIds': unlockedBadgeIds.toList(),
      };

  factory ProfileState.fromMap(Map<dynamic, dynamic> map) => ProfileState(
        childName: map['childName'] as String,
        stars: map['stars'] as int,
        smartPoints: map['smartPoints'] as int,
        daysLearning: map['daysLearning'] as int,
        chestStars: map['chestStars'] as int,
        completedActivityIds: Set<String>.from(map['completedActivityIds'] as List),
        unlockedBadgeIds: Set<String>.from(map['unlockedBadgeIds'] as List),
      );
}
```

`lib/core/logic/badges.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/profile_state.dart';
import '../models/subject.dart';

class BadgeDefinition {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final bool Function(ProfileState state, Map<SubjectId, List<Activity>> contentBySubject) isUnlocked;

  const BadgeDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}

final List<BadgeDefinition> badgeCatalog = [
  BadgeDefinition(
    id: 'math_master',
    name: 'Math Master',
    description: 'Jago Matematik',
    icon: Icons.calculate,
    isUnlocked: (state, content) => state.subjectProgress(SubjectId.math, content) >= 1.0,
  ),
  BadgeDefinition(
    id: 'science_hero',
    name: 'Science Hero',
    description: 'Ahli Sains',
    icon: Icons.science,
    isUnlocked: (state, content) => state.subjectProgress(SubjectId.science, content) >= 1.0,
  ),
  BadgeDefinition(
    id: 'spelling_master',
    name: 'Spelling Master',
    description: 'Pakar Mengeja',
    icon: Icons.spellcheck,
    isUnlocked: (state, content) =>
        state.subjectProgress(SubjectId.bahasaMelayu, content) >= 1.0 &&
        state.subjectProgress(SubjectId.english, content) >= 1.0,
  ),
  BadgeDefinition(
    id: 'champion',
    name: 'Champion',
    description: 'Selesai 10 Kuiz',
    icon: Icons.emoji_events,
    isUnlocked: (state, content) => state.totalActivitiesCompleted >= 10,
  ),
];
```

`lib/core/logic/profile_logic.dart`:

```dart
import '../models/activity.dart';
import '../models/profile_state.dart';
import '../models/subject.dart';
import 'badges.dart';

ProfileState applyActivityResult(
  ProfileState state, {
  required Activity activity,
  required bool wasCorrect,
  required Map<SubjectId, List<Activity>> contentBySubject,
}) {
  if (!wasCorrect) return state;

  final updated = state.copyWith(
    stars: state.stars + 1,
    smartPoints: state.smartPoints + 5,
    chestStars: (state.chestStars + 1).clamp(0, 100),
    completedActivityIds: {...state.completedActivityIds, activity.id},
  );

  final newlyUnlocked = badgeCatalog
      .where((b) => !updated.unlockedBadgeIds.contains(b.id))
      .where((b) => b.isUnlocked(updated, contentBySubject))
      .map((b) => b.id);

  return updated.copyWith(unlockedBadgeIds: {...updated.unlockedBadgeIds, ...newlyUnlocked});
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/logic/profile_logic_test.dart`
Expected: PASS (5 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/core/models/profile_state.dart lib/core/logic test/core/logic
git commit -m "feat: add profile state and pure progress/badge logic"
```

---

## Task 6: Hive-backed profile repository

**Files:**
- Create: `lib/core/storage/profile_repository.dart`
- Test: `test/core/storage/profile_repository_test.dart`

**Interfaces:**
- Consumes: `ProfileState` (Task 5).
- Produces: `class ProfileRepository { Future<void> init(), ProfileState load(), Future<void> save(ProfileState) }`.

- [ ] **Step 1: Write the failing test**

`test/core/storage/profile_repository_test.dart`:

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/profile_state.dart';
import 'package:edukids/core/storage/profile_repository.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_hive_test_');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('load() returns ProfileState.initial() when nothing was saved yet', () async {
    final repo = ProfileRepository();
    await repo.init();
    final loaded = repo.load();
    expect(loaded.childName, ProfileState.initial().childName);
    expect(loaded.stars, 0);
  });

  test('save() then load() round-trips the profile state', () async {
    final repo = ProfileRepository();
    await repo.init();

    final state = ProfileState.initial().copyWith(
      stars: 42,
      smartPoints: 100,
      completedActivityIds: {'a', 'b'},
      unlockedBadgeIds: {'math_master'},
    );
    await repo.save(state);

    final reloaded = repo.load();
    expect(reloaded.stars, 42);
    expect(reloaded.smartPoints, 100);
    expect(reloaded.completedActivityIds, {'a', 'b'});
    expect(reloaded.unlockedBadgeIds, {'math_master'});
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/storage/profile_repository_test.dart`
Expected: FAIL (`profile_repository.dart` not found)

- [ ] **Step 3: Implement**

`lib/core/storage/profile_repository.dart`:

```dart
import 'package:hive/hive.dart';
import '../models/profile_state.dart';

class ProfileRepository {
  static const _boxName = 'profile_box';
  static const _key = 'profile';

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  ProfileState load() {
    final raw = _box.get(_key);
    if (raw == null) return ProfileState.initial();
    return ProfileState.fromMap(raw as Map);
  }

  Future<void> save(ProfileState state) => _box.put(_key, state.toMap());
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/storage/profile_repository_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/core/storage test/core/storage
git commit -m "feat: add Hive-backed profile repository"
```

---

## Task 7: Riverpod providers

**Files:**
- Create: `lib/core/providers/providers.dart`
- Test: `test/core/providers/providers_test.dart`

**Interfaces:**
- Consumes: `ProfileRepository` (Task 6), `ProfileState`/`applyActivityResult` (Task 5), `contentBySubject` (Task 4), `Activity` (Task 3).
- Produces: `final profileRepositoryProvider = Provider<ProfileRepository>(...)`, `final contentProvider = Provider<Map<SubjectId, List<Activity>>>(...)`, `final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(...)` with `ProfileNotifier.answerActivity(Activity, bool)`, `enum AgeGroup { prasekolah, tahapSatu, tahapDua }`, `final selectedAgeGroupProvider = StateProvider<AgeGroup?>(...)`.

- [ ] **Step 1: Write the failing test**

`test/core/providers/providers_test.dart`:

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/subject.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/content/all_content.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_providers_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('profileProvider loads the initial state from the repository', () {
    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    expect(container.read(profileProvider).stars, 0);
  });

  test('answerActivity updates profile state and persists it', () {
    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    final activity = contentBySubject[SubjectId.math]!.first;
    container.read(profileProvider.notifier).answerActivity(activity, true);

    expect(container.read(profileProvider).stars, 1);
    expect(repository.load().stars, 1);
  });

  test('contentProvider exposes the seeded content catalog', () {
    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    expect(container.read(contentProvider), contentBySubject);
  });

  test('selectedAgeGroupProvider defaults to null and can be set', () {
    final container = ProviderContainer(overrides: [
      profileRepositoryProvider.overrideWithValue(repository),
    ]);
    addTearDown(container.dispose);

    expect(container.read(selectedAgeGroupProvider), isNull);
    container.read(selectedAgeGroupProvider.notifier).state = AgeGroup.tahapSatu;
    expect(container.read(selectedAgeGroupProvider), AgeGroup.tahapSatu);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/providers/providers_test.dart`
Expected: FAIL (`providers.dart` not found)

- [ ] **Step 3: Implement**

`lib/core/providers/providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/profile_logic.dart';
import '../models/activity.dart';
import '../models/profile_state.dart';
import '../models/subject.dart';
import '../storage/profile_repository.dart';
import '../../content/all_content.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  throw UnimplementedError('Override profileRepositoryProvider in main() after ProfileRepository.init()');
});

final contentProvider = Provider<Map<SubjectId, List<Activity>>>((ref) => contentBySubject);

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => ref.read(profileRepositoryProvider).load();

  void answerActivity(Activity activity, bool wasCorrect) {
    final content = ref.read(contentProvider);
    final updated = applyActivityResult(
      state,
      activity: activity,
      wasCorrect: wasCorrect,
      contentBySubject: content,
    );
    state = updated;
    ref.read(profileRepositoryProvider).save(updated);
  }
}

enum AgeGroup { prasekolah, tahapSatu, tahapDua }

final selectedAgeGroupProvider = StateProvider<AgeGroup?>((ref) => null);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/providers/providers_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/core/providers test/core/providers
git commit -m "feat: add Riverpod providers for profile and content"
```

---

## Task 8: Shared widgets — StatCard and ComingSoonScreen

**Files:**
- Create: `lib/core/widgets/stat_card.dart`
- Create: `lib/core/widgets/coming_soon_screen.dart`
- Test: `test/core/widgets/stat_card_test.dart`
- Test: `test/core/widgets/coming_soon_screen_test.dart`

**Interfaces:**
- Produces: `class StatCard extends StatelessWidget { label, value }`, `class ComingSoonScreen extends StatelessWidget { title }`.

- [ ] **Step 1: Write the failing tests**

`test/core/widgets/stat_card_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/widgets/stat_card.dart';

void main() {
  testWidgets('StatCard shows its label and value', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: StatCard(label: 'BINTANG', value: '1,250')),
    ));
    expect(find.text('BINTANG'), findsOneWidget);
    expect(find.text('1,250'), findsOneWidget);
  });
}
```

`test/core/widgets/coming_soon_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/widgets/coming_soon_screen.dart';

void main() {
  testWidgets('ComingSoonScreen shows the given title in the app bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ComingSoonScreen(title: 'Tukar Avatar')));
    expect(find.widgetWithText(AppBar, 'Tukar Avatar'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/core/widgets/`
Expected: FAIL (files not found)

- [ ] **Step 3: Implement**

`lib/core/widgets/stat_card.dart`:

```dart
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
```

`lib/core/widgets/coming_soon_screen.dart`:

```dart
import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;

  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Akan datang tidak lama lagi!'),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/core/widgets/`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets test/core/widgets
git commit -m "feat: add shared StatCard and ComingSoonScreen widgets"
```

---

## Task 9: Multiple choice quiz engine

**Files:**
- Create: `lib/features/subject/engines/multiple_choice_engine.dart`
- Test: `test/features/subject/engines/multiple_choice_engine_test.dart`

**Interfaces:**
- Consumes: `MultipleChoicePayload` (Task 3).
- Produces: `class MultipleChoiceEngine extends StatefulWidget { payload, onAnswered }` where `onAnswered` is `ValueChanged<bool>`.

- [ ] **Step 1: Write the failing test**

`test/features/subject/engines/multiple_choice_engine_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/multiple_choice_engine.dart';

void main() {
  const payload = MultipleChoicePayload(
    prompt: 'Apakah nama planet ini?',
    icon: Icons.public,
    options: ['Bumi', 'Marikh', 'Zuhal', 'Musytari'],
    correctIndex: 2,
  );

  testWidgets('tapping the correct option calls onAnswered(true)', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MultipleChoiceEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.text('Zuhal'));
    await tester.pump();

    expect(result, isTrue);
  });

  testWidgets('tapping a wrong option calls onAnswered(false)', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MultipleChoiceEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.text('Bumi'));
    await tester.pump();

    expect(result, isFalse);
  });

  testWidgets('a second tap after answering does not call onAnswered again', (tester) async {
    var callCount = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MultipleChoiceEngine(payload: payload, onAnswered: (_) => callCount++)),
    ));

    await tester.tap(find.text('Zuhal'));
    await tester.pump();
    await tester.tap(find.text('Bumi'));
    await tester.pump();

    expect(callCount, 1);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subject/engines/multiple_choice_engine_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/subject/engines/multiple_choice_engine.dart`:

```dart
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/subject/engines/multiple_choice_engine_test.dart`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/features/subject/engines/multiple_choice_engine.dart test/features/subject/engines/multiple_choice_engine_test.dart
git commit -m "feat: add multiple choice quiz engine"
```

---

## Task 10: Numeric input quiz engine

**Files:**
- Create: `lib/features/subject/engines/numeric_input_engine.dart`
- Test: `test/features/subject/engines/numeric_input_engine_test.dart`

**Interfaces:**
- Consumes: `NumericInputPayload` (Task 3).
- Produces: `class NumericInputEngine extends StatefulWidget { payload, onAnswered }`.

- [ ] **Step 1: Write the failing test**

`test/features/subject/engines/numeric_input_engine_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/numeric_input_engine.dart';

void main() {
  const payload = NumericInputPayload(prompt: 'Berapa banyak epal?', itemIcon: Icons.circle, itemCount: 3);

  testWidgets('entering the correct count and checking calls onAnswered(true)', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: NumericInputEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.widgetWithText(ElevatedButton, '3'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(result, isTrue);
  });

  testWidgets('entering the wrong count and checking calls onAnswered(false)', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: NumericInputEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.widgetWithText(ElevatedButton, '5'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(result, isFalse);
  });

  testWidgets('backspace removes the last entered digit', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: NumericInputEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    await tester.tap(find.widgetWithText(ElevatedButton, '5'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, '3'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(result, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subject/engines/numeric_input_engine_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/subject/engines/numeric_input_engine.dart`:

```dart
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
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: List.generate(payload.itemCount, (_) => Icon(payload.itemIcon, size: 32, color: Colors.orange)),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
          child: Text(_entered.isEmpty ? '?' : _entered, style: Theme.of(context).textTheme.headlineMedium),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/subject/engines/numeric_input_engine_test.dart`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/features/subject/engines/numeric_input_engine.dart test/features/subject/engines/numeric_input_engine_test.dart
git commit -m "feat: add numeric input quiz engine"
```

---

## Task 11: Spelling quiz engine

**Files:**
- Create: `lib/features/subject/engines/spelling_engine.dart`
- Test: `test/features/subject/engines/spelling_engine_test.dart`

**Interfaces:**
- Consumes: `SpellingPayload` (Task 3).
- Produces: `class SpellingEngine extends StatefulWidget { payload, onAnswered }`. Bank buttons keyed `ValueKey('bank_$i')`; blanks keyed `ValueKey('blank_$i')`.

- [ ] **Step 1: Write the failing test**

`test/features/subject/engines/spelling_engine_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/spelling_engine.dart';

void main() {
  testWidgets('spelling the target word correctly calls onAnswered(true)', (tester) async {
    bool? result;
    const payload = SpellingPayload(prompt: 'Eja!', icon: Icons.pets, targetWord: 'CAT', letterBank: ['T', 'C', 'A']);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SpellingEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    // bank_1 = 'C', bank_2 = 'A', bank_0 = 'T' -> spells CAT
    await tester.tap(find.byKey(const ValueKey('bank_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_2')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_0')));
    await tester.pump();

    expect(result, isTrue);
  });

  testWidgets('spelling the wrong word calls onAnswered(false)', (tester) async {
    bool? result;
    const payload = SpellingPayload(prompt: 'Eja!', icon: Icons.pets, targetWord: 'CAT', letterBank: ['T', 'C', 'A']);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SpellingEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    // bank_0 = 'T', bank_1 = 'C', bank_2 = 'A' -> spells TCA
    await tester.tap(find.byKey(const ValueKey('bank_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_2')));
    await tester.pump();

    expect(result, isFalse);
  });

  testWidgets('handles duplicate letters correctly (BUKU)', (tester) async {
    bool? result;
    const payload = SpellingPayload(
      prompt: 'Eja!',
      icon: Icons.menu_book,
      targetWord: 'BUKU',
      letterBank: ['U', 'K', 'B', 'U', 'A', 'T'],
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SpellingEngine(payload: payload, onAnswered: (v) => result = v)),
    ));

    // bank_2='B', bank_0='U', bank_1='K', bank_3='U' -> spells BUKU
    await tester.tap(find.byKey(const ValueKey('bank_2')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('bank_3')));
    await tester.pump();

    expect(result, isTrue);
  });

  testWidgets('reset clears the blanks and re-enables the bank', (tester) async {
    const payload = SpellingPayload(prompt: 'Eja!', icon: Icons.pets, targetWord: 'CAT', letterBank: ['T', 'C', 'A']);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SpellingEngine(payload: payload, onAnswered: (_) {})),
    ));

    await tester.tap(find.byKey(const ValueKey('bank_1')));
    await tester.pump();
    await tester.tap(find.text('Semula'));
    await tester.pump();

    final bankButton = tester.widget<ElevatedButton>(find.byKey(const ValueKey('bank_1')));
    expect(bankButton.onPressed, isNotNull);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subject/engines/spelling_engine_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/subject/engines/spelling_engine.dart`:

```dart
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
    _submitted = true;
    widget.onAnswered(attempt == widget.payload.targetWord);
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
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
              child: Text(letter, style: Theme.of(context).textTheme.titleLarge),
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
              key: ValueKey('bank_$i'),
              width: 40,
              height: 40,
              child: ElevatedButton(
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
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/subject/engines/spelling_engine_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/features/subject/engines/spelling_engine.dart test/features/subject/engines/spelling_engine_test.dart
git commit -m "feat: add spelling quiz engine"
```

---

## Task 12: Matching quiz engine

**Files:**
- Create: `lib/features/subject/engines/matching_engine.dart`
- Test: `test/features/subject/engines/matching_engine_test.dart`

**Interfaces:**
- Consumes: `MatchingPayload`, `MatchPair` (Task 3).
- Produces: `class MatchingEngine extends StatefulWidget { payload, onAnswered }`. Left items keyed `ValueKey('left_$i')`, right items keyed `ValueKey('right_$i')` where `$i` is the pair's original index (display order for the right column is shuffled, but keys stay tied to original index).

- [ ] **Step 1: Write the failing test**

`test/features/subject/engines/matching_engine_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/matching_engine.dart';

void main() {
  const payload = MatchingPayload(
    prompt: 'Padankan!',
    pairs: [
      MatchPair(left: 'A', rightLabel: 'Apple', rightIcon: Icons.circle),
      MatchPair(left: 'B', rightLabel: 'Ball', rightIcon: Icons.sports_soccer),
    ],
  );

  testWidgets('matching all pairs correctly calls onAnswered(true) exactly once', (tester) async {
    var callCount = 0;
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MatchingEngine(
          payload: payload,
          onAnswered: (v) {
            callCount++;
            result = v;
          },
        ),
      ),
    ));

    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('left_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_1')));
    await tester.pump();

    expect(callCount, 1);
    expect(result, isTrue);
  });

  testWidgets('a wrong attempt does not call onAnswered and can be retried', (tester) async {
    var callCount = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MatchingEngine(payload: payload, onAnswered: (_) => callCount++)),
    ));

    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_1'))); // wrong
    await tester.pump();

    expect(callCount, 0);

    // Retry correctly.
    await tester.tap(find.byKey(const ValueKey('left_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('left_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('right_1')));
    await tester.pump();

    expect(callCount, 1);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subject/engines/matching_engine_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/subject/engines/matching_engine.dart`:

```dart
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
        Row(
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
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/subject/engines/matching_engine_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/features/subject/engines/matching_engine.dart test/features/subject/engines/matching_engine_test.dart
git commit -m "feat: add matching quiz engine"
```

---

## Task 13: Activity engine dispatcher

**Files:**
- Create: `lib/features/subject/engines/activity_engine_view.dart`
- Test: `test/features/subject/engines/activity_engine_view_test.dart`

**Interfaces:**
- Consumes: `Activity`, `ActivityType` (Task 3), all 4 engines (Tasks 9-12).
- Produces: `class ActivityEngineView extends StatelessWidget { activity, onAnswered }` — renders the engine matching `activity.type`.

- [ ] **Step 1: Write the failing test**

`test/features/subject/engines/activity_engine_view_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/features/subject/engines/activity_engine_view.dart';
import 'package:edukids/features/subject/engines/multiple_choice_engine.dart';
import 'package:edukids/features/subject/engines/numeric_input_engine.dart';
import 'package:edukids/features/subject/engines/spelling_engine.dart';
import 'package:edukids/features/subject/engines/matching_engine.dart';

void main() {
  Future<void> pumpFor(WidgetTester tester, Activity activity) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ActivityEngineView(activity: activity, onAnswered: (_) {})),
    ));
  }

  testWidgets('renders MultipleChoiceEngine for multipleChoice activities', (tester) async {
    const activity = Activity(
      id: 'a',
      subject: SubjectId.science,
      type: ActivityType.multipleChoice,
      payload: MultipleChoicePayload(prompt: 'p', icon: Icons.pets, options: ['1', '2', '3', '4'], correctIndex: 0),
    );
    await pumpFor(tester, activity);
    expect(find.byType(MultipleChoiceEngine), findsOneWidget);
  });

  testWidgets('renders NumericInputEngine for numericInput activities', (tester) async {
    const activity = Activity(
      id: 'a',
      subject: SubjectId.math,
      type: ActivityType.numericInput,
      payload: NumericInputPayload(prompt: 'p', itemIcon: Icons.star, itemCount: 3),
    );
    await pumpFor(tester, activity);
    expect(find.byType(NumericInputEngine), findsOneWidget);
  });

  testWidgets('renders SpellingEngine for spelling activities', (tester) async {
    const activity = Activity(
      id: 'a',
      subject: SubjectId.english,
      type: ActivityType.spelling,
      payload: SpellingPayload(prompt: 'p', icon: Icons.pets, targetWord: 'CAT', letterBank: ['C', 'A', 'T']),
    );
    await pumpFor(tester, activity);
    expect(find.byType(SpellingEngine), findsOneWidget);
  });

  testWidgets('renders MatchingEngine for matching activities', (tester) async {
    const activity = Activity(
      id: 'a',
      subject: SubjectId.jawi,
      type: ActivityType.matching,
      payload: MatchingPayload(pairs: [
        MatchPair(left: 'a', rightLabel: 'b', rightIcon: Icons.circle),
        MatchPair(left: 'c', rightLabel: 'd', rightIcon: Icons.circle),
      ], prompt: 'p'),
    );
    await pumpFor(tester, activity);
    expect(find.byType(MatchingEngine), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subject/engines/activity_engine_view_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/subject/engines/activity_engine_view.dart`:

```dart
import 'package:flutter/material.dart';
import '../../../core/models/activity.dart';
import 'matching_engine.dart';
import 'multiple_choice_engine.dart';
import 'numeric_input_engine.dart';
import 'spelling_engine.dart';

class ActivityEngineView extends StatelessWidget {
  final Activity activity;
  final ValueChanged<bool> onAnswered;

  const ActivityEngineView({super.key, required this.activity, required this.onAnswered});

  @override
  Widget build(BuildContext context) {
    switch (activity.type) {
      case ActivityType.multipleChoice:
        return MultipleChoiceEngine(payload: activity.payload as MultipleChoicePayload, onAnswered: onAnswered);
      case ActivityType.numericInput:
        return NumericInputEngine(payload: activity.payload as NumericInputPayload, onAnswered: onAnswered);
      case ActivityType.spelling:
        return SpellingEngine(payload: activity.payload as SpellingPayload, onAnswered: onAnswered);
      case ActivityType.matching:
        return MatchingEngine(payload: activity.payload as MatchingPayload, onAnswered: onAnswered);
    }
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/subject/engines/activity_engine_view_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/features/subject/engines/activity_engine_view.dart test/features/subject/engines/activity_engine_view_test.dart
git commit -m "feat: add activity engine dispatcher"
```

---

## Task 14: Activity session screen + result screen

**Files:**
- Create: `lib/features/subject/session_result.dart`
- Create: `lib/features/subject/activity_session_screen.dart`
- Create: `lib/features/subject/result_screen.dart`
- Test: `test/features/subject/activity_session_screen_test.dart`

**Interfaces:**
- Consumes: `contentProvider`, `profileProvider` (Task 7), `subjectCatalog` (Task 3), `ActivityEngineView` (Task 13).
- Produces: `class SessionResult { subject, correctCount, totalCount }`, `class ActivitySessionScreen extends ConsumerStatefulWidget { subject }` (routes to `/learn/:subjectId/result` via `context.pushReplacement` with a `SessionResult` as `extra` after the last activity), `class ResultScreen extends StatelessWidget { result }`.

- [ ] **Step 1: Write the failing test**

`test/features/subject/activity_session_screen_test.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/subject.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/subject/activity_session_screen.dart';
import 'package:edukids/features/subject/result_screen.dart';
import 'package:edukids/features/subject/session_result.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  const testActivities = [
    Activity(
      id: 't1',
      subject: SubjectId.math,
      type: ActivityType.numericInput,
      payload: NumericInputPayload(prompt: 'Berapa?', itemIcon: Icons.star, itemCount: 2),
    ),
    Activity(
      id: 't2',
      subject: SubjectId.math,
      type: ActivityType.numericInput,
      payload: NumericInputPayload(prompt: 'Berapa?', itemIcon: Icons.star, itemCount: 1),
    ),
  ];

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_session_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('completing all activities in a session navigates to the result screen', (tester) async {
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const ActivitySessionScreen(subject: SubjectId.math)),
      GoRoute(
        path: '/result',
        builder: (context, state) => ResultScreen(result: state.extra as SessionResult),
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        contentProvider.overrideWithValue({
          SubjectId.math: testActivities,
          SubjectId.science: const [],
          SubjectId.english: const [],
          SubjectId.bahasaMelayu: const [],
          SubjectId.jawi: const [],
        }),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));

    // Answer question 1 (itemCount 2) correctly.
    await tester.tap(find.widgetWithText(ElevatedButton, '2'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump(const Duration(milliseconds: 600));

    // Answer question 2 (itemCount 1) correctly.
    await tester.tap(find.widgetWithText(ElevatedButton, '1'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.text('2 / 2 betul'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subject/activity_session_screen_test.dart`
Expected: FAIL (files not found)

- [ ] **Step 3: Implement**

`lib/features/subject/session_result.dart`:

```dart
import '../../core/models/subject.dart';

class SessionResult {
  final SubjectId subject;
  final int correctCount;
  final int totalCount;

  const SessionResult({required this.subject, required this.correctCount, required this.totalCount});
}
```

`lib/features/subject/activity_session_screen.dart`:

```dart
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
      body: Padding(
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
            Expanded(
              child: ActivityEngineView(
                key: ValueKey(activity.id),
                activity: activity,
                onAnswered: (correct) => _handleAnswered(activity, activities, correct),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

`lib/features/subject/result_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/subject.dart';
import 'session_result.dart';

class ResultScreen extends StatelessWidget {
  final SessionResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final info = subjectCatalog[result.subject]!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 96, color: info.color),
            const SizedBox(height: 16),
            Text('Syabas!', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 8),
            Text('${result.correctCount} / ${result.totalCount} betul', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/learn/${result.subject.name}'),
              child: const Text('Teruskan'),
            ),
          ],
        ),
      ),
    );
  }
}
```

Note: for the test to control content, `contentProvider` must be overridable. Confirm it is declared as `Provider<Map<SubjectId, List<Activity>>>` (already the case from Task 7) — Riverpod `Provider`s support `overrideWithValue` out of the box, no code change needed.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/subject/activity_session_screen_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/features/subject/session_result.dart lib/features/subject/activity_session_screen.dart lib/features/subject/result_screen.dart test/features/subject/activity_session_screen_test.dart
git commit -m "feat: add activity session screen and result screen"
```

---

## Task 15: Subject activity list screen

**Files:**
- Create: `lib/features/subject/subject_activity_list_screen.dart`
- Test: `test/features/subject/subject_activity_list_screen_test.dart`

**Interfaces:**
- Consumes: `contentProvider`, `profileProvider` (Task 7), `subjectCatalog` (Task 3).
- Produces: `class SubjectActivityListScreen extends ConsumerWidget { subject }` — shows progress and a "Mula" button that calls `context.push('/learn/${subject.name}/session')`.

- [ ] **Step 1: Write the failing test**

`test/features/subject/subject_activity_list_screen_test.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/models/subject.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/subject/subject_activity_list_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_list_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows the subject name, progress, and a Mula button that navigates to the session route', (tester) async {
    String? pushedRoute;
    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SubjectActivityListScreen(subject: SubjectId.math),
      ),
      GoRoute(
        path: '/learn/math/session',
        builder: (context, state) {
          pushedRoute = state.uri.toString();
          return const Scaffold(body: Text('session screen'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    ));

    expect(find.text('Matematik'), findsWidgets);
    expect(find.text('Mula'), findsOneWidget);

    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();

    expect(pushedRoute, '/learn/math/session');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/subject/subject_activity_list_screen_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/subject/subject_activity_list_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/subject.dart';
import '../../core/providers/providers.dart';

class SubjectActivityListScreen extends ConsumerWidget {
  final SubjectId subject;

  const SubjectActivityListScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = subjectCatalog[subject]!;
    final activities = ref.watch(contentProvider)[subject]!;
    final profile = ref.watch(profileProvider);
    final completedCount = activities.where((a) => profile.completedActivityIds.contains(a.id)).length;

    return Scaffold(
      appBar: AppBar(title: Text(info.name), backgroundColor: info.color),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(info.tagline, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: activities.isEmpty ? 0 : completedCount / activities.length),
                Text('$completedCount / ${activities.length} selesai'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, i) {
                final done = profile.completedActivityIds.contains(activities[i].id);
                return ListTile(
                  leading: Icon(done ? Icons.check_circle : Icons.radio_button_unchecked, color: done ? Colors.green : Colors.grey),
                  title: Text('Soalan ${i + 1}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => context.push('/learn/${subject.name}/session'),
              style: ElevatedButton.styleFrom(backgroundColor: info.color),
              child: const Text('Mula'),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/subject/subject_activity_list_screen_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/features/subject/subject_activity_list_screen.dart test/features/subject/subject_activity_list_screen_test.dart
git commit -m "feat: add subject activity list screen"
```

---

## Task 16: Hub screen (Learn tab root)

**Files:**
- Create: `lib/features/hub/hub_screen.dart`
- Test: `test/features/hub/hub_screen_test.dart`

**Interfaces:**
- Consumes: `profileProvider` (Task 7), `subjectCatalog` (Task 3).
- Produces: `class HubScreen extends ConsumerWidget` — a grid of 5 subject cards, each navigating to `/learn/<subjectId>` on tap.

- [ ] **Step 1: Write the failing test**

`test/features/hub/hub_screen_test.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/hub/hub_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_hub_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows all 5 subject cards and navigates on tap', (tester) async {
    String? pushedRoute;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const HubScreen()),
      GoRoute(
        path: '/learn/math',
        builder: (context, state) {
          pushedRoute = state.uri.toString();
          return const Scaffold(body: Text('math screen'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    ));

    for (final name in ['Matematik', 'Sains', 'English', 'Bahasa Melayu', 'Jawi']) {
      expect(find.text(name), findsOneWidget);
    }

    await tester.tap(find.text('Matematik'));
    await tester.pumpAndSettle();

    expect(pushedRoute, '/learn/math');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/hub/hub_screen_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/hub/hub_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/subject.dart';
import '../../core/providers/providers.dart';

class HubScreen extends ConsumerWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduKids'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(avatar: const Icon(Icons.star, color: Colors.amber), label: Text('${profile.stars}')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jom Belajar!', style: Theme.of(context).textTheme.headlineMedium),
            const Text('Choose a subject to start playing and learning.'),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: subjectCatalog.values.map((info) {
                  return Material(
                    color: info.color,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.push('/learn/${info.id.name}'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(info.icon, size: 40, color: Colors.white),
                            const SizedBox(height: 12),
                            Text(info.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/hub/hub_screen_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/features/hub test/features/hub
git commit -m "feat: add subject hub screen"
```

---

## Task 17: Awards screen

**Files:**
- Create: `lib/features/awards/awards_screen.dart`
- Test: `test/features/awards/awards_screen_test.dart`

**Interfaces:**
- Consumes: `profileProvider` (Task 7), `badgeCatalog` (Task 5), `StatCard` (Task 8).
- Produces: `class AwardsScreen extends ConsumerWidget`.

- [ ] **Step 1: Write the failing test**

`test/features/awards/awards_screen_test.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/awards/awards_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_awards_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows chest progress, stats, and the full badge catalog', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: AwardsScreen()),
    ));

    expect(find.text('Peti Harta Karun'), findsOneWidget);
    expect(find.text('0 / 100 Bintang'), findsOneWidget);
    expect(find.text('Math Master'), findsOneWidget);
    expect(find.text('Champion'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsWidgets); // all locked initially
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/awards/awards_screen_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/awards/awards_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logic/badges.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/stat_card.dart';

class AwardsScreen extends ConsumerWidget {
  const AwardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pencapaian Kamu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.card_giftcard, size: 48, color: Colors.amber),
                  const Text('Peti Harta Karun'),
                  LinearProgressIndicator(value: profile.chestStars / 100),
                  Text('${profile.chestStars} / 100 Bintang'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: StatCard(label: 'TOTAL BINTANG', value: '${profile.stars}')),
              const SizedBox(width: 12),
              Expanded(child: StatCard(label: 'POIN PINTAR', value: '${profile.smartPoints}')),
            ],
          ),
          const SizedBox(height: 16),
          Text('Lencana Koleksimu', style: Theme.of(context).textTheme.headlineMedium),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: badgeCatalog.map((badge) {
              final unlocked = profile.unlockedBadgeIds.contains(badge.id);
              return Card(
                color: unlocked ? null : Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(unlocked ? badge.icon : Icons.lock, color: unlocked ? Colors.amber : Colors.grey),
                      Text(badge.name, textAlign: TextAlign.center),
                      Text(badge.description, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/awards/awards_screen_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/features/awards test/features/awards
git commit -m "feat: add awards screen"
```

---

## Task 18: Profile screen

**Files:**
- Create: `lib/features/profile/profile_screen.dart`
- Test: `test/features/profile/profile_screen_test.dart`

**Interfaces:**
- Consumes: `profileProvider`, `contentProvider` (Task 7), `subjectCatalog` (Task 3), `StatCard` (Task 8).
- Produces: `class ProfileScreen extends ConsumerWidget` with "Tukar Avatar" (`push('/profile/avatar')`) and "Ibu Bapa" (`push('/profile/parents')`) buttons.

- [ ] **Step 1: Write the failing test**

`test/features/profile/profile_screen_test.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';
import 'package:edukids/features/profile/profile_screen.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_profile_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('shows child name, stats, subject progress bars, and stub buttons', (tester) async {
    String? pushedRoute;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const ProfileScreen()),
      GoRoute(
        path: '/profile/avatar',
        builder: (context, state) {
          pushedRoute = state.uri.toString();
          return const Scaffold(body: Text('avatar screen'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: router),
    ));

    expect(find.text('Adli'), findsOneWidget);
    expect(find.text('Kemajuan Saya'), findsOneWidget);
    expect(find.text('Matematik'), findsOneWidget);
    expect(find.text('Tukar Avatar'), findsOneWidget);
    expect(find.text('Ibu Bapa'), findsOneWidget);

    await tester.tap(find.text('Tukar Avatar'));
    await tester.pumpAndSettle();

    expect(pushedRoute, '/profile/avatar');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/profile/profile_screen_test.dart`
Expected: FAIL (file not found)

- [ ] **Step 3: Implement**

`lib/features/profile/profile_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/subject.dart';
import '../../core/providers/providers.dart';
import '../../core/widgets/stat_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final content = ref.watch(contentProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(radius: 48, child: Icon(Icons.face, size: 48)),
                const SizedBox(height: 8),
                Text(profile.childName, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatCard(label: 'BINTANG', value: '${profile.stars}')),
              const SizedBox(width: 8),
              Expanded(child: StatCard(label: 'HARI BELAJAR', value: '${profile.daysLearning}')),
              const SizedBox(width: 8),
              Expanded(child: StatCard(label: 'LENCANA', value: '${profile.unlockedBadgeIds.length}')),
            ],
          ),
          const SizedBox(height: 16),
          Text('Kemajuan Saya', style: Theme.of(context).textTheme.headlineMedium),
          ...subjectCatalog.values.map((info) {
            final progress = profile.subjectProgress(info.id, content);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(info.name), Text('${(progress * 100).round()}%')],
                  ),
                  LinearProgressIndicator(value: progress, color: info.color),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/profile/avatar'),
                  child: const Text('Tukar Avatar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/profile/parents'),
                  child: const Text('Ibu Bapa'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/profile/profile_screen_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/features/profile test/features/profile
git commit -m "feat: add profile screen"
```

---

## Task 19: Splash and age select screens

**Files:**
- Create: `lib/features/splash/splash_screen.dart`
- Create: `lib/features/age_select/age_select_screen.dart`
- Test: `test/features/splash/splash_screen_test.dart`
- Test: `test/features/age_select/age_select_screen_test.dart`

**Interfaces:**
- Consumes: `selectedAgeGroupProvider`, `AgeGroup` (Task 7).
- Produces: `class SplashScreen extends StatelessWidget` (navigates via `context.go('/age-select')`), `class AgeSelectScreen extends ConsumerWidget` (navigates via `context.go('/learn')` once an age is selected).

- [ ] **Step 1: Write the failing tests**

`test/features/splash/splash_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:edukids/features/splash/splash_screen.dart';

void main() {
  testWidgets('tapping Mula navigates to /age-select', (tester) async {
    String? location;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/age-select',
        builder: (context, state) {
          location = state.uri.toString();
          return const Scaffold(body: Text('age select'));
        },
      ),
    ]);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    expect(find.text('EduKids'), findsOneWidget);

    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();

    expect(location, '/age-select');
  });
}
```

`test/features/age_select/age_select_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:edukids/features/age_select/age_select_screen.dart';

void main() {
  testWidgets('Teruskan is disabled until an age group is picked, then navigates to /learn', (tester) async {
    String? location;
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (context, state) => const AgeSelectScreen()),
      GoRoute(
        path: '/learn',
        builder: (context, state) {
          location = state.uri.toString();
          return const Scaffold(body: Text('learn'));
        },
      ),
    ]);

    await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));

    final continueButton = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Teruskan'));
    expect(continueButton.onPressed, isNull);

    await tester.tap(find.text('Tahap Satu'));
    await tester.pump();
    await tester.tap(find.text('Teruskan'));
    await tester.pumpAndSettle();

    expect(location, '/learn');
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/splash/ test/features/age_select/`
Expected: FAIL (files not found)

- [ ] **Step 3: Implement**

`lib/features/splash/splash_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'EduKids',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            const Text("Let's learn and play!"),
            const SizedBox(height: 48),
            const Icon(Icons.child_care, size: 120, color: Colors.blue),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () => context.go('/age-select'),
                child: const Text('Mula'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

`lib/features/age_select/age_select_screen.dart`:

```dart
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
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/splash/ test/features/age_select/`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
git add lib/features/splash lib/features/age_select test/features/splash test/features/age_select
git commit -m "feat: add splash and age select screens"
```

---

## Task 20: Router and app shell

**Files:**
- Create: `lib/core/router/app_shell.dart`
- Create: `lib/core/router/app_router.dart`
- Test: `test/core/router/app_router_test.dart`

**Interfaces:**
- Consumes: every screen from Tasks 14-19, `ComingSoonScreen` (Task 8), `SubjectId`, `SessionResult`.
- Produces: `final GoRouter appRouter`, `class AppShell extends StatelessWidget { navigationShell }`.

- [ ] **Step 1: Write the failing test**

`test/core/router/app_router_test.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/router/app_router.dart';
import 'package:edukids/core/storage/profile_repository.dart';

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('edukids_router_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('app starts at the splash screen and can reach the Learn tab with bottom nav visible', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(routerConfig: appRouter),
    ));

    expect(find.text('EduKids'), findsOneWidget);
    expect(find.text('Mula'), findsOneWidget);

    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih Umur Kamu'), findsOneWidget);

    await tester.tap(find.text('Tahap Satu'));
    await tester.pump();
    await tester.tap(find.text('Teruskan'));
    await tester.pumpAndSettle();

    expect(find.text('Jom Belajar!'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: FAIL (files not found)

- [ ] **Step 3: Implement**

`lib/core/router/app_shell.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports_esports), label: 'Play'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Learn'),
          NavigationDestination(icon: Icon(Icons.military_tech), label: 'Awards'),
          NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }
}
```

`lib/core/router/app_router.dart`:

```dart
import 'package:go_router/go_router.dart';
import '../models/subject.dart';
import '../widgets/coming_soon_screen.dart';
import 'app_shell.dart';
import '../../features/age_select/age_select_screen.dart';
import '../../features/awards/awards_screen.dart';
import '../../features/hub/hub_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/subject/activity_session_screen.dart';
import '../../features/subject/result_screen.dart';
import '../../features/subject/session_result.dart';
import '../../features/subject/subject_activity_list_screen.dart';

SubjectId _subjectFromParam(String param) => SubjectId.values.firstWhere((s) => s.name == param);

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/age-select', builder: (context, state) => const AgeSelectScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/play', builder: (context, state) => const ComingSoonScreen(title: 'Play')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/learn',
            builder: (context, state) => const HubScreen(),
            routes: [
              GoRoute(
                path: ':subjectId',
                builder: (context, state) =>
                    SubjectActivityListScreen(subject: _subjectFromParam(state.pathParameters['subjectId']!)),
                routes: [
                  GoRoute(
                    path: 'session',
                    builder: (context, state) =>
                        ActivitySessionScreen(subject: _subjectFromParam(state.pathParameters['subjectId']!)),
                  ),
                  GoRoute(
                    path: 'result',
                    builder: (context, state) => ResultScreen(result: state.extra as SessionResult),
                  ),
                ],
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/awards', builder: (context, state) => const AwardsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(path: 'avatar', builder: (context, state) => const ComingSoonScreen(title: 'Tukar Avatar')),
              GoRoute(path: 'parents', builder: (context, state) => const ComingSoonScreen(title: 'Ibu Bapa')),
            ],
          ),
        ]),
      ],
    ),
  ],
);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/router/app_router_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
git add lib/core/router test/core/router
git commit -m "feat: wire up go_router with bottom nav shell"
```

---

## Task 21: Final app wiring and end-to-end smoke test

**Files:**
- Modify: `lib/main.dart`
- Create: `lib/app.dart`
- Modify: `test/widget_test.dart`
- Test: `test/app_smoke_test.dart`

**Interfaces:**
- Consumes: `appRouter` (Task 20), `buildAppTheme` (Task 2), `ProfileRepository` (Task 6), `profileRepositoryProvider` (Task 7).
- Produces: `class EduKidsApp extends StatelessWidget`, a working `main()` that initializes Hive and runs the app.

- [ ] **Step 1: Write the failing end-to-end test**

`test/app_smoke_test.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:edukids/app.dart';
import 'package:edukids/content/all_content.dart';
import 'package:edukids/core/models/activity.dart';
import 'package:edukids/core/models/subject.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';

Future<void> _answerNumericInput(WidgetTester tester, int itemCount) async {
  await tester.tap(find.widgetWithText(ElevatedButton, '$itemCount'));
  await tester.pump();
  await tester.tap(find.byIcon(Icons.check));
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  late Directory tempDir;
  late ProfileRepository repository;

  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tempDir = await Directory.systemTemp.createTemp('edukids_smoke_test_');
    Hive.init(tempDir.path);
    repository = ProfileRepository();
    await repository.init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('full journey: splash -> age select -> hub -> math quiz -> result -> awards -> profile', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: const EduKidsApp(),
    ));

    // Splash -> age select.
    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();

    // Age select -> hub.
    await tester.tap(find.text('Tahap Satu'));
    await tester.pump();
    await tester.tap(find.text('Teruskan'));
    await tester.pumpAndSettle();
    expect(find.text('Jom Belajar!'), findsOneWidget);

    // Hub -> Math activity list -> session.
    await tester.tap(find.text('Matematik'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();

    // Answer every math activity correctly.
    final mathActivities = contentBySubject[SubjectId.math]!;
    for (final activity in mathActivities) {
      final payload = activity.payload as NumericInputPayload;
      await _answerNumericInput(tester, payload.itemCount);
    }
    await tester.pumpAndSettle();

    expect(find.text('${mathActivities.length} / ${mathActivities.length} betul'), findsOneWidget);

    // Result -> back to Math list -> Learn tab -> Awards tab.
    await tester.tap(find.text('Teruskan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Awards'));
    await tester.pumpAndSettle();
    expect(find.text('Math Master'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsWidgets); // other badges still locked

    // Profile tab shows 100% math progress.
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('100%'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/app_smoke_test.dart`
Expected: FAIL (`app.dart` not found / `main.dart` still the placeholder)

- [ ] **Step 3: Implement**

`lib/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class EduKidsApp extends StatelessWidget {
  const EduKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EduKids',
      theme: buildAppTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

`lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/providers/providers.dart';
import 'core/storage/profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final repository = ProfileRepository();
  await repository.init();

  runApp(
    ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: const EduKidsApp(),
    ),
  );
}
```

Replace `test/widget_test.dart` (the Task 1 placeholder test no longer applies since `EduKidsPlaceholder` is gone):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:edukids/app.dart';
import 'package:edukids/core/providers/providers.dart';
import 'package:edukids/core/storage/profile_repository.dart';

void main() {
  testWidgets('EduKidsApp boots to the splash screen', (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final tempDir = await Directory.systemTemp.createTemp('edukids_widget_test_');
    Hive.init(tempDir.path);
    final repository = ProfileRepository();
    await repository.init();

    await tester.pumpWidget(ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      child: const EduKidsApp(),
    ));

    expect(find.text('EduKids'), findsOneWidget);
    expect(find.text('Mula'), findsOneWidget);

    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });
}
```

- [ ] **Step 4: Run all tests to verify everything passes**

Run: `flutter test`
Expected: PASS (all tests across every task)

Also run: `flutter analyze` and resolve any warnings before proceeding.

- [ ] **Step 5: Commit**

```bash
git add lib/app.dart lib/main.dart test/widget_test.dart test/app_smoke_test.dart
git commit -m "feat: wire up EduKidsApp end-to-end and add smoke test"
```

---

## Post-plan manual check

`flutter test` covers logic and navigation, but per project conventions, before calling this done: run `flutter run` on an Android emulator (or `-d chrome` if no emulator is available) and manually click through the same journey as the Task 21 smoke test, comparing each screen against its corresponding `screen.png` in `C:\Users\User\Downloads\stitch_smart_kids_multi_subject_academy` for visual fidelity (colors, spacing, button style). Note any visual gaps for a follow-up polish pass — this plan intentionally prioritizes working navigation and real state over pixel-perfect styling.

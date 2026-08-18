import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/subject.dart';
import '../providers/providers.dart';
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

const _entryPointLocations = {'/splash', '/age-select'};

final appRouter = GoRouter(
  initialLocation: '/splash',
  // A child who already picked an age group on a previous launch shouldn't
  // have to redo splash + age-select every single cold start (that screen
  // pair only exists to capture the choice once). `context` here is a
  // descendant of the ProviderScope that wraps MaterialApp.router, so it can
  // read the persisted profile directly without appRouter itself needing to
  // be built from a provider.
  redirect: (context, state) {
    if (!_entryPointLocations.contains(state.matchedLocation)) return null;
    final profile = ProviderScope.containerOf(context, listen: false).read(profileProvider);
    if (profile.ageGroup != null) return '/learn';
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/age-select', builder: (context, state) => const AgeSelectScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/play', builder: (context, state) => const ComingSoonScreen(title: 'Main')),
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

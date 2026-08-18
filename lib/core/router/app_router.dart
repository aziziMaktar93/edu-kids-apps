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

import 'package:quran_app/core/constants/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/features/bookmark/presentation/pages/bookmark_page.dart';
import 'package:quran_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:quran_app/features/dashboard/presentation/pages/started_page.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/pages/jadwal_sholat_page.dart';
import 'package:quran_app/features/surah/presentation/pages/home_page.dart';

/// Routes for the onboarding screen.
List<RouteBase> get onboardingRoutes => [
      GoRoute(
        path: RouteNames.started,
        builder: (context, state) => const StartedPage(),
      ),
    ];

/// Routes for the dashboard shell (bottom navigation tabs).
///
/// Contains a [ShellRoute] wrapping the 3 dashboard tabs:
/// `/home`, `/bookmark`, `/jadwal-sholat`.
List<RouteBase> get dashboardRoutes => [
      ShellRoute(
        builder: (context, state, child) => DashboardPage(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: RouteNames.bookmark,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BookmarkPage(),
            ),
          ),
          GoRoute(
            path: RouteNames.jadwalSholat,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: JadwalSholatPage(),
            ),
          ),
        ],
      ),
    ];

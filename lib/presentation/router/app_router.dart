import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/components/navigator_key.dart';
import 'package:quran_app/data/datasources/local_storage_service.dart';
import 'package:quran_app/presentation/view/dashboard/bookmark_page.dart';
import 'package:quran_app/presentation/view/dashboard/dashboard_page.dart';
import 'package:quran_app/presentation/view/dashboard/home_page.dart';
import 'package:quran_app/presentation/view/detail_surah/detail_surah_page.dart';
import 'package:quran_app/presentation/view/jadwal_sholat/jadwal_sholat_page.dart';
import 'package:quran_app/presentation/view/serach_page/search_page.dart';
import 'package:quran_app/presentation/view/started_page.dart';

/// Configures the application's [GoRouter] with:
/// - An onboarding redirect guard ([_guardRedirect])
/// - A [ShellRoute] for the 3 bottom-nav dashboard tabs
/// - Stand-alone routes for detail surah and search
class AppRouter {
  final LocalStorageService storageService;

  AppRouter({required this.storageService});

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    redirect: _guardRedirect,
    routes: [
      GoRoute(
        path: '/started',
        builder: (context, state) => const StartedPage(),
      ),
      ShellRoute(
        // Task 3.2 will wire `child` into DashboardPage's body.
        // For now, DashboardPage accepts but ignores the child param.
        builder: (context, state, child) => DashboardPage(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/bookmark',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BookmarkPage(),
            ),
          ),
          GoRoute(
            path: '/jadwal-sholat',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: JadwalSholatPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/detail-surah/:nomor',
        builder: (context, state) {
          final nomor = int.parse(state.pathParameters['nomor']!);
          final indexTandai = state.uri.queryParameters['ayat'] != null
              ? int.parse(state.uri.queryParameters['ayat']!)
              : null;
          return DetailSurahPage(nomor: nomor, indexTandai: indexTandai);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => SearchPage(),
      ),
    ],
  );

  /// Redirects unauthenticated/onboarded users to the correct screen.
  ///
  /// - `cacheStarted == false` → always redirect to `/started` (onboarding)
  /// - `cacheStarted == true` on `/started` → redirect to `/home`
  /// - Otherwise → no redirect (return null)
  String? _guardRedirect(BuildContext context, GoRouterState state) {
    return evaluateRedirect(state.matchedLocation);
  }

  /// Pure redirect logic extracted for testability.
  ///
  /// - `cacheStarted == false` and not on `/started` → returns `/started`
  /// - `cacheStarted == true` and on `/started` → returns `/home`
  /// - Otherwise → returns `null` (no redirect)
  @visibleForTesting
  String? evaluateRedirect(String matchedLocation) {
    final bool hasOnboarded = storageService.getBool(
      key: 'cacheStarted',
      defaultValue: false,
    );
    final bool isOnStartedPage = matchedLocation == '/started';

    if (!hasOnboarded && !isOnStartedPage) return '/started';
    if (hasOnboarded && isOnStartedPage) return '/home';
    return null;
  }
}

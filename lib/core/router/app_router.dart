import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/navigator_key.dart';
import 'package:quran_app/core/constants/cache_keys.dart';
import 'package:quran_app/core/constants/route_names.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/features/dashboard/presentation/router/dashboard_routes.dart';
import 'package:quran_app/features/detail_surah/presentation/router/detail_surah_routes.dart';
import 'package:quran_app/features/search/presentation/router/search_routes.dart';

/// Configures the application's [GoRouter] with:
/// - An onboarding redirect guard ([_guardRedirect])
/// - A [ShellRoute] for the 3 bottom-nav dashboard tabs
/// - Stand-alone routes for detail surah and search
class AppRouter {
  final LocalStorageService storageService;

  AppRouter({required this.storageService});

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteNames.home,
    redirect: _guardRedirect,
    routes: [
      ...onboardingRoutes,
      ...dashboardRoutes,
      ...detailSurahRoutes,
      ...searchRoutes,
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
      key: CacheKeys.started,
      defaultValue: false,
    );
    final bool isOnStartedPage = matchedLocation == RouteNames.started;

    if (!hasOnboarded && !isOnStartedPage) return RouteNames.started;
    if (hasOnboarded && isOnStartedPage) return RouteNames.home;
    return null;
  }
}

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/presentation/router/app_router.dart';

import '../../mocks.dart';

void main() {
  late MockLocalStorageService mockStorageService;
  late AppRouter appRouter;

  setUp(() {
    mockStorageService = MockLocalStorageService();
    appRouter = AppRouter(storageService: mockStorageService);
  });

  group('AppRouter.evaluateRedirect — onboarding guard', () {
    test(
      'redirects to /started when cacheStarted is false and not on /started',
      () {
        when(
          () => mockStorageService.getBool(
            key: 'cacheStarted',
            defaultValue: false,
          ),
        ).thenReturn(false);

        expect(appRouter.evaluateRedirect('/home'), '/started');
      },
    );

    test(
      'redirects to /started when cacheStarted is false and on another route',
      () {
        when(
          () => mockStorageService.getBool(
            key: 'cacheStarted',
            defaultValue: false,
          ),
        ).thenReturn(false);

        expect(appRouter.evaluateRedirect('/bookmark'), '/started');
      },
    );

    test(
      'no redirect when cacheStarted is false and already on /started',
      () {
        when(
          () => mockStorageService.getBool(
            key: 'cacheStarted',
            defaultValue: false,
          ),
        ).thenReturn(false);

        expect(appRouter.evaluateRedirect('/started'), isNull);
      },
    );

    test(
      'redirects to /home when cacheStarted is true and on /started',
      () {
        when(
          () => mockStorageService.getBool(
            key: 'cacheStarted',
            defaultValue: false,
          ),
        ).thenReturn(true);

        expect(appRouter.evaluateRedirect('/started'), '/home');
      },
    );

    test(
      'no redirect when cacheStarted is true and not on /started',
      () {
        when(
          () => mockStorageService.getBool(
            key: 'cacheStarted',
            defaultValue: false,
          ),
        ).thenReturn(true);

        expect(appRouter.evaluateRedirect('/home'), isNull);
      },
    );

    test(
      'no redirect when cacheStarted is true and on a non-started route',
      () {
        when(
          () => mockStorageService.getBool(
            key: 'cacheStarted',
            defaultValue: false,
          ),
        ).thenReturn(true);

        expect(appRouter.evaluateRedirect('/detail-surah/1'), isNull);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Property 2: Router Redirect Consistency
  //
  // For ANY cacheStarted state (true/false) and ANY matched location, the
  // redirect guard must:
  //   1. Always direct to the correct destination.
  //   2. Never produce a redirect that equals the current location
  //      (i.e. never cause an infinite redirect loop).
  //   3. Never return a destination other than null, '/started', or '/home'.
  // Validates: Requirements 2.3, 2.4, 2.10
  // ---------------------------------------------------------------------------
  group('Property 2: Router redirect consistency (100 iterations)', () {
    // Sampling of app route paths to drive the property test.
    const List<String> appRoutes = [
      '/home',
      '/bookmark',
      '/jadwal-sholat',
      '/search',
      '/detail-surah/1',
      '/detail-surah/114',
      '/detail-surah/7',
      '/started',
    ];

    /// Returns true when [redirect] cannot lead back to the same [location]
    /// immediately (i.e. no cycle of length 1).
    bool noImmediateLoop(String location, String? redirect) {
      return redirect != location;
    }

    test(
      'cacheStarted=false: always redirects to /started (except when already on /started)',
      () {
        when(
          () => mockStorageService.getBool(
            key: 'cacheStarted',
            defaultValue: false,
          ),
        ).thenReturn(false);

        for (int i = 0; i < 100; i++) {
          final location = appRoutes[i % appRoutes.length];
          final redirect = appRouter.evaluateRedirect(location);

          if (location == '/started') {
            // Already on /started → no redirect needed (null stops the loop).
            expect(
              redirect,
              isNull,
              reason:
                  'cacheStarted=false on /started should return null to avoid loop',
            );
          } else {
            // Every other route must redirect to /started.
            expect(
              redirect,
              '/started',
              reason:
                  'cacheStarted=false on $location should redirect to /started',
            );
          }

          // Universal invariant: redirect destination ≠ current location.
          expect(
            noImmediateLoop(location, redirect),
            isTrue,
            reason:
                'Redirect $redirect equals current location $location — infinite loop',
          );
        }
      },
    );

    test(
      'cacheStarted=true: redirects to /home only when on /started, no redirect otherwise',
      () {
        when(
          () => mockStorageService.getBool(
            key: 'cacheStarted',
            defaultValue: false,
          ),
        ).thenReturn(true);

        for (int i = 0; i < 100; i++) {
          final location = appRoutes[i % appRoutes.length];
          final redirect = appRouter.evaluateRedirect(location);

          if (location == '/started') {
            // Onboarding complete → kick user to /home.
            expect(
              redirect,
              '/home',
              reason: 'cacheStarted=true on /started should redirect to /home',
            );
          } else {
            // All other routes: no redirect.
            expect(
              redirect,
              isNull,
              reason: 'cacheStarted=true on $location should not redirect',
            );
          }

          // Universal invariant: redirect destination ≠ current location.
          expect(
            noImmediateLoop(location, redirect),
            isTrue,
            reason:
                'Redirect $redirect equals current location $location — infinite loop',
          );
        }
      },
    );

    test(
      'redirect result is always null, /started, or /home — never an unknown route',
      () {
        final random = Random(42);
        const allowedRedirects = {null, '/started', '/home'};

        for (int i = 0; i < 100; i++) {
          final cacheStarted = random.nextBool();
          final location = appRoutes[random.nextInt(appRoutes.length)];

          when(
            () => mockStorageService.getBool(
              key: 'cacheStarted',
              defaultValue: false,
            ),
          ).thenReturn(cacheStarted);

          final redirect = appRouter.evaluateRedirect(location);

          expect(
            allowedRedirects.contains(redirect),
            isTrue,
            reason:
                'Unexpected redirect "$redirect" for cacheStarted=$cacheStarted location=$location',
          );

          // Universal invariant: no self-redirect (infinite loop).
          expect(
            noImmediateLoop(location, redirect),
            isTrue,
            reason:
                'Self-redirect detected: location=$location redirect=$redirect (cacheStarted=$cacheStarted)',
          );
        }
      },
    );

    test(
      'applying redirect output as next location never loops (idempotency check)',
      () {
        final random = Random(42);

        for (int i = 0; i < 100; i++) {
          final cacheStarted = random.nextBool();
          final initialLocation = appRoutes[random.nextInt(appRoutes.length)];

          when(
            () => mockStorageService.getBool(
              key: 'cacheStarted',
              defaultValue: false,
            ),
          ).thenReturn(cacheStarted);

          // First redirect evaluation.
          final firstRedirect = appRouter.evaluateRedirect(initialLocation);

          if (firstRedirect != null) {
            // Simulate following the redirect: evaluate again from the
            // redirected location with the same cacheStarted value.
            final secondRedirect = appRouter.evaluateRedirect(firstRedirect);

            // The second evaluation must not redirect back to the original
            // location or create a new redirect (it must settle to null).
            expect(
              secondRedirect,
              isNull,
              reason: 'After redirect from $initialLocation → $firstRedirect, '
                  'a second redirect $secondRedirect was issued — potential loop '
                  '(cacheStarted=$cacheStarted)',
            );
          }
        }
      },
    );
  });
}

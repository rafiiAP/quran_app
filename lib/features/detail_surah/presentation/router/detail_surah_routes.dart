import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:quran_app/features/detail_surah/domain/usecases/get_detail_surah_usecase.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_cubit/detail_surah_cubit.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_page_cubit/detail_surah_page_cubit.dart';
import 'package:quran_app/features/detail_surah/presentation/pages/detail_surah_page.dart';

/// Routes for the detail surah feature.
///
/// Provides the `/detail-surah/:nomor` route with optional `?ayat={index}`
/// query parameter. Uses [int.tryParse] for safe path/query parameter parsing
/// and redirects to `/home` when `nomor` is invalid.
///
/// Cubits are scoped to this route via [MultiBlocProvider]:
/// - [DetailSurahCubit] — fetches detail surah data from API
/// - [DetailSurahPageCubit] — handles UI actions (bookmark, last-read)
///
/// Fresh instances are created on each navigation; disposal is automatic
/// when the route is popped (BlocProvider handles closing the Cubit).
List<RouteBase> get detailSurahRoutes => [
      GoRoute(
        path: '/detail-surah/:nomor',
        redirect: (context, state) {
          final nomor = int.tryParse(state.pathParameters['nomor'] ?? '');
          if (nomor == null) {
            locator<CrashReporter>().recordError(
              FormatException(
                'Invalid nomor: ${state.pathParameters['nomor']}',
              ),
              StackTrace.current,
            );
            return AppConfig.routeHome;
          }
          return null;
        },
        builder: (context, state) {
          final nomor = int.tryParse(state.pathParameters['nomor'] ?? '');
          if (nomor == null) {
            // Unreachable after redirect; safety fallback.
            return const SizedBox.shrink();
          }
          final indexTandai =
              int.tryParse(state.uri.queryParameters['ayat'] ?? '');
          return MultiBlocProvider(
            providers: [
              BlocProvider<DetailSurahCubit>(
                create: (_) => DetailSurahCubit(
                  usecase: locator<GetDetailSurahUseCase>(),
                ),
              ),
              BlocProvider<DetailSurahPageCubit>(
                create: (_) => DetailSurahPageCubit(
                  storageService: locator<LocalStorageService>(),
                  bookmarkRepository: locator<BookmarkRepository>(),
                ),
              ),
            ],
            child: DetailSurahPage(nomor: nomor, indexTandai: indexTandai),
          );
        },
      ),
    ];

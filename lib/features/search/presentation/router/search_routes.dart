import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/constants/route_names.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/features/search/domain/usecases/search_surah_usecase.dart';
import 'package:quran_app/features/search/presentation/cubits/search_cubit/search_cubit.dart';
import 'package:quran_app/features/search/presentation/pages/search_page.dart';

/// Routes for the search feature.
///
/// Provides the `/search` route with a scoped [SearchCubit].
List<RouteBase> get searchRoutes => [
      GoRoute(
        path: RouteNames.search,
        builder: (context, state) => BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(
            searchSurahUseCase: locator<SearchSurahUseCase>(),
          ),
          child: SearchPage(),
        ),
      ),
    ];

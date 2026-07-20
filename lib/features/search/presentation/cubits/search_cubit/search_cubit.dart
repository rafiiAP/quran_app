import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/features/search/domain/usecases/search_surah_usecase.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';

part 'search_state.dart';
part 'search_cubit.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required SearchSurahUseCase searchSurahUseCase})
      : _searchSurahUseCase = searchSurahUseCase,
        super(const SearchState.initial());

  final SearchSurahUseCase _searchSurahUseCase;

  void onSearch({
    required List<SurahEntity> surahList,
    required String query,
  }) {
    final List<SurahEntity> filtered = _searchSurahUseCase(
      surahList: surahList,
      query: query,
    );
    emit(SearchState.results(results: filtered));
  }

  void clearSearch() {
    emit(const SearchState.results(results: []));
  }
}

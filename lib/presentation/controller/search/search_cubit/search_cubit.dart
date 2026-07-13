import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';

part 'search_state.dart';
part 'search_cubit.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState.initial());

  void onSearch({
    required List<SurahEntity> surahList,
    required String query,
  }) {
    if (query.isEmpty) {
      emit(const SearchState.results(results: []));
      return;
    }
    final List<SurahEntity> filtered = surahList
        .where((final SurahEntity e) =>
            e.namaLatin.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(SearchState.results(results: filtered));
  }

  void clearSearch() {
    emit(const SearchState.results(results: []));
  }
}

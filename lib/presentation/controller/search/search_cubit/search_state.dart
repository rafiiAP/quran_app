part of 'search_cubit.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.results({
    required List<SurahEntity> results,
  }) = _Results;
}

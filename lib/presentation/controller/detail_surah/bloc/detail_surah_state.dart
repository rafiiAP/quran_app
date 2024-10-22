part of 'detail_surah_bloc.dart';

@freezed
class DetailSurahState with _$DetailSurahState {
  const factory DetailSurahState.initial() = _Initial;
  const factory DetailSurahState.loading() = _Loading;
  const factory DetailSurahState.loaded(DetailModel detailModel) = _Success;
  const factory DetailSurahState.error(String message) = _Error;
}

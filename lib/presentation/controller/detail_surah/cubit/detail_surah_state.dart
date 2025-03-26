part of 'detail_surah_cubit.dart';

@freezed
class DetailSurahState with _$DetailSurahState {
  const factory DetailSurahState.initial() = _Initial;
  const factory DetailSurahState.loading() = _Loading;
  const factory DetailSurahState.success(final DetailEntity data) = _Success;
  const factory DetailSurahState.error(final String message) = _Error;
}

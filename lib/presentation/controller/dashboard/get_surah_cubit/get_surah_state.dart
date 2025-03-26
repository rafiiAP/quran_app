part of 'get_surah_cubit.dart';

@freezed
class GetSurahState with _$GetSurahState {
  const factory GetSurahState.initial() = _Initial;
  const factory GetSurahState.loading() = _Loading;
  const factory GetSurahState.success(final List<SurahEntity> surah) = _Success;
  const factory GetSurahState.error(final String message) = _Error;
}

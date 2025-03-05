part of 'get_surah_cubit.dart';

@freezed
class GetSurahState with _$GetSurahState {
  const factory GetSurahState.initial() = _Initial;
  const factory GetSurahState.loading() = _Loading;
  const factory GetSurahState.success(List<SurahEntity> surah) = _Success;
  const factory GetSurahState.error(String message) = _Error;
}

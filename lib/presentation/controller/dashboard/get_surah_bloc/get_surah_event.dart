part of 'get_surah_bloc.dart';

@freezed
class GetSurahEvent with _$GetSurahEvent {
  const factory GetSurahEvent.started() = _Started;
  const factory GetSurahEvent.getSurah() = _GetSurah;
}

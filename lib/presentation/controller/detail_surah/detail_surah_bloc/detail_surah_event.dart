part of 'detail_surah_bloc.dart';

@freezed
class DetailSurahEvent with _$DetailSurahEvent {
  const factory DetailSurahEvent.started() = _Started;
  const factory DetailSurahEvent.getDetailSurah(int nomor) = _GetDetailSurah;
}

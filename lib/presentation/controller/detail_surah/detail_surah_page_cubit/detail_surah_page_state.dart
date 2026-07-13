part of 'detail_surah_page_cubit.dart';

@freezed
class DetailSurahPageState with _$DetailSurahPageState {
  const factory DetailSurahPageState.idle() = _Idle;
  const factory DetailSurahPageState.actionCompleted({
    required String message,
  }) = _ActionCompleted;
}

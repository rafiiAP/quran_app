part of 'detail_surah_page_cubit.dart';

@freezed
class DetailSurahPageState with _$DetailSurahPageState {
  const factory DetailSurahPageState.idle({
    /// Transient message from the last completed action.
    /// UI should consume this (e.g., show SnackBar) and then call
    /// [DetailSurahPageCubit.clearLastAction] to reset.
    String? lastActionMessage,
  }) = _Idle;
  const factory DetailSurahPageState.actionCompleted({
    required String message,
  }) = _ActionCompleted;
}

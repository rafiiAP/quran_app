part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loaded({
    required String namaLatin,
    required int nomorSurah,
    required int nomorAyat,
    required List<SurahEntity> surahList,
  }) = _Loaded;
  const factory HomeState.navigateToDetail({
    required int nomorSurah,
    required int? indexTandai,
  }) = _NavigateToDetail;
  const factory HomeState.showMessage(String message) = _ShowMessage;
}

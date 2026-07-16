part of 'bookmark_cubit.dart';

@freezed
class BookmarkState with _$BookmarkState {
  const factory BookmarkState.initial() = _Initial;
  const factory BookmarkState.loading() = _Loading;
  const factory BookmarkState.loaded({
    required List<BookmarkEntity> bookmarks,
  }) = _Loaded;
  const factory BookmarkState.error(String message) = _Error;
  const factory BookmarkState.navigateToDetail({
    required int nomorSurah,
    required int nomorAyat,
  }) = _NavigateToDetail;
}

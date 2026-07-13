part of 'bookmark_cubit.dart';

@freezed
class BookmarkState with _$BookmarkState {
  const factory BookmarkState.initial() = _Initial;
  const factory BookmarkState.loading() = _Loading;
  const factory BookmarkState.loaded({
    required List<BookmarkModel> bookmarks,
  }) = _Loaded;
  const factory BookmarkState.navigateToDetail({
    required int nomorSurah,
    required int nomorAyat,
  }) = _NavigateToDetail;
}

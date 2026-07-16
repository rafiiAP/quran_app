import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';

part 'bookmark_state.dart';
part 'bookmark_cubit.freezed.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepository bookmarkRepository;

  BookmarkCubit({required this.bookmarkRepository})
      : super(const BookmarkState.initial()) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    emit(const BookmarkState.loading());
    final Either<Failure, List<BookmarkEntity>> result =
        await bookmarkRepository.getAllBookmarks();
    result.match(
      (final Failure l) => emit(BookmarkState.error(l.message)),
      (final List<BookmarkEntity> bookmarks) =>
          emit(BookmarkState.loaded(bookmarks: bookmarks)),
    );
  }

  Future<void> deleteBookmark(final BookmarkEntity bookmark) async {
    final result =
        await bookmarkRepository.deleteBookmark(bookmark.teksIndonesia);
    result.match(
      (final Failure l) => emit(BookmarkState.error(l.message)),
      (_) => loadBookmarks(),
    );
  }

  String formatCopyText(final BookmarkEntity bookmark) {
    return '${bookmark.namaLatin} : ${bookmark.nomorSurah}\n'
        '${bookmark.teksArab}\n'
        '${bookmark.teksIndonesia}';
  }

  void navigateToDetail(final BookmarkEntity bookmark) {
    emit(
      BookmarkState.navigateToDetail(
        nomorSurah: bookmark.nomorSurah,
        nomorAyat: bookmark.nomorAyat,
      ),
    );
    loadBookmarks();
  }
}

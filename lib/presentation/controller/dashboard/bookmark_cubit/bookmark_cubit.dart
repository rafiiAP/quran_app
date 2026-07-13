import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/data/model/bookmark_model.dart';

part 'bookmark_state.dart';
part 'bookmark_cubit.freezed.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final DatabaseHelper databaseHelper;

  BookmarkCubit({required this.databaseHelper})
      : super(const BookmarkState.initial()) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    emit(const BookmarkState.loading());
    final List<BookmarkModel> bookmarks =
        await databaseHelper.getAllBookmarks();
    emit(BookmarkState.loaded(bookmarks: bookmarks));
  }

  Future<void> deleteBookmark(final BookmarkModel bookmark) async {
    await databaseHelper.deleteBookmark(bookmark.teksIndonesia);
    await loadBookmarks();
  }

  String formatCopyText(final BookmarkModel bookmark) {
    return '${bookmark.namaLatin} : ${bookmark.nomorSurah}\n'
        '${bookmark.teksArab}\n'
        '${bookmark.teksIndonesia}';
  }

  void navigateToDetail(final BookmarkModel bookmark) {
    emit(BookmarkState.navigateToDetail(
      nomorSurah: bookmark.nomorSurah,
      nomorAyat: bookmark.nomorAyat,
    ));
    loadBookmarks();
  }
}

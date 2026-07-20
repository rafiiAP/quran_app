import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/domain/usecases/delete_bookmark_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';

part 'bookmark_state.dart';
part 'bookmark_cubit.freezed.dart';

/// Navigation event emitted as a one-shot action.
///
/// Consumed via [BookmarkCubit.navigationEvents] stream, ensuring the event
/// is never lost due to state overwrites (unlike navigation-as-state).
class BookmarkNavigationEvent {
  const BookmarkNavigationEvent({
    required this.nomorSurah,
    required this.nomorAyat,
  });

  final int nomorSurah;
  final int nomorAyat;
}

class BookmarkCubit extends Cubit<BookmarkState> {
  final GetBookmarksUseCase _getBookmarksUseCase;
  final DeleteBookmarkUseCase _deleteBookmarkUseCase;

  final StreamController<BookmarkNavigationEvent> _navigationController =
      StreamController<BookmarkNavigationEvent>.broadcast();

  /// Stream of one-shot navigation events.
  /// Listen in the widget layer to trigger navigation without risking
  /// state-overwrite race conditions.
  Stream<BookmarkNavigationEvent> get navigationEvents =>
      _navigationController.stream;

  BookmarkCubit({
    required GetBookmarksUseCase getBookmarksUseCase,
    required DeleteBookmarkUseCase deleteBookmarkUseCase,
  })  : _getBookmarksUseCase = getBookmarksUseCase,
        _deleteBookmarkUseCase = deleteBookmarkUseCase,
        super(const BookmarkState.initial());

  Future<void> loadBookmarks() async {
    emit(const BookmarkState.loading());
    final Either<Failure, List<BookmarkEntity>> result =
        await _getBookmarksUseCase();
    result.match(
      (final Failure l) => emit(BookmarkState.error(l.message)),
      (final List<BookmarkEntity> bookmarks) =>
          emit(BookmarkState.loaded(bookmarks: bookmarks)),
    );
  }

  Future<void> deleteBookmark(final BookmarkEntity bookmark) async {
    final result = await _deleteBookmarkUseCase(
      id: bookmark.id!,
    );
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

  /// Emits a navigation event via the [navigationEvents] stream.
  /// Does NOT modify cubit state — avoids race conditions.
  void navigateToDetail(final BookmarkEntity bookmark) {
    _navigationController.add(
      BookmarkNavigationEvent(
        nomorSurah: bookmark.nomorSurah,
        nomorAyat: bookmark.nomorAyat,
      ),
    );
  }

  @override
  Future<void> close() {
    _navigationController.close();
    return super.close();
  }
}

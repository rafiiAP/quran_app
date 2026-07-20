import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/constants/cache_keys.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/models/bookmark_input.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/core/usecases/save_bookmark_action.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';

part 'detail_surah_page_state.dart';
part 'detail_surah_page_cubit.freezed.dart';

class DetailSurahPageCubit extends Cubit<DetailSurahPageState> {
  final LocalStorageService storageService;
  final SaveBookmarkAction _saveBookmarkAction;

  DetailSurahPageCubit({
    required this.storageService,
    required SaveBookmarkAction saveBookmarkUseCase,
  })  : _saveBookmarkAction = saveBookmarkUseCase,
        super(const DetailSurahPageState.idle());

  /// Clears the transient action message. Call from the UI after consuming
  /// the [lastActionMessage] (e.g., after showing a SnackBar).
  void clearLastAction() {
    emit(const DetailSurahPageState.idle());
  }

  Future<void> markAsLastRead({
    required String namaLatin,
    required int nomorSurah,
    required int nomorAyat,
  }) async {
    await storageService.setString(
      key: CacheKeys.namaLatin,
      value: namaLatin,
    );
    await storageService.setInt(key: CacheKeys.nomorSurah, value: nomorSurah);
    await storageService.setInt(key: CacheKeys.nomorAyat, value: nomorAyat);
    emit(
      const DetailSurahPageState.actionCompleted(
        message: 'Berhasil ditandai sebagai bacaan terakhir',
      ),
    );
  }

  Future<void> saveBookmark({
    required AyatDetailEntity ayat,
    required DetailEntity detail,
  }) async {
    final input = BookmarkInput(
      nomorSurah: detail.nomor,
      namaLatin: detail.namaLatin,
      nomorAyat: ayat.nomorAyat,
      teksArab: ayat.teksArab,
      teksIndonesia: ayat.teksIndonesia,
      teksLatin: ayat.teksLatin,
    );
    final Either<Failure, bool> result =
        await _saveBookmarkAction(input: input);
    result.match(
      (final Failure l) => emit(
        DetailSurahPageState.actionCompleted(message: l.message),
      ),
      (final bool isNew) => emit(
        DetailSurahPageState.actionCompleted(
          message: isNew ? 'Berhasil disimpan ke bookmark' : 'Data sudah ada',
        ),
      ),
    );
  }

  String formatCopyText({
    required AyatDetailEntity ayat,
    required DetailEntity detail,
  }) {
    return '${detail.namaLatin}, ayat ke-${ayat.nomorAyat}\n\n'
        '${ayat.teksArab}\n\n'
        '${ayat.teksIndonesia} (${ayat.nomorAyat})';
  }
}

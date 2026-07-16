import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/features/bookmark/domain/usecases/save_bookmark_usecase.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';

part 'detail_surah_page_state.dart';
part 'detail_surah_page_cubit.freezed.dart';

class DetailSurahPageCubit extends Cubit<DetailSurahPageState> {
  final LocalStorageService storageService;
  final SaveBookmarkUseCase _saveBookmarkUseCase;

  DetailSurahPageCubit({
    required this.storageService,
    required SaveBookmarkUseCase saveBookmarkUseCase,
  })  : _saveBookmarkUseCase = saveBookmarkUseCase,
        super(const DetailSurahPageState.idle());

  Future<void> markAsLastRead({
    required String namaLatin,
    required int nomorSurah,
    required int nomorAyat,
  }) async {
    await storageService.setString(
      key: config.cacheNamaLatin,
      value: namaLatin,
    );
    await storageService.setInt(key: config.cacheNomorSurah, value: nomorSurah);
    await storageService.setInt(key: config.cacheNomorAyat, value: nomorAyat);
    emit(
      const DetailSurahPageState.actionCompleted(
        message: 'Berhasil ditandai sebagai bacaan terakhir',
      ),
    );
    emit(const DetailSurahPageState.idle());
  }

  Future<void> saveBookmark({
    required AyatDetailEntity ayat,
    required DetailEntity detail,
  }) async {
    final Either<Failure, bool> result =
        await _saveBookmarkUseCase(ayat: ayat, detail: detail);
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
    emit(const DetailSurahPageState.idle());
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

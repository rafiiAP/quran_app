import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/core/storage/database_helper.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';

part 'detail_surah_page_state.dart';
part 'detail_surah_page_cubit.freezed.dart';

class DetailSurahPageCubit extends Cubit<DetailSurahPageState> {
  final LocalStorageService storageService;
  final DatabaseHelper databaseHelper;

  DetailSurahPageCubit({
    required this.storageService,
    required this.databaseHelper,
  }) : super(const DetailSurahPageState.idle());

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
    final bool isNew =
        await databaseHelper.insertOrUpdateBookmark(ayat, detail);
    emit(
      DetailSurahPageState.actionCompleted(
        message: isNew ? 'Berhasil disimpan ke bookmark' : 'Data sudah ada',
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

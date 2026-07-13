import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/data/datasources/local_storage_service.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';

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
    await storageService.setString(key: 'cacheNamaLatin', value: namaLatin);
    await storageService.setInt(key: 'cacheNomorSurah', value: nomorSurah);
    await storageService.setInt(key: 'cacheNomorAyat', value: nomorAyat);
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

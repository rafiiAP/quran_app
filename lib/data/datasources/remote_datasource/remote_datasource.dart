import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/jadwal_sholat_model.dart';
import 'package:quran_app/data/model/surah_model.dart';

abstract class RemoteDatasource {
  Future<List<SurahModel>> getSurah();
  Future<DetailModel> getDetailSurah({required final int nomor});
  Future<JadwalSholatModel> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  });
}

class RemoteDatasourceImpl implements RemoteDatasource {
  @override
  Future<List<SurahModel>> getSurah() async {
    try {
      final String response = await C.dioGet(
        url: 'https://equran.id/api/v2/surat',
        requestName: 'getSurah',
      );
      return SurahaDioModel.fromJson(response).data;
    } on DioException catch (e, stackTrace) {
      // Kirim error ke Firebase Crashlytics
      await FirebaseCrashlytics.instance.recordError(e, stackTrace);

      throw Exception("Gagal mengambil data dari server.");
    } catch (e, stackTrace) {
      // Kirim error ke Firebase Crashlytics sebelum rethrow
      await FirebaseCrashlytics.instance.recordError(e, stackTrace);

      rethrow; // Lempar ulang agar tetap muncul di terminal
    }
  }

  @override
  Future<DetailModel> getDetailSurah({required final int nomor}) async {
    try {
      final String response = await C.dioGet(
        url: 'https://equran.id/api/v2/surat/$nomor',
        requestName: 'getDetailSurah',
      );
      return ResponseDetailModel.fromJson(response).data;
    } on DioException catch (e, stackTrace) {
      // Kirim error ke Firebase Crashlytics
      await FirebaseCrashlytics.instance.recordError(e, stackTrace);

      throw Exception("Gagal mengambil data dari server.");
    } catch (e, stackTrace) {
      // Kirim error ke Firebase Crashlytics sebelum rethrow
      await FirebaseCrashlytics.instance.recordError(e, stackTrace);

      rethrow; // Lempar ulang agar tetap muncul di terminal
    }
  }

  @override
  Future<JadwalSholatModel> getJadwalSholat({
    required final double latitude,
    required final double longitude,
    required final String date,
  }) async {
    try {
      final String response = await C.dioGet(
          url:
              '${config.cUrlJadwalSholat}/$date?latitude=$latitude&longitude=$longitude',
          requestName: 'getJadwalSholat');

      return JadwalSholatDioModel.fromJson(response).data.timings;
    } on DioException catch (e, stackTrace) {
      // Kirim error ke Firebase Crashlytics
      await FirebaseCrashlytics.instance.recordError(e, stackTrace);

      throw Exception("Gagal mengambil data dari server.");
    } catch (e, stackTrace) {
      // Kirim error ke Firebase Crashlytics sebelum rethrow
      await FirebaseCrashlytics.instance.recordError(e, stackTrace);

      rethrow; // Lempar ulang agar tetap muncul di terminal
    }
  }
}

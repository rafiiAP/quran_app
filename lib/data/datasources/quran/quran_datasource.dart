import 'package:dio/dio.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/jadwal_sholat_model.dart';
import 'package:quran_app/data/model/surah_model.dart';

abstract class RemoteDatasource {
  Future<List<SurahModel>> getSurah();
  Future<DetailModel> getDetailSurah({required int nomor});
  Future<JadwalSholatModel> getJadwalSholat({
    required double latitude,
    required double longitude,
    required String date,
  });
}

class RemoteDatasourceImpl implements RemoteDatasource {
  @override
  Future<List<SurahModel>> getSurah() async {
    try {
      String response = await C.dioGet(
        url: 'https://equran.id/api/v2/surat',
        requestName: 'getSurah',
      );
      return HTTPModel.fromJson(response).data;
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<DetailModel> getDetailSurah({required int nomor}) async {
    try {
      String response = await C.dioGet(
        url: 'https://equran.id/api/v2/surat/$nomor',
        requestName: 'getDetailSurah',
      );
      return ResponseDetailModel.fromJson(response).data;
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<JadwalSholatModel> getJadwalSholat({
    required double latitude,
    required double longitude,
    required String date,
  }) async {
    // C.showLog(log: '--date: $date, latitude: $latitude, longitude: $longitude');
    var result = await C.dioGet(
        url: '${AppConfig.cUrlJadwalSholat}/$date?latitude=$latitude&longitude=$longitude',
        requestName: 'getJadwalSholat');

    JadwalSholatModel model = JadwalSholatDioModel.fromJson(result).data.timings;

    // C.showLog(log: '--JadwalSholatModel: ${jsonEncode(model)}');
    return model;
  }
}

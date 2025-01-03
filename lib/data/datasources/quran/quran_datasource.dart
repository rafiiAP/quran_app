import 'package:dio/dio.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/surah_model.dart';

abstract class QuranDatasource {
  Future<List<SurahModel>> getSurah();
  Future<DetailModel> getDetailSurah({required int nomor});
}

class QuranDatasourceImpl implements QuranDatasource {
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
}

import 'package:dio/dio.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/surah_model.dart';

class QuranDatasource {
  Future<HTTPModel> getSurah() async {
    try {
      String response = await C.dioGet(
        url: 'https://equran.id/api/v2/surat',
        requestName: 'getSurah',
      );
      return HTTPModel.fromJson(response);
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<HttpDetailModel> getDetailSurah({required int nomor}) async {
    try {
      String response = await C.dioGet(
        url: 'https://equran.id/api/v2/surat/$nomor',
        requestName: 'getDetailSurah',
      );
      return HttpDetailModel.fromJson(response);
    } on DioException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

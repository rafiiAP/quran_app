import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_bloc/get_surah_bloc.dart';
import 'package:quran_app/presentation/controller/detail_surah/bloc/detail_surah_bloc.dart';
import 'package:quran_app/presentation/view/serach_page/search_page.dart';

import '../../view/detail_surah/detail_surah_page.dart';

class HomeGetx extends GetxController {
  QuranUsecase quranUsecase = QuranUsecase();

  Rx<List<SurahModel>> surahList = Rx<List<SurahModel>>([]);

  var cNamaLatin = ''.obs;
  var nNomorAyat = 0.obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
    super.onInit();
  }

  init() {
    getLastRead();
    getSurah();
  }

  getLastRead() {
    cNamaLatin.value = C.getString(cKey: AppConfig.cacheNamaLatin);
    nNomorAyat.value = C.getInt(cKey: AppConfig.cacheNomorAyat, nDefaultValue: 0);
  }

  getSurah() {
    BuildContext context = Get.context!;
    context.read<GetSurahBloc>().add(const GetSurahEvent.getSurah());
  }

  onSuccesGetSurah(List<SurahModel> data) {
    W.endwait();
    surahList.value = data;
  }

  getDetailSurah(SurahModel data) {
    C.setString(cKey: AppConfig.cacheNamaLatin, cValue: data.namaLatin!);
    C.setInt(cKey: AppConfig.cacheNomorAyat, nValue: data.nomor!);
    BuildContext context = Get.context!;
    context.read<DetailSurahBloc>().add(DetailSurahEvent.getDetailSurah(data.nomor!));
  }

  onSuccesDetailSurah(DetailModel data) {
    W.endwait();

    C.to(() => DetailSurahPage(detailModel: data))!.then((_) {
      getLastRead();
    });
  }

  toSearchPage() {
    C.to(() => SearchPage(
          vaSurah: surahList.value,
        ));
  }
}
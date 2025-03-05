import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';

import 'package:quran_app/presentation/controller/dashboard/get_surah_bloc/get_surah_bloc.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_bloc/detail_surah_bloc.dart';
import 'package:quran_app/presentation/view/serach_page/search_page.dart';

import '../../view/detail_surah/detail_surah_page.dart';

class HomeGetx extends GetxController {
  Rx<List<SurahEntity>> surahList = Rx<List<SurahEntity>>([]);

  var cNamaLatin = ''.obs;
  var nNomorAyat = 0.obs;

  @override
  void onReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSurah();
    });
    super.onReady();
  }

  @override
  void onInit() {
    getLastRead();

    super.onInit();
  }

  getLastRead() {
    cNamaLatin.value = C.getString(cKey: AppConfig.cacheNamaLatin);
    nNomorAyat.value = C.getInt(cKey: AppConfig.cacheNomorAyat, nDefaultValue: 0);
  }

  getSurah() {
    BuildContext context = Get.context!;
    context.read<GetSurahBloc>().add(const GetSurahEvent.getSurah());
  }

  onSuccesGetSurah(List<SurahEntity> data) {
    surahList.value = data;
  }

  getDetailSurah(SurahEntity data) {
    C.setString(cKey: AppConfig.cacheNamaLatin, cValue: data.namaLatin);
    C.setInt(cKey: AppConfig.cacheNomorAyat, nValue: data.nomor);
    BuildContext context = Get.context!;
    context.read<DetailSurahBloc>().add(DetailSurahEvent.getDetailSurah(data.nomor));
  }

  onSuccesDetailSurah(DetailEntity data) {
    W.endwait();
    C.to(() => DetailSurahPage(detailEntity: data))!.then((_) {
      getLastRead();
    });
  }

  toSearchPage() {
    C.to(() => SearchPage(
          vaSurah: surahList.value,
        ));
  }
}

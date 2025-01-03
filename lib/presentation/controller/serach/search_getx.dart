import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/config.dart';

import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_bloc/detail_surah_bloc.dart';
import 'package:quran_app/presentation/view/detail_surah/detail_surah_page.dart';

class SearchGetx extends GetxController {
  TextEditingController searchController = TextEditingController();
  Rx<List<SurahEntity>> vaSearch = Rx<List<SurahEntity>>([]);

  getDetailSurah(SurahEntity data) {
    C.setString(cKey: AppConfig.cacheNamaLatin, cValue: data.namaLatin);
    C.setInt(cKey: AppConfig.cacheNomorAyat, nValue: data.nomor);
    BuildContext context = Get.context!;
    context.read<DetailSurahBloc>().add(DetailSurahEvent.getDetailSurah(data.nomor));
  }

  onSuccesDetailSurah(DetailEntity data) {
    W.endwait();

    C.to(() => DetailSurahPage(detailEntity: data));
  }

  onSearch({required List<SurahEntity> surahList, required String value}) {
    vaSearch.value =
        surahList.where((element) => element.namaLatin.toLowerCase().contains(value.toLowerCase())).toList();
    if (value.isEmpty) {
      vaSearch.value.clear();
    }
  }
}

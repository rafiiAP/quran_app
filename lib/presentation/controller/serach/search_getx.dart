import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/presentation/controller/detail_surah/bloc/detail_surah_bloc.dart';
import 'package:quran_app/presentation/view/detail_surah/detail_surah_page.dart';

class SearchGetx extends GetxController {
  TextEditingController searchController = TextEditingController();
  Rx<List<SurahModel>> vaSearch = Rx<List<SurahModel>>([]);

  getDetailSurah(SurahModel data) {
    C.setString(cKey: AppConfig.cacheNamaLatin, cValue: data.namaLatin!);
    C.setInt(cKey: AppConfig.cacheNomorAyat, nValue: data.nomor!);
    BuildContext context = Get.context!;
    context.read<DetailSurahBloc>().add(DetailSurahEvent.getDetailSurah(data.nomor!));
  }

  onSuccesDetailSurah(DetailModel data) {
    W.endwait();

    C.to(() => DetailSurahPage(detailModel: data));
  }

  onSearch({required List<SurahModel> surahList, required String value}) {
    vaSearch.value =
        surahList.where((element) => element.namaLatin!.toLowerCase().contains(value.toLowerCase())).toList();
    if (value.isEmpty) {
      vaSearch.value.clear();
    }
  }
}

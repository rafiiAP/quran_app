import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/presentation/controller/detail_surah/cubit/detail_surah_cubit.dart';

import 'package:quran_app/presentation/view/serach_page/search_page.dart';

import '../../view/detail_surah/detail_surah_page.dart';

class HomeGetx extends GetxController {
  Rx<List<SurahEntity>> surahList = Rx<List<SurahEntity>>([]);

  var cNamaLatin = ''.obs;
  var nNomorSurah = 0.obs;
  var nNomorAyat = 0.obs;

  ///untuk kodisi ketika tap lastRead atau tidak
  var isToLastRead = false.obs;
  var isSnackbarActive = false.obs;

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
    nNomorSurah.value = C.getInt(cKey: AppConfig.cacheNomorSurah, nDefaultValue: 0);
    nNomorAyat.value = C.getInt(cKey: AppConfig.cacheNomorAyat, nDefaultValue: 0);
  }

  getSurah() {
    BuildContext context = Get.context!;
    //memanggil data al-qur'an
    context.read<GetSurahCubit>().getPosts();
  }

  onSuccesGetSurah(List<SurahEntity> data) {
    surahList.value = data;
  }

  toLastRead({int? index = 0}) {
    if (index != 0) {
      isToLastRead.value = true;

      BuildContext context = Get.context!;
      context.read<DetailSurahCubit>().getPosts(number: index!);
    } else {
      //tampilkan snackbar
      if (!isSnackbarActive.value) {
        isSnackbarActive.value = true; // Set jadi aktif

        Get.snackbar(
          'Perhatian',
          'Belum ada bacaan terakhir',
        );
        Future.delayed(const Duration(seconds: 3), () => isSnackbarActive.value = false); // Setelah 3 detik))
      }
    }
  }

  getDetailSurah(SurahEntity data) {
    isToLastRead.value = false;

    BuildContext context = Get.context!;
    context.read<DetailSurahCubit>().getPosts(number: data.nomor);
  }

  onSuccesDetailSurah(DetailEntity data) {
    W.endwait();
    C.to(() => DetailSurahPage(detailEntity: data, index: isToLastRead.value ? nNomorAyat.value : null))!.then((_) {
      getLastRead();
    });
  }

  toSearchPage() {
    C.to(() => SearchPage(
          vaSurah: surahList.value,
        ));
  }
}

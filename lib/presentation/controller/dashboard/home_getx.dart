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
  final GlobalKey tandaiKey = GlobalKey();
  final GlobalKey helpKey = GlobalKey();

  Rx<List<SurahEntity>> surahList = Rx<List<SurahEntity>>(<SurahEntity>[]);

  RxString cNamaLatin = ''.obs;
  RxInt nNomorSurah = 0.obs;
  RxInt nNomorAyat = 0.obs;

  ///untuk kodisi ketika tap lastRead atau tidak
  RxBool isToLastRead = false.obs;
  RxBool isSnackbarActive = false.obs;
  RxBool isFirstTime = false.obs;

  @override
  void onReady() {
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      getSurah();
    });
    super.onReady();
  }

  @override
  void onInit() {
    getLastRead();

    super.onInit();
  }

  void getLastRead() {
    cNamaLatin.value = C.getString(cKey: config.cacheNamaLatin);
    nNomorSurah.value =
        C.getInt(cKey: config.cacheNomorSurah, nDefaultValue: 0);
    nNomorAyat.value = C.getInt(cKey: config.cacheNomorAyat, nDefaultValue: 0);
  }

  void getSurah() async {
    BuildContext context = Get.context!;
    //memanggil data al-qur'an
    context.read<GetSurahCubit>().getPosts();
  }

  void onSuccesGetSurah(final List<SurahEntity> data) {
    surahList.value = data;
  }

  void toLastRead({final int? index = 0}) async {
    if (index != 0) {
      isToLastRead.value = true;

      final BuildContext context = Get.context!;
      await context.read<DetailSurahCubit>().getPosts(number: index!);
    } else {
      //tampilkan snackbar
      if (!isSnackbarActive.value) {
        isSnackbarActive.value = true; // Set jadi aktif

        Get.snackbar(
          'Perhatian',
          'Belum ada bacaan terakhir',
        );
        Future.delayed(const Duration(seconds: 3), () {
          isSnackbarActive.value = false;
        }); // Setelah 3 detik))
      }
    }
  }

  void getDetailSurah(final SurahEntity data) async {
    isToLastRead.value = false;

    final BuildContext context = Get.context!;
    await context.read<DetailSurahCubit>().getPosts(number: data.nomor);
  }

  void onSuccesDetailSurah(final DetailEntity data) async {
    W.endwait();
    await C
        .to(() => DetailSurahPage(
            detailEntity: data,
            indexTandai: isToLastRead.value ? nNomorAyat.value : null))
        .then((final _) {
      getLastRead();
    });
  }

  void toSearchPage() async {
    await C.to(() => SearchPage(
          vaSurah: surahList.value,
        ));
  }
}

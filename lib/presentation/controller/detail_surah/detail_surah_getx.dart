import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DetailSurahGetx extends GetxController {
  int? index;
  DetailSurahGetx({this.index});

  DatabaseHelper dbHelper = DatabaseHelper();
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void onReady() {
    toScrollIndex(index);
    super.onReady();
  }

  onTapShare(AyatDetailEntity ayatModel) {
    Clipboard.setData(
      ClipboardData(
        text: '${ayatModel.teksArab}\n${ayatModel.teksIndonesia}',
      ),
    ).then((_) {
      Get.snackbar('Sukses', 'Teks berhasil disalin');
    });
  }

  onTapList(BuildContext context, AyatDetailEntity ayatModel, DetailEntity detailModel) {
    W.showBottomSheet(
      backgroundColor: C.isDark(context) ? AppColorConfig.bgBottom : AppColorConfig.white,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          W.paddingheight16(),
          Container(
            width: context.width,
            decoration: BoxDecoration(
              color: C.isDark(context) ? AppColorConfig.bgBottom : AppColorConfig.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: W.buttonAKP(
              onPressed: () {
                C.setString(cKey: AppConfig.cacheNamaLatin, cValue: detailModel.namaLatin);
                C.setInt(cKey: AppConfig.cacheNomorAyat, nValue: ayatModel.nomorAyat);
                C.setInt(cKey: AppConfig.cacheNomorSurah, nValue: detailModel.nomor);

                Get.back();
                Get.snackbar('Sukses', 'Berhasil ditandai sebagai bacaan terakhir');
              },
              text: 'Tandai sebagai bacaan terakhir',
            ),
          ),
          W.paddingheight16(),
          Container(
            width: context.width,
            decoration: BoxDecoration(
              color: C.isDark(context) ? AppColorConfig.bgBottom : AppColorConfig.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: W.buttonAKP(
              onPressed: () {
                dbHelper.insertOrUpdateBookmark(ayatModel, detailModel);
                Get.back();
              },
              text: 'Simpan ke bookmark',
            ),
          ),
          W.paddingheight16(),
          Container(
            width: context.width,
            decoration: BoxDecoration(
              color: C.isDark(context) ? AppColorConfig.bgBottom : AppColorConfig.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: W.buttonAKP(
              onPressed: () {
                onTapShare(ayatModel);
                Get.back();
              },
              text: 'Salin',
            ),
          ),
          W.paddingheight16(),
          W.paddingheight16(),
        ],
      ),
    );
  }

  toScrollIndex(int? index) {
    // await
    // index = 3;
    // C.showLog(log: '--aa');
    if (index != null) {
      if (itemScrollController.isAttached) {
        // itemScrollController.scrollTo(
        //   index: index - 1,
        //   duration: const Duration(milliseconds: 100),
        //   curve: Curves.easeInOut,
        // );
        itemScrollController.jumpTo(
          index: index - 1,
        );
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';

class DetailSurahGetx extends GetxController {
  DatabaseHelper dbHelper = DatabaseHelper();

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
      bottomSheet: Container(
        width: context.width,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25, top: 16),
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
          text: 'Simpan',
        ),
      ),
    );
  }
}

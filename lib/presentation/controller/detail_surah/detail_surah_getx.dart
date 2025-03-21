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
          ListTile(
            leading: const Icon(
              Icons.local_attraction_outlined,
              color: AppColorConfig.primary,
            ),
            title: W.textBody(text: 'Tandai sebagai bacaan terakhir'),
            onTap: () {
              C.setString(cKey: AppConfig.cacheNamaLatin, cValue: detailModel.namaLatin);
              C.setInt(cKey: AppConfig.cacheNomorAyat, nValue: ayatModel.nomorAyat);
              C.setInt(cKey: AppConfig.cacheNomorSurah, nValue: detailModel.nomor);

              Get.back();
              Get.snackbar('Sukses', 'Berhasil ditandai sebagai bacaan terakhir');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.bookmark_add_outlined,
              color: AppColorConfig.primary,
            ),
            title: W.textBody(text: 'Simpan ke bookmark'),
            onTap: () {
              dbHelper.insertOrUpdateBookmark(ayatModel, detailModel);
              Get.back();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.add_link,
              color: AppColorConfig.primary,
            ),
            title: W.textBody(text: 'Salin'),
            onTap: () {
              onTapShare(ayatModel);
              Get.back();
            },
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

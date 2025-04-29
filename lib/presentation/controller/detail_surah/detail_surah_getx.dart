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
import 'package:showcaseview/showcaseview.dart';

class DetailSurahGetx extends GetxController {
  DetailSurahGetx({this.index});
  final int? index;

  final ItemScrollController itemScrollController = ItemScrollController();
  final GlobalKey menuKey = GlobalKey();
  final GlobalKey btnTandaiKey = GlobalKey();
  final GlobalKey btnBookmarkKey = GlobalKey();
  final GlobalKey btnShareKey = GlobalKey();

  @override
  void onReady() {
    toScrollIndex(index);
    super.onReady();
  }

  void onTapShare(
      final AyatDetailEntity ayatModel, DetailEntity detailModel) async {
    await Clipboard.setData(
      ClipboardData(
        text:
            '${detailModel.namaLatin}, ayat ke-${ayatModel.nomorAyat}\n\n${ayatModel.teksArab}\n\n${ayatModel.teksIndonesia} (${ayatModel.nomorAyat})',
      ),
    ).then((final _) {
      Get.snackbar('Sukses', 'Teks berhasil disalin');
    });
  }

  void onTapList(final BuildContext context, final AyatDetailEntity ayatModel,
      final DetailEntity detailModel) async {
    await W.showBottomSheet(
      backgroundColor:
          C.isDark(context) ? colorConfig.bgBottom : colorConfig.white,
      bottomSheet: ShowCaseWidget(builder: (context) {
        C.showCase(
          context: context,
          keys: [btnTandaiKey, btnBookmarkKey, btnShareKey],
          cacheKey: config.cacheShowCaseBottomDetail,
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            W.paddingheight16(),
            Showcase(
              key: btnTandaiKey,
              description: 'Tandai sebagai bacaan terakhir',
              child: ListTile(
                leading: Icon(
                  Icons.local_attraction_outlined,
                  color: colorConfig.primary,
                ),
                title: W.textBody(text: 'Tandai sebagai bacaan terakhir'),
                onTap: () async {
                  await C.setString(
                      cKey: config.cacheNamaLatin,
                      cValue: detailModel.namaLatin);
                  await C.setInt(
                      cKey: config.cacheNomorAyat, nValue: ayatModel.nomorAyat);
                  await C.setInt(
                      cKey: config.cacheNomorSurah, nValue: detailModel.nomor);

                  Get.back();
                  Get.snackbar(
                      'Sukses', 'Berhasil ditandai sebagai bacaan terakhir');
                },
              ),
            ),
            const Divider(),
            Showcase(
              key: btnBookmarkKey,
              description: 'Simpan ke bookmark',
              child: ListTile(
                leading: Icon(
                  Icons.bookmark_add_outlined,
                  color: colorConfig.primary,
                ),
                title: W.textBody(text: 'Simpan ke bookmark'),
                onTap: () {
                  databaseHelper.insertOrUpdateBookmark(ayatModel, detailModel);
                  Get.back();
                },
              ),
            ),
            const Divider(),
            Showcase(
              key: btnShareKey,
              description: 'Salin ke clipboard',
              child: ListTile(
                leading: Icon(
                  Icons.add_link,
                  color: colorConfig.primary,
                ),
                title: W.textBody(text: 'Salin'),
                onTap: () {
                  onTapShare(ayatModel, detailModel);
                  Get.back();
                },
              ),
            ),
            W.paddingheight16(),
            W.paddingheight16(),
          ],
        );
      }),
    );
  }

  void toScrollIndex(final int? index) {
    if (index != null) {
      if (itemScrollController.isAttached) {
        itemScrollController.jumpTo(
          index: index - 1,
        );
      }
    }
  }
}

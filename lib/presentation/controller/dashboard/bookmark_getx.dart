import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/presentation/controller/detail_surah/cubit/detail_surah_cubit.dart';
import 'package:quran_app/presentation/view/detail_surah/detail_surah_page.dart';

class BookmarkGetx extends GetxController {
  Rx<List<BookmarkModel>> bookmarks =
      Rx<List<BookmarkModel>>(<BookmarkModel>[]);
  RxInt nNomorAyat = 0.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    await databaseHelper
        .getAllBookmarks()
        .then((final List<BookmarkModel> value) {
      bookmarks.value = value;
    });
  }

  void onTapDelete(final BookmarkModel bookmarkModel) {
    databaseHelper.deleteBookmark(bookmarkModel.teksIndonesia);
    init();
  }

  void onTapShare(final BookmarkModel bookmarkModel) async {
    await Clipboard.setData(
      ClipboardData(
        text:
            '${bookmarkModel.namaLatin} : ${bookmarkModel.nomorSurah}\n${bookmarkModel.teksArab}\n${bookmarkModel.teksIndonesia}',
      ),
    ).then((final _) {
      Get.snackbar('Sukses', 'Teks berhasil disalin');
    });
  }

  void getDetailSurah(final BookmarkModel data) async {
    nNomorAyat.value = data.nomorAyat;
    final BuildContext context = Get.context!;
    await context.read<DetailSurahCubit>().getPosts(number: data.nomorSurah);
  }

  void onSuccesDetailSurah(final DetailEntity data) async {
    W.endwait();

    await C
        .to(() =>
            DetailSurahPage(detailEntity: data, indexTandai: nNomorAyat.value))
        .then((final _) => init());
  }
}

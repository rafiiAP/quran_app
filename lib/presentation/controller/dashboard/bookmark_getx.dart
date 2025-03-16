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
  DatabaseHelper dbHelper = DatabaseHelper();

  Rx<List<BookmarkModel>> bookmarks = Rx<List<BookmarkModel>>([]);
  var nNomorAyat = 0.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  init() {
    dbHelper.getAllBookmarks().then((value) {
      bookmarks.value = value;
    });
  }

  onTapDelete(BookmarkModel bookmarkModel) {
    dbHelper.deleteBookmark(bookmarkModel.teksIndonesia);
    init();
  }

  onTapShare(BookmarkModel bookmarkModel) {
    Clipboard.setData(
      ClipboardData(
        text:
            '${bookmarkModel.namaLatin} : ${bookmarkModel.nomorSurah}\n${bookmarkModel.teksArab}\n${bookmarkModel.teksIndonesia}',
      ),
    ).then((_) {
      Get.snackbar('Sukses', 'Teks berhasil disalin');
    });
  }

  getDetailSurah(BookmarkModel data) {
    nNomorAyat.value = data.nomorAyat;
    BuildContext context = Get.context!;
    context.read<DetailSurahCubit>().getPosts(number: data.nomorSurah);
  }

  onSuccesDetailSurah(DetailEntity data) {
    W.endwait();

    C.to(() => DetailSurahPage(detailEntity: data, index: nNomorAyat.value))!.then((_) => init());
  }
}

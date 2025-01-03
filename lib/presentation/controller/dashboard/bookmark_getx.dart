import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_bloc/detail_surah_bloc.dart';
import 'package:quran_app/presentation/view/detail_surah/detail_surah_page.dart';

class BookmarkGetx extends GetxController {
  DatabaseHelper dbHelper = DatabaseHelper();

  Rx<List<BookmarkModel>> bookmarks = Rx<List<BookmarkModel>>([]);

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
        text: '${bookmarkModel.teksArab}\n${bookmarkModel.teksIndonesia}',
      ),
    ).then((_) {
      Get.snackbar('Sukses', 'Teks berhasil disalin');
    });
  }

  getDetailSurah(BookmarkModel data) {
    BuildContext context = Get.context!;
    context.read<DetailSurahBloc>().add(DetailSurahEvent.getDetailSurah(data.nomorSurah));
  }

  onSuccesDetailSurah(DetailEntity data) {
    W.endwait();

    C.to(() => DetailSurahPage(detailEntity: data))!.then((_) => init());
  }
}

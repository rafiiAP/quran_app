import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/presentation/controller/dashboard/bookmark_getx.dart';
import 'package:quran_app/presentation/controller/detail_surah/cubit/detail_surah_cubit.dart';

class BookmarkPage extends StatelessWidget {
  BookmarkPage({super.key});

  final c = Get.put(BookmarkGetx());

  @override
  Widget build(BuildContext context) {
    c.init();
    return BlocListener<DetailSurahCubit, DetailSurahState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          loading: () => W.wait(),
          error: (message) {
            W.endwait();
            W.messageInfo(message: message);
          },
          success: (detailModel) => c.onSuccesDetailSurah(detailModel),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: W.title(text: 'Bookmark'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Obx(
          () => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: c.bookmarks.value.length,
            itemBuilder: (context, index) {
              BookmarkModel bookmarkModel = c.bookmarks.value[index];
              return InkWell(
                onTap: () {
                  c.getDetailSurah(bookmarkModel);
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: C.isDark(context)
                            ? colorConfig.bgBottom
                            : colorConfig.lightGrey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          W.textBody(
                            text:
                                '${bookmarkModel.namaLatin} : ${bookmarkModel.nomorSurah}',
                            fontWeight: FontWeight.w500,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              c.onTapShare(bookmarkModel);
                            },
                            child: Icon(
                              Icons.share,
                              color: colorConfig.primary,
                            ),
                          ),
                          W.paddingWidtht8(),
                          GestureDetector(
                            onTap: () {
                              c.onTapDelete(bookmarkModel);
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: colorConfig.primary,
                            ),
                          ),
                          W.paddingWidtht8(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              bookmarkModel.teksArab,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 2,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          W.paddingheight16(),
                          Text(
                            '${bookmarkModel.teksLatin}(${bookmarkModel.nomorAyat})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          W.paddingheight5(),
                          W.textBody(
                            text: bookmarkModel.teksIndonesia,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          W.paddingheight16(),
                          Divider(color: colorConfig.grey),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

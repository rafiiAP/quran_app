import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_getx.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:showcaseview/showcaseview.dart';

class DetailSurahPage extends StatelessWidget {
  final DetailEntity detailEntity;
  final int? indexTandai;

  const DetailSurahPage(
      {super.key, required this.detailEntity, this.indexTandai});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DetailSurahGetx(index: indexTandai));

    return ShowCaseWidget(builder: (context) {
      C.showCase(
        context: context,
        keys: [c.menuKey],
        cacheKey: config.cacheShowCaseDetail,
      );
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: W.title(text: detailEntity.namaLatin),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // cardSurah(),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemScrollController: c.itemScrollController,
                  itemCount: detailEntity.ayat.length,
                  itemBuilder: (context, index) {
                    int? tempIndex;
                    if (indexTandai != null) {
                      tempIndex = indexTandai! - 1;
                    } else {
                      tempIndex = 0;
                    }
                    AyatDetailEntity ayatDetailEntity =
                        detailEntity.ayat[index];

                    return InkWell(
                      onTap: () {
                        c.onTapList(context, ayatDetailEntity, detailEntity);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: C.isDark(context)
                                  ? colorConfig.bgBottom
                                  : colorConfig.lightGrey
                                      .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 13,
                                  backgroundColor: colorConfig.primary,
                                  child: W.textBody(
                                    text: ayatDetailEntity.nomorAyat.toString(),
                                    color: colorConfig.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    c.onTapList(context, ayatDetailEntity,
                                        detailEntity);
                                  },
                                  child: index == tempIndex
                                      ? Showcase(
                                          key: c.menuKey,
                                          description:
                                              'Tekan untuk melihat menu',
                                          child: Icon(
                                            Icons.menu_rounded,
                                            color: colorConfig.primary,
                                          ),
                                        )
                                      : Icon(
                                          Icons.menu_rounded,
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
                                    ayatDetailEntity.teksArab,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      height: 2,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                W.paddingheight16(),
                                Text(
                                  '${ayatDetailEntity.teksLatin} (${index + 1})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                W.paddingheight5(),
                                W.textBody(
                                  text:
                                      '${ayatDetailEntity.teksIndonesia} (${index + 1})',
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
              )
            ],
          ),
        ),
      );
    });
  }
}

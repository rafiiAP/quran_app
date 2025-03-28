import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_getx.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DetailSurahPage extends StatelessWidget {
  final DetailEntity detailEntity;
  final int? index;

  const DetailSurahPage({super.key, required this.detailEntity, this.index});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DetailSurahGetx(index: index));
    // c.toScrollIndex(index);

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
                // itemPositionsListener: c.itemPositionsListener,
                // initialAlignment: 0,
                // initialScrollIndex: 0,
                itemCount: detailEntity.ayat.length,
                itemBuilder: (context, index) {
                  AyatDetailEntity ayatDetailEntity = detailEntity.ayat[index];

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
                                : colorConfig.lightGrey.withValues(alpha: 0.3),
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
                                  c.onTapList(
                                      context, ayatDetailEntity, detailEntity);
                                },
                                child: Icon(
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 2,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              W.paddingheight16(),
                              Text(
                                ayatDetailEntity.teksLatin,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              W.paddingheight5(),
                              W.textBody(
                                text: ayatDetailEntity.teksIndonesia,
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
  }

  cardSurah() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [colorConfig.secondary, colorConfig.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          scale: 1.2,
          alignment: Alignment.bottomRight,
          opacity: 0.1,
          image: AssetImage(imageConfig.quran),
        ),
      ),
      child: Column(
        children: [
          W.textBody(
            text: detailEntity.namaLatin,
            color: colorConfig.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
          W.textBody(
            text: detailEntity.arti,
            color: colorConfig.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
              width: C.getWidth() * 0.4,
              child: Divider(
                color: colorConfig.white,
              )),
          W.textBody(
            text:
                '${detailEntity.tempatTurun} - ${detailEntity.jumlahAyat} Ayat',
            color: colorConfig.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

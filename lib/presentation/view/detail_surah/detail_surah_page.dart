import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_getx.dart';

class DetailSurahPage extends StatelessWidget {
  final DetailModel detailModel;
  DetailSurahPage({super.key, required this.detailModel});

  final c = Get.put(DetailSurahGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: W.title(text: detailModel.namaLatin!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            cardSurah(),
            ListView.builder(
              padding: const EdgeInsets.only(top: 32),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: detailModel.ayat!.length,
              itemBuilder: (context, index) {
                AyatModel ayatModel = detailModel.ayat![index];
                return InkWell(
                  onTap: () {
                    c.onTapList(context, ayatModel, detailModel);
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              C.isDark(context) ? AppColorConfig.bgBottom : AppColorConfig.lightGrey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: AppColorConfig.primary,
                              child: W.textBody(
                                text: ayatModel.nomorAyat.toString(),
                                color: AppColorConfig.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                c.onTapShare(ayatModel);
                              },
                              child: const Icon(
                                Icons.share,
                                color: AppColorConfig.primary,
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
                                ayatModel.teksArab!,
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
                              ayatModel.teksLatin!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            W.paddingheight5(),
                            W.textBody(
                              text: ayatModel.teksIndonesia!,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            W.paddingheight16(),
                            const Divider(color: AppColorConfig.grey),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
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
        gradient: const LinearGradient(
            colors: [AppColorConfig.secondary, AppColorConfig.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          scale: 1.2,
          alignment: Alignment.bottomRight,
          opacity: 0.1,
          image: AssetImage(MyImage.quran),
        ),
      ),
      child: Column(
        children: [
          W.textBody(
            text: detailModel.namaLatin!,
            color: AppColorConfig.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
          W.textBody(
            text: detailModel.arti!,
            color: AppColorConfig.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
              width: C.getWidth() * 0.4,
              child: const Divider(
                color: AppColorConfig.white,
              )),
          W.textBody(
            text: '${detailModel.tempatTurun!} - ${detailModel.jumlahAyat} Ayat',
            color: AppColorConfig.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

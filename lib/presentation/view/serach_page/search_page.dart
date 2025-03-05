import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/presentation/controller/serach/search_getx.dart';

class SearchPage extends StatelessWidget {
  final List<SurahEntity> vaSurah;
  SearchPage({super.key, required this.vaSurah});

  final c = Get.put(SearchGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            children: [
              W.input(
                controller: c.searchController,
                color: C.isDark(context) ? AppColorConfig.white : AppColorConfig.black,
                prefixIcon: Icon(Icons.search, color: AppColorConfig.grey.withValues(alpha: 0.4)),
                onChanged: (val) => c.onSearch(surahList: vaSurah, value: val),
              ),
              W.paddingheight16(),
              Expanded(
                child: Obx(
                  () => c.vaSearch.value.isEmpty && c.searchController.text.isNotEmpty
                      ? Container(
                          child: W.textBody(
                            text: 'Surah tidak ditemukan',
                          ),
                        )
                      : c.vaSearch.value.isEmpty
                          ? Container()
                          : ListView.builder(
                              itemCount: c.vaSearch.value.length,
                              itemBuilder: (context, index) {
                                SurahEntity surahEntity = c.vaSearch.value[index];
                                return listSurah(surahEntity);
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  listSurah(SurahEntity surahEntity) {
    return InkWell(
      onTap: () {
        c.getDetailSurah(surahEntity);
      },
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          W.paddingheight5(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      // alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            MyImage.borderNum,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: W.textBody(
                          text: surahEntity.nomor.toString(),
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    W.paddingWidtht16(),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          W.textBody(
                            text: surahEntity.namaLatin,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          W.textBody(
                            text: '${surahEntity.tempatTurun} - ${surahEntity.jumlahAyat} ayat',
                            fontWeight: FontWeight.w500,
                            color: AppColorConfig.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: W.textBody(
                  text: surahEntity.nama,
                  color: AppColorConfig.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          W.paddingheight5(),
          const Divider(
            color: AppColorConfig.grey,
          ),
        ],
      ),
    );
  }
}

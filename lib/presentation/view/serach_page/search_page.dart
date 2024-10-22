import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/presentation/controller/serach/search_getx.dart';

class SearchPage extends StatelessWidget {
  final List<SurahModel> vaSurah;
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
                prefixIcon: Icon(Icons.search, color: AppColorConfig.grey.withOpacity(0.4)),
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
                                SurahModel surahModel = c.vaSearch.value[index];
                                return listSurah(surahModel);
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

  listSurah(SurahModel surahModel) {
    return InkWell(
      onTap: () {
        c.getDetailSurah(surahModel);
      },
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          W.paddingheight5(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          MyImage.borderNum,
                        ),
                      ),
                    ),
                    child: W.textBody(
                      text: surahModel.nomor.toString(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  W.paddingWidtht16(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      W.textBody(
                        text: surahModel.namaLatin!,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      W.textBody(
                        text: '${surahModel.tempatTurun!} - ${surahModel.jumlahAyat!} ayat',
                        fontWeight: FontWeight.w500,
                        color: AppColorConfig.grey,
                      ),
                    ],
                  ),
                ],
              ),
              W.textBody(
                text: surahModel.nama!,
                color: AppColorConfig.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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

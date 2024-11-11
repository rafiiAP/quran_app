import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_bloc/get_surah_bloc.dart';
import 'package:quran_app/presentation/controller/dashboard/home_getx.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_bloc/detail_surah_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final c = Get.put(HomeGetx());

  @override
  Widget build(BuildContext context) {
    // c.init();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: W.title(text: 'Quran App'),
        actions: [
          IconButton(
            onPressed: () {
              c.toSearchPage();
            },
            icon: const Icon(
              CupertinoIcons.search_circle,
            ),
          ),
        ],
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Image.asset(
        //     MyImage.menu,
        //   ),
        // ),
      ),
      body: BlocListener<DetailSurahBloc, DetailSurahState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loading: () => W.wait(),
            error: (message) {
              W.endwait();
              W.messageInfo(message: message);
            },
            loaded: (detailModel) => c.onSuccesDetailSurah(detailModel),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              W.textBody(
                text: "Assalamu'alaikum",
                color: AppColorConfig.grey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              W.paddingheight5(),
              W.textBody(
                text: 'RAF',
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              W.paddingheight16(),
              cardLastRead(),
              W.paddingheight16(),
              W.paddingheight16(),
              BlocListener<GetSurahBloc, GetSurahState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    loading: () => W.wait(),
                    error: (message) => W.endwait(),
                    success: (surah) => c.onSuccesGetSurah(surah),
                  );
                },
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: c.surahList.value.length,
                    itemBuilder: (context, index) {
                      SurahModel surahModel = c.surahList.value[index];
                      return listSurah(surahModel);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  cardLastRead() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColorConfig.secondary, AppColorConfig.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(MyImage.bookCard),
                    W.paddingWidtht5(),
                    W.textBody(
                      text: 'Terakhir dibaca',
                      fontWeight: FontWeight.w500,
                      color: AppColorConfig.white,
                    ),
                  ],
                ),
                W.paddingheight16(),
                Obx(
                  () => W.textBody(
                    text: c.cNamaLatin.value,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColorConfig.white,
                  ),
                ),
                W.paddingheight5(),
                Obx(
                  () => W.textBody(
                    text: 'Ayat : ${c.nNomorAyat.value == 0 ? '-' : c.nNomorAyat.value}',
                    color: AppColorConfig.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -30,
            bottom: -30,
            child: Image.asset(
              MyImage.quran,
              width: C.getWidth() * 0.5,
            ),
          ),
        ],
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

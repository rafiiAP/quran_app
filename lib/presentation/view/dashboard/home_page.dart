import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/presentation/controller/dashboard/home_getx.dart';
import 'package:quran_app/presentation/controller/detail_surah/cubit/detail_surah_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeGetx());
    // LocalNotificationService.checkScheduledNotifications();
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
      ),
      body: Padding(
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
            cardLastRead(c),
            W.paddingheight16(),
            W.paddingheight16(),
            BlocConsumer<GetSurahCubit, GetSurahState>(
              listener: (context, state) {
                state.maybeWhen(
                    orElse: () {},
                    error: (message) => W.messageInfo(message: message),
                    success: (surah) => c.onSuccesGetSurah(surah));
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return Container();
                  },
                  loading: () {
                    return ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return loadList(c);
                      },
                    );
                  },
                  success: (surah) {
                    return BlocListener<DetailSurahCubit, DetailSurahState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          orElse: () {},
                          error: (message) {
                            W.messageInfo(message: message);
                          },
                          loading: () => W.wait(),
                          success: (detailModel) => c.onSuccesDetailSurah(detailModel),
                        );
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: surah.length,
                        itemBuilder: (context, index) {
                          SurahEntity surahEntity = surah[index];
                          return listSurah(c, surahEntity);
                        },
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  loadList(HomeGetx c) {
    return Column(
      children: [
        W.paddingheight5(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                W.shimmer(width: 40, height: 40),
                W.paddingWidtht16(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [W.shimmer(width: 200, height: 15), W.paddingheight5(), W.shimmer(width: 200, height: 15)],
                ),
              ],
            ),
            W.shimmer(width: 100, height: 30),
          ],
        ),
        W.paddingheight5(),
        const Divider(
          color: AppColorConfig.grey,
        ),
      ],
    );
  }

  cardLastRead(HomeGetx c) {
    return InkWell(
      onTap: () {
        c.toLastRead(index: c.nNomorSurah.value);
      },
      child: Container(
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
                      text:
                          'Surah : ${c.nNomorSurah.value == 0 ? '-' : c.nNomorSurah.value} , Ayat : ${c.nNomorAyat.value == 0 ? '-' : c.nNomorAyat.value}',
                      color: AppColorConfig.white,
                      fontWeight: FontWeight.w500,
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
      ),
    );
  }

  listSurah(HomeGetx c, SurahEntity surahEntity) {
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
                      child: Align(
                        child: W.textBody(
                          text: surahEntity.nomor.toString(),
                          fontWeight: FontWeight.w500,
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

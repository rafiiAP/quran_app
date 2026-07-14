import 'package:flutter/material.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_shimmer.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';

/// A single surah row in the surah list.
class SurahListItem extends StatelessWidget {
  const SurahListItem({
    super.key,
    required this.surah,
    required this.onTap,
  });

  final SurahEntity surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          appPadding.paddingheight5(),
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imageConfig.borderNum),
                        ),
                      ),
                      child: Align(
                        child: appText.textBody(
                          text: surah.nomor.toString(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    appPadding.paddingWidtht16(),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText.textBody(
                            text: surah.namaLatin,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          appText.textBody(
                            text:
                                '${surah.tempatTurun} - ${surah.jumlahAyat} ayat',
                            fontWeight: FontWeight.w500,
                            color: colorConfig.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: appText.textBody(
                  text: surah.nama,
                  color: colorConfig.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          appPadding.paddingheight5(),
          Divider(color: colorConfig.grey),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for a loading surah list item.
class SurahListItemShimmer extends StatelessWidget {
  const SurahListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appPadding.paddingheight5(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                appShimmer.shimmer(width: 40, height: 40),
                appPadding.paddingWidtht16(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appShimmer.shimmer(width: 200, height: 15),
                    appPadding.paddingheight5(),
                    appShimmer.shimmer(width: 200, height: 15),
                  ],
                ),
              ],
            ),
            appShimmer.shimmer(width: 100, height: 30),
          ],
        ),
        appPadding.paddingheight5(),
        Divider(color: colorConfig.grey),
      ],
    );
  }
}

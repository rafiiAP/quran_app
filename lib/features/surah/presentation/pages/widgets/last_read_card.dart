import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:showcaseview/showcaseview.dart';

/// Card showing the user's last-read position (surah name, number, ayat).
class LastReadCard extends StatelessWidget {
  const LastReadCard({
    super.key,
    required this.tandaiKey,
  });

  final GlobalKey tandaiKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final String namaLatin = state.maybeWhen(
          orElse: () => '',
          loaded: (namaLatin, _, __, ___) => namaLatin,
        );
        final int nomorSurah = state.maybeWhen(
          orElse: () => 0,
          loaded: (_, nomorSurah, __, ___) => nomorSurah,
        );
        final int nomorAyat = state.maybeWhen(
          orElse: () => 0,
          loaded: (_, __, nomorAyat, ___) => nomorAyat,
        );

        return Showcase(
          key: tandaiKey,
          description: 'Ketuk untuk ke halaman bacaan terakhir',
          child: InkWell(
            onTap: () => context.read<HomeCubit>().toLastRead(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorConfig.secondary, colorConfig.primary],
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
                            Image.asset(imageConfig.bookCard),
                            appPadding.paddingWidtht5(),
                            appText.textBody(
                              text: 'Terakhir dibaca',
                              fontWeight: FontWeight.w500,
                              color: colorConfig.white,
                            ),
                          ],
                        ),
                        appPadding.paddingheight16(),
                        appText.textBody(
                          text: namaLatin,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorConfig.white,
                        ),
                        appPadding.paddingheight5(),
                        appText.textBody(
                          text:
                              'Surah : ${nomorSurah == 0 ? '-' : nomorSurah} , Ayat : ${nomorAyat == 0 ? '-' : nomorAyat}',
                          color: colorConfig.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Image.asset(
                      imageConfig.quran,
                      width: MediaQuery.sizeOf(context).width * 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

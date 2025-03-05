import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_getx.dart';

class JadwalSholatView extends StatelessWidget {
  final JadwalSholatEntity data;
  final JadwalSholatGetx c;
  const JadwalSholatView({super.key, required this.data, required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: C.getHeight() * 0.20,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      alignment: Alignment.bottomLeft,
                      colorFilter: ColorFilter.mode(
                        AppColorConfig.white,
                        BlendMode.srcIn,
                      ),
                      scale: 3.5,
                      image: AssetImage(
                        MyImage.masjid,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorConfig.primary.withValues(
                          alpha: 0.2,
                        ),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        AppColorConfig.white,
                        AppColorConfig.primary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      W.textBody(
                        text: c.getSholatText(
                          data,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColorConfig.black,
                      ),
                      W.textBody(
                        text: c.getTimeText(data),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColorConfig.primary,
                      ),
                      W.paddingheight5(),
                      Obx(
                        () => W.textBody(
                          text: c.countdownText.value,
                          fontWeight: FontWeight.bold,
                          color: AppColorConfig.primary,
                        ),
                      ),
                      W.paddingheight16(),
                    ],
                  ),
                ),
              ),
              W.paddingWidtht16(),
              Expanded(
                child: Container(
                  height: C.getHeight() * 0.20,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      alignment: Alignment.bottomLeft,
                      colorFilter: ColorFilter.mode(
                        AppColorConfig.white,
                        BlendMode.srcIn,
                      ),
                      scale: 3.5,
                      image: AssetImage(
                        MyImage.masjid,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorConfig.primary.withValues(
                          alpha: 0.2,
                        ),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        AppColorConfig.white,
                        AppColorConfig.primary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      W.textBody(
                        text: 'Waktu Sholat Selanjutnya',
                        fontWeight: FontWeight.bold,
                        color: AppColorConfig.black,
                      ),
                      W.textBody(
                        text: c.getNextSholatText(
                          data,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppColorConfig.primary,
                        fontSize: 16,
                      ),
                      W.textBody(
                        text: c.getNextTime(data),
                        fontSize: 16,
                        color: AppColorConfig.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      W.paddingheight5(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
        W.paddingheight16(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColorConfig.primary),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Iconsax.location,
                    color: AppColorConfig.white,
                    size: 50,
                  ),
                  W.paddingWidtht16(),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => W.textBody(
                            text: c.city.value,
                            color: AppColorConfig.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Obx(
                          () => W.textBody(
                            text: c.timezone.value,
                            color: AppColorConfig.white,
                            fontSize: 18,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              W.paddingheight16(),
              Row(
                children: [
                  const Icon(
                    Iconsax.moon1,
                    color: AppColorConfig.white,
                  ),
                  W.paddingWidtht16(),
                  W.textBody(
                    text: 'Subuh',
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  W.textBody(
                    text: data.fajr,
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  W.paddingWidtht5(),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Iconsax.alarm,
                  //     color: AppColorConfig.white,
                  //   ),
                  // ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(
                    Iconsax.sun,
                    color: AppColorConfig.white,
                  ),
                  W.paddingWidtht16(),
                  W.textBody(
                    text: 'Zuhur',
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  W.textBody(
                    text: data.dhuhr,
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  W.paddingWidtht5(),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Iconsax.alarm,
                  //     color: AppColorConfig.white,
                  //   ),
                  // ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(
                    Iconsax.sun_1,
                    color: AppColorConfig.white,
                  ),
                  W.paddingWidtht16(),
                  W.textBody(
                    text: 'Asar',
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  W.textBody(
                    text: data.asr,
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  W.paddingWidtht5(),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Iconsax.alarm,
                  //     color: AppColorConfig.white,
                  //   ),
                  // ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(
                    Iconsax.sun_fog,
                    color: AppColorConfig.white,
                  ),
                  W.paddingWidtht16(),
                  W.textBody(
                    text: 'Maghrib',
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  W.textBody(
                    text: data.maghrib,
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  W.paddingWidtht5(),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Iconsax.alarm,
                  //     color: AppColorConfig.white,
                  //   ),
                  // ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(
                    Iconsax.moon5,
                    color: AppColorConfig.white,
                  ),
                  W.paddingWidtht16(),
                  W.textBody(
                    text: 'Isya',
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  W.textBody(
                    text: data.isha,
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                  W.paddingWidtht5(),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Iconsax.alarm,
                  //     color: AppColorConfig.white,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        W.paddingheight16(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColorConfig.primary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  W.textBody(
                    text: 'Sunrise',
                    color: AppColorConfig.white,
                  ),
                  W.paddingheight5(),
                  W.textBody(
                    text: data.sunrise,
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
                child: VerticalDivider(),
              ),
              Column(
                children: [
                  W.textBody(
                    text: 'Mid Night',
                    color: AppColorConfig.white,
                  ),
                  W.paddingheight5(),
                  W.textBody(
                    text: data.midnight,
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
                child: VerticalDivider(),
              ),
              Column(
                children: [
                  W.textBody(
                    text: 'Sunset',
                    color: AppColorConfig.white,
                  ),
                  W.paddingheight5(),
                  W.textBody(
                    text: data.sunset,
                    color: AppColorConfig.white,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

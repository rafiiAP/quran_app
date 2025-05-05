import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/model/set_notif_model.dart';

import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_getx.dart';

class LoadingSholatView extends StatelessWidget {
  const LoadingSholatView({super.key, required this.c});
  final JadwalSholatGetx c;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: C.getWidth(),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.bottomRight,
              colorFilter: ColorFilter.mode(
                colorConfig.white,
                BlendMode.srcIn,
              ),
              scale: 1,
              image: AssetImage(
                imageConfig.masjid,
              ),
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorConfig.primary.withValues(
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
            gradient: LinearGradient(
              colors: [
                colorConfig.white,
                colorConfig.primary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              W.shimmer(width: C.getWidth() * 0.5, height: 15),
              W.paddingheight5(),
              W.shimmer(width: C.getWidth() * 0.3, height: 15),
              W.paddingheight16(),
              W.shimmer(width: C.getWidth() * 0.4, height: 15),
              W.paddingheight5(),
              W.shimmer(width: C.getWidth() * 0.3, height: 15),
              W.paddingheight16(),
            ],
          ),
        ),
        W.paddingheight16(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorConfig.primary),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Iconsax.location,
                    color: colorConfig.white,
                    size: 40,
                  ),
                  W.paddingWidtht16(),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        W.shimmer(width: C.getWidth() * 0.7, height: 15),
                        W.paddingheight5(),
                        W.shimmer(width: C.getWidth() * 0.3, height: 15),
                      ],
                    ),
                  )
                ],
              ),
              W.paddingheight16(),
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    SetNotifModel data = c.vaJadwal[index];

                    return Row(
                      children: [
                        Icon(
                          data.iconsax,
                          color: colorConfig.white,
                        ),
                        W.paddingWidtht16(),
                        W.textBody(
                          text: data.title,
                          color: colorConfig.white,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        W.shimmer(width: C.getWidth() * 0.1, height: 15),
                        W.paddingWidtht5(),
                        IconButton(
                          onPressed: () {
                            c.setNotif(index, data);
                          },
                          icon: Obx(
                            () => Icon(
                              data.isAlarmSet.value
                                  ? Iconsax.alarm5
                                  : Iconsax.alarm,
                              color: colorConfig.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: c.vaJadwal.length,
                ),
              )
            ],
          ),
        ),
        W.paddingheight16(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorConfig.primary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Column(
                  children: [
                    W.textBody(
                      text: 'Sunrise',
                      color: colorConfig.white,
                      textAlign: TextAlign.center,
                    ),
                    W.paddingheight5(),
                    W.shimmer(width: C.getWidth() * 0.15, height: 15),
                  ],
                ),
              ),
              const SizedBox(
                height: 45,
                child: VerticalDivider(),
              ),
              Flexible(
                child: Column(
                  children: [
                    W.textBody(
                      text: 'Mid night',
                      color: colorConfig.white,
                      textAlign: TextAlign.center,
                    ),
                    W.paddingheight5(),
                    W.shimmer(width: C.getWidth() * 0.15, height: 15),
                  ],
                ),
              ),
              const SizedBox(
                height: 45,
                child: VerticalDivider(),
              ),
              Flexible(
                child: Column(
                  children: [
                    W.textBody(
                      text: 'Sunset',
                      color: colorConfig.white,
                      textAlign: TextAlign.center,
                    ),
                    W.paddingheight5(),
                    W.shimmer(width: C.getWidth() * 0.15, height: 15),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

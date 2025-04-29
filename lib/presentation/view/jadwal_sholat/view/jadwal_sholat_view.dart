import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_getx.dart';
import 'package:showcaseview/showcaseview.dart';

class JadwalSholatView extends StatelessWidget {
  final JadwalSholatEntity data;
  final JadwalSholatGetx c;
  const JadwalSholatView({super.key, required this.data, required this.c});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(builder: (context) {
      return ListView(
        children: [
          Container(
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
                W.textBody(
                  text: c.getSholatText(),
                  fontWeight: FontWeight.bold,
                  color: colorConfig.black,
                ),
                W.textBody(
                  text: c.getTimeText(),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorConfig.primary,
                ),
                W.paddingheight5(),
                Obx(
                  () => W.textBody(
                    text: c.countdownText.value,
                    fontWeight: FontWeight.bold,
                    color: colorConfig.primary,
                  ),
                ),
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
                          Obx(
                            () => W.textBody(
                              text: c.city.value,
                              color: colorConfig.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Obx(
                            () => W.textBody(
                              text: c.timezone.value,
                              color: colorConfig.white,
                              fontSize: 16,
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
                          W.textBody(
                            text: "${data.hour}:${data.minute}",
                            color: colorConfig.white,
                            fontWeight: FontWeight.w600,
                          ),
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
                      W.textBody(
                        text: data.sunrise,
                        color: colorConfig.white,
                        fontWeight: FontWeight.w600,
                      ),
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
                      W.textBody(
                        text: data.midnight,
                        color: colorConfig.white,
                        fontWeight: FontWeight.w600,
                      ),
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
                      W.textBody(
                        text: data.sunset,
                        color: colorConfig.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}

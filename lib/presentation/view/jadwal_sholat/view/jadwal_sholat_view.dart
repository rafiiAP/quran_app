import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:showcaseview/showcaseview.dart';

class JadwalSholatView extends StatelessWidget {
  const JadwalSholatView({
    super.key,
    required this.city,
    required this.timezone,
    required this.countdownText,
    required this.sholatText,
    required this.timeText,
    required this.jadwalList,
    required this.data,
    required this.onToggleNotif,
  });

  final String city;
  final String timezone;
  final String countdownText;
  final String sholatText;
  final String timeText;
  final List<SetNotifModel> jadwalList;
  final JadwalSholatEntity data;
  final void Function(int index, SetNotifModel model) onToggleNotif;

  @override
  Widget build(final BuildContext context) {
    return ShowCaseWidget(
      builder: (final BuildContext context) {
        return ListView(
          children: <Widget>[
            // ── Countdown card ──────────────────────────────────────────────
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
                  image: AssetImage(imageConfig.masjid),
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorConfig.primary.withValues(alpha: 0.2),
                    offset: const Offset(5.0, 5.0),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
                gradient: LinearGradient(
                  colors: <Color>[
                    colorConfig.white,
                    colorConfig.primary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  W.textBody(
                    text: sholatText,
                    fontWeight: FontWeight.bold,
                    color: colorConfig.black,
                  ),
                  W.textBody(
                    text: timeText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorConfig.primary,
                  ),
                  W.paddingheight5(),
                  W.textBody(
                    text: countdownText,
                    fontWeight: FontWeight.bold,
                    color: colorConfig.primary,
                  ),
                  W.paddingheight16(),
                ],
              ),
            ),
            W.paddingheight16(),

            // ── Prayer schedule card ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorConfig.primary,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Iconsax.location,
                        color: colorConfig.white,
                        size: 40,
                      ),
                      W.paddingWidtht16(),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            W.textBody(
                              text: city,
                              color: colorConfig.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            W.textBody(
                              text: timezone,
                              color: colorConfig.white,
                              fontSize: 16,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  W.paddingheight16(),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jadwalList.length,
                    separatorBuilder: (final BuildContext _, final int __) =>
                        const Divider(),
                    itemBuilder: (final BuildContext context, final int index) {
                      final SetNotifModel item = jadwalList[index];
                      return Row(
                        children: <Widget>[
                          Icon(item.iconsax, color: colorConfig.white),
                          W.paddingWidtht16(),
                          W.textBody(
                            text: item.title,
                            color: colorConfig.white,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          W.textBody(
                            text:
                                '${item.hour.toString().padLeft(2, '0')}:${item.minute.toString().padLeft(2, '0')}',
                            color: colorConfig.white,
                            fontWeight: FontWeight.w600,
                          ),
                          W.paddingWidtht5(),
                          IconButton(
                            onPressed: () => onToggleNotif(index, item),
                            icon: Icon(
                              item.isAlarmSet ? Iconsax.alarm5 : Iconsax.alarm,
                              color: colorConfig.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            W.paddingheight16(),

            // ── Sunrise / Midnight / Sunset card ───────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorConfig.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      children: <Widget>[
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
                  const SizedBox(height: 45, child: VerticalDivider()),
                  Flexible(
                    child: Column(
                      children: <Widget>[
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
                  const SizedBox(height: 45, child: VerticalDivider()),
                  Flexible(
                    child: Column(
                      children: <Widget>[
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
            ),
          ],
        );
      },
    );
  }
}

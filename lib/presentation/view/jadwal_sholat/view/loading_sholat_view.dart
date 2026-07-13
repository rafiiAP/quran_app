import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/model/set_notif_model.dart';

class LoadingSholatView extends StatelessWidget {
  const LoadingSholatView({super.key, required this.jadwalList});

  final List<SetNotifModel> jadwalList;

  @override
  Widget build(final BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Column(
      children: <Widget>[
        // ── Skeleton countdown card ───────────────────────────────────────
        Container(
          width: screenWidth,
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
              W.shimmer(width: screenWidth * 0.5, height: 15),
              W.paddingheight5(),
              W.shimmer(width: screenWidth * 0.3, height: 15),
              W.paddingheight16(),
              W.shimmer(width: screenWidth * 0.4, height: 15),
              W.paddingheight5(),
              W.shimmer(width: screenWidth * 0.3, height: 15),
              W.paddingheight16(),
            ],
          ),
        ),
        W.paddingheight16(),

        // ── Skeleton prayer schedule card ────────────────────────────────
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
                        W.shimmer(width: screenWidth * 0.7, height: 15),
                        W.paddingheight5(),
                        W.shimmer(width: screenWidth * 0.3, height: 15),
                      ],
                    ),
                  ),
                ],
              ),
              W.paddingheight16(),
              if (jadwalList.isNotEmpty)
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
                        W.shimmer(width: screenWidth * 0.1, height: 15),
                        W.paddingWidtht5(),
                        IconButton(
                          onPressed: () {},
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

        // ── Skeleton sunrise / midnight / sunset card ─────────────────────
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
                    W.shimmer(width: screenWidth * 0.15, height: 15),
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
                    W.shimmer(width: screenWidth * 0.15, height: 15),
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
                    W.shimmer(width: screenWidth * 0.15, height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

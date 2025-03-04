import 'package:flutter/material.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';

class LoadingSholatView extends StatelessWidget {
  const LoadingSholatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColorConfig.primary.withValues(
                    alpha: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    W.shimmer(width: 100, height: 15),
                    W.paddingheight5(),
                    W.shimmer(width: 100, height: 15),
                    W.paddingheight16(),
                    W.shimmer(width: 150, height: 20),
                    W.paddingheight5(),
                    W.shimmer(width: 100, height: 15),
                    W.paddingheight16(),
                  ],
                ),
              ),
            ),
            W.paddingWidtht16(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColorConfig.primary.withValues(
                    alpha: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    W.shimmer(width: 100, height: 15),
                    W.paddingheight5(),
                    W.shimmer(width: 100, height: 15),
                    W.paddingheight16(),
                    W.shimmer(width: 150, height: 20),
                    W.paddingheight5(),
                    W.shimmer(width: 100, height: 15),
                    W.paddingheight16(),
                  ],
                ),
              ),
            ),
          ],
        ),
        W.paddingheight16(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColorConfig.primary.withValues(
              alpha: 0.5,
            ),
          ),
          child: Row(
            children: [
              W.shimmer(width: 40, height: 40),
              const Spacer(),
              Column(
                children: [
                  W.shimmer(width: 100, height: 15),
                  W.paddingheight5(),
                  W.shimmer(width: 100, height: 15),
                ],
              ),
              const SizedBox(
                height: 45,
                child: VerticalDivider(),
              ),
              Column(
                children: [
                  W.shimmer(width: 100, height: 15),
                  W.paddingheight5(),
                  W.shimmer(width: 100, height: 15),
                ],
              ),
              const Spacer(),
              W.shimmer(width: 40, height: 40),
            ],
          ),
        ),
        W.paddingheight16(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColorConfig.primary.withValues(
              alpha: 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  W.shimmer(width: 15, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 100, height: 15),
                  const Spacer(),
                  W.shimmer(width: 100, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 15, height: 15),
                ],
              ),
              W.paddingheight8(),
              const Divider(),
              Row(
                children: [
                  W.shimmer(width: 15, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 100, height: 15),
                  const Spacer(),
                  W.shimmer(width: 100, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 15, height: 15),
                ],
              ),
              W.paddingheight8(),
              const Divider(),
              Row(
                children: [
                  W.shimmer(width: 15, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 100, height: 15),
                  const Spacer(),
                  W.shimmer(width: 100, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 15, height: 15),
                ],
              ),
              W.paddingheight8(),
              const Divider(),
              Row(
                children: [
                  W.shimmer(width: 15, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 100, height: 15),
                  const Spacer(),
                  W.shimmer(width: 100, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 15, height: 15),
                ],
              ),
              W.paddingheight8(),
              const Divider(),
              W.paddingheight8(),
              Row(
                children: [
                  W.shimmer(width: 15, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 100, height: 15),
                  const Spacer(),
                  W.shimmer(width: 100, height: 15),
                  W.paddingWidtht5(),
                  W.shimmer(width: 15, height: 15),
                ],
              ),
            ],
          ),
        ),
        W.paddingheight16(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColorConfig.primary.withValues(
              alpha: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  W.shimmer(width: 100, height: 15),
                  W.paddingheight5(),
                  W.shimmer(width: 100, height: 15),
                ],
              ),
              const SizedBox(
                height: 45,
                child: VerticalDivider(),
              ),
              Column(
                children: [
                  W.shimmer(width: 100, height: 15),
                  W.paddingheight5(),
                  W.shimmer(width: 100, height: 15),
                ],
              ),
              const SizedBox(
                height: 45,
                child: VerticalDivider(),
              ),
              Column(
                children: [
                  W.shimmer(width: 100, height: 15),
                  W.paddingheight5(),
                  W.shimmer(width: 100, height: 15),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

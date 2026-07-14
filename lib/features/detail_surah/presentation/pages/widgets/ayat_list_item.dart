import 'package:flutter/material.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:showcaseview/showcaseview.dart';

/// A single ayat item in the detail surah list.
class AyatListItem extends StatelessWidget {
  const AyatListItem({
    super.key,
    required this.ayat,
    required this.index,
    required this.isShowcaseTarget,
    required this.menuKey,
    required this.onTap,
    required this.onMenuTap,
  });

  final AyatDetailEntity ayat;
  final int index;
  final bool isShowcaseTarget;
  final GlobalKey menuKey;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          _buildHeader(context),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? colorConfig.bgBottom
            : colorConfig.lightGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: colorConfig.primary,
            child: appText.textBody(
              text: ayat.nomorAyat.toString(),
              color: colorConfig.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onMenuTap,
            child: isShowcaseTarget
                ? Showcase(
                    key: menuKey,
                    description: 'Tekan untuk melihat menu',
                    child: Icon(
                      Icons.menu_rounded,
                      color: colorConfig.primary,
                    ),
                  )
                : Icon(
                    Icons.menu_rounded,
                    color: colorConfig.primary,
                  ),
          ),
          appPadding.paddingWidtht8(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              ayat.teksArab,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          appPadding.paddingheight16(),
          Text(
            '${ayat.teksLatin} (${index + 1})',
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          appPadding.paddingheight5(),
          appText.textBody(
            text: '${ayat.teksIndonesia} (${index + 1})',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          appPadding.paddingheight16(),
          Divider(color: colorConfig.grey),
        ],
      ),
    );
  }
}

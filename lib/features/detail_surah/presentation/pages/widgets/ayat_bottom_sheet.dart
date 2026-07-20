import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/cache_keys.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/services/showcase_service.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_page_cubit/detail_surah_page_cubit.dart';
import 'package:showcaseview/showcaseview.dart';

/// Shows the bottom sheet with actions: Tandai, Bookmark, Salin.
void showAyatBottomSheet({
  required BuildContext context,
  required AyatDetailEntity ayat,
  required DetailEntity detail,
  required GlobalKey btnTandaiKey,
  required GlobalKey btnBookmarkKey,
  required GlobalKey btnShareKey,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final showcaseService = locator<ShowcaseService>();
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: isDark ? colorConfig.bgBottom : colorConfig.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (bottomSheetContext) {
      return ShowCaseWidget(
        builder: (showcaseContext) {
          // Trigger showcase via post-frame to avoid calling
          // showcaseService inside the synchronous build phase.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!showcaseContext.mounted) return;
            showcaseService.showCase(
              context: showcaseContext,
              keys: [btnTandaiKey, btnBookmarkKey, btnShareKey],
              cacheKey: CacheKeys.showCaseBottomDetail,
            );
          });
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              appPadding.paddingheight16(),
              Showcase(
                key: btnTandaiKey,
                description: 'Tandai sebagai bacaan terakhir',
                child: ListTile(
                  leading: Icon(
                    Icons.local_attraction_outlined,
                    color: colorConfig.primary,
                  ),
                  title: appText.textBody(
                    text: 'Tandai sebagai bacaan terakhir',
                  ),
                  onTap: () {
                    context.pop();
                    context.read<DetailSurahPageCubit>().markAsLastRead(
                          namaLatin: detail.namaLatin,
                          nomorSurah: detail.nomor,
                          nomorAyat: ayat.nomorAyat,
                        );
                  },
                ),
              ),
              const Divider(),
              Showcase(
                key: btnBookmarkKey,
                description: 'Simpan ke bookmark',
                child: ListTile(
                  leading: Icon(
                    Icons.bookmark_add_outlined,
                    color: colorConfig.primary,
                  ),
                  title: appText.textBody(text: 'Simpan ke bookmark'),
                  onTap: () {
                    context.pop();
                    context.read<DetailSurahPageCubit>().saveBookmark(
                          ayat: ayat,
                          detail: detail,
                        );
                  },
                ),
              ),
              const Divider(),
              Showcase(
                key: btnShareKey,
                description: 'Salin ke clipboard',
                child: ListTile(
                  leading: Icon(
                    Icons.add_link,
                    color: colorConfig.primary,
                  ),
                  title: appText.textBody(text: 'Salin'),
                  onTap: () {
                    context.pop();
                    final text =
                        context.read<DetailSurahPageCubit>().formatCopyText(
                              ayat: ayat,
                              detail: detail,
                            );
                    final messenger = ScaffoldMessenger.of(context);
                    Clipboard.setData(ClipboardData(text: text)).then((_) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Teks berhasil disalin'),
                        ),
                      );
                    });
                  },
                ),
              ),
              appPadding.paddingheight16(),
              appPadding.paddingheight16(),
            ],
          );
        },
      );
    },
  );
}

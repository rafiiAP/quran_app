import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/core/widgets/app_button.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/cache_keys.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/services/showcase_service.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_cubit/detail_surah_cubit.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_page_cubit/detail_surah_page_cubit.dart';
import 'package:quran_app/features/detail_surah/presentation/pages/widgets/ayat_bottom_sheet.dart';
import 'package:quran_app/features/detail_surah/presentation/pages/widgets/ayat_list_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:showcaseview/showcaseview.dart';

class DetailSurahPage extends StatefulWidget {
  final int nomor;
  final int? indexTandai;

  const DetailSurahPage({
    super.key,
    required this.nomor,
    this.indexTandai,
  });

  @override
  State<DetailSurahPage> createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends State<DetailSurahPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();

  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _btnTandaiKey = GlobalKey();
  final GlobalKey _btnBookmarkKey = GlobalKey();
  final GlobalKey _btnShareKey = GlobalKey();

  bool _hasScrolled = false;
  bool _hasShownShowcase = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DetailSurahCubit>().getPosts(number: widget.nomor);
    });
  }

  void _scrollToIndex(int? index) {
    if (index == null) return;
    final targetIndex = index - 1;
    if (targetIndex < 0) return;
    if (_itemScrollController.isAttached) {
      _itemScrollController.jumpTo(index: targetIndex);
    }
  }

  void _triggerShowcase(BuildContext showcaseContext) {
    if (_hasShownShowcase) return;
    _hasShownShowcase = true;
    // Showcase is triggered once after the success state is reached.
    // Using addPostFrameCallback ensures the showcase widgets are mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      locator<ShowcaseService>().showCase(
        context: showcaseContext,
        keys: [_menuKey],
        cacheKey: CacheKeys.showCaseDetail,
      );
    });
  }

  void _onTapAyat(
    BuildContext context,
    AyatDetailEntity ayat,
    DetailEntity detail,
  ) {
    showAyatBottomSheet(
      context: context,
      ayat: ayat,
      detail: detail,
      btnTandaiKey: _btnTandaiKey,
      btnBookmarkKey: _btnBookmarkKey,
      btnShareKey: _btnShareKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailSurahPageCubit, DetailSurahPageState>(
      listener: (context, pageState) {
        pageState.maybeWhen(
          actionCompleted: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            context.read<DetailSurahPageCubit>().clearLastAction();
          },
          orElse: () {},
        );
      },
      child: ShowCaseWidget(
        builder: (showcaseContext) {
          return BlocConsumer<DetailSurahCubit, DetailSurahState>(
            listener: (context, state) {
              state.maybeWhen(
                success: (data) {
                  if (!_hasScrolled) {
                    _hasScrolled = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToIndex(widget.indexTandai);
                    });
                  }
                  // Trigger showcase once after first successful load
                  _triggerShowcase(showcaseContext);
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => _buildScaffold(
                  context: context,
                  title: '',
                  body: const Center(child: CircularProgressIndicator()),
                ),
                loading: () => _buildScaffold(
                  context: context,
                  title: '',
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (message) => _buildScaffold(
                  context: context,
                  title: 'Error',
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        appText.textBody(text: message),
                        appPadding.paddingheight16(),
                        appButton.button(
                          onPressed: () => context
                              .read<DetailSurahCubit>()
                              .getPosts(number: widget.nomor),
                          child: appText.textBody(
                            text: 'Coba lagi',
                            color: colorConfig.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                success: (detail) {
                  final int tempIndex =
                      widget.indexTandai != null ? widget.indexTandai! - 1 : 0;

                  return _buildScaffold(
                    context: context,
                    title: detail.namaLatin,
                    body: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ScrollablePositionedList.builder(
                        itemScrollController: _itemScrollController,
                        itemCount: detail.ayat.length,
                        itemBuilder: (context, index) {
                          final ayat = detail.ayat[index];
                          return AyatListItem(
                            ayat: ayat,
                            index: index,
                            isShowcaseTarget: index == tempIndex,
                            menuKey: _menuKey,
                            onTap: () => _onTapAyat(context, ayat, detail),
                            onMenuTap: () => _onTapAyat(context, ayat, detail),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScaffold({
    required BuildContext context,
    required String title,
    required Widget body,
  }) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: appText.title(text: title),
      ),
      body: body,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/presentation/controller/detail_surah/cubit/detail_surah_cubit.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_page_cubit/detail_surah_page_cubit.dart';
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

  // GlobalKeys kept as widget-local fields (requirement 10)
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _btnTandaiKey = GlobalKey();
  final GlobalKey _btnBookmarkKey = GlobalKey();
  final GlobalKey _btnShareKey = GlobalKey();

  bool _hasScrolled = false;

  @override
  void initState() {
    super.initState();
    // Trigger data fetch after first frame so context.read is safe
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

  void _onTapList(
      BuildContext context, AyatDetailEntity ayat, DetailEntity detail) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          C.isDark(context) ? colorConfig.bgBottom : colorConfig.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (bottomSheetContext) {
        return ShowCaseWidget(builder: (showcaseContext) {
          C.showCase(
            context: showcaseContext,
            keys: [_btnTandaiKey, _btnBookmarkKey, _btnShareKey],
            cacheKey: config.cacheShowCaseBottomDetail,
          );
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              W.paddingheight16(),
              Showcase(
                key: _btnTandaiKey,
                description: 'Tandai sebagai bacaan terakhir',
                child: ListTile(
                  leading: Icon(
                    Icons.local_attraction_outlined,
                    color: colorConfig.primary,
                  ),
                  title: W.textBody(text: 'Tandai sebagai bacaan terakhir'),
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
                key: _btnBookmarkKey,
                description: 'Simpan ke bookmark',
                child: ListTile(
                  leading: Icon(
                    Icons.bookmark_add_outlined,
                    color: colorConfig.primary,
                  ),
                  title: W.textBody(text: 'Simpan ke bookmark'),
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
                key: _btnShareKey,
                description: 'Salin ke clipboard',
                child: ListTile(
                  leading: Icon(
                    Icons.add_link,
                    color: colorConfig.primary,
                  ),
                  title: W.textBody(text: 'Salin'),
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
              W.paddingheight16(),
              W.paddingheight16(),
            ],
          );
        });
      },
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
          },
          orElse: () {},
        );
      },
      child: ShowCaseWidget(builder: (showcaseContext) {
        return BlocConsumer<DetailSurahCubit, DetailSurahState>(
          listener: (context, state) {
            state.maybeWhen(
              success: (data) {
                // Auto-scroll to indexTandai once on success
                if (!_hasScrolled) {
                  _hasScrolled = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToIndex(widget.indexTandai);
                  });
                }
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => _buildScaffold(
                context: context,
                showcaseContext: showcaseContext,
                title: '',
                body: const Center(child: CircularProgressIndicator()),
              ),
              loading: () => _buildScaffold(
                context: context,
                showcaseContext: showcaseContext,
                title: '',
                body: const Center(child: CircularProgressIndicator()),
              ),
              error: (message) => _buildScaffold(
                context: context,
                showcaseContext: showcaseContext,
                title: 'Error',
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      W.textBody(text: message),
                      W.paddingheight16(),
                      W.button(
                        onPressed: () => context
                            .read<DetailSurahCubit>()
                            .getPosts(number: widget.nomor),
                        child: W.textBody(
                          text: 'Coba lagi',
                          color: colorConfig.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              success: (detail) {
                C.showCase(
                  context: showcaseContext,
                  keys: [_menuKey],
                  cacheKey: config.cacheShowCaseDetail,
                );

                final int tempIndex =
                    widget.indexTandai != null ? widget.indexTandai! - 1 : 0;

                return _buildScaffold(
                  context: context,
                  showcaseContext: showcaseContext,
                  title: detail.namaLatin,
                  body: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _itemScrollController,
                            itemCount: detail.ayat.length,
                            itemBuilder: (context, index) {
                              final AyatDetailEntity ayat = detail.ayat[index];

                              return InkWell(
                                onTap: () => _onTapList(context, ayat, detail),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: C.isDark(context)
                                            ? colorConfig.bgBottom
                                            : colorConfig.lightGrey
                                                .withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 13,
                                            backgroundColor:
                                                colorConfig.primary,
                                            child: W.textBody(
                                              text: ayat.nomorAyat.toString(),
                                              color: colorConfig.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => _onTapList(
                                                context, ayat, detail),
                                            child: index == tempIndex
                                                ? Showcase(
                                                    key: _menuKey,
                                                    description:
                                                        'Tekan untuk melihat menu',
                                                    child: Icon(
                                                      Icons.menu_rounded,
                                                      color:
                                                          colorConfig.primary,
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.menu_rounded,
                                                    color: colorConfig.primary,
                                                  ),
                                          ),
                                          W.paddingWidtht8(),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          W.paddingheight16(),
                                          Text(
                                            '${ayat.teksLatin} (${index + 1})',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          W.paddingheight5(),
                                          W.textBody(
                                            text:
                                                '${ayat.teksIndonesia} (${index + 1})',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          W.paddingheight16(),
                                          Divider(color: colorConfig.grey),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildScaffold({
    required BuildContext context,
    required BuildContext showcaseContext,
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
        title: W.title(text: title),
      ),
      body: body,
    );
  }
}

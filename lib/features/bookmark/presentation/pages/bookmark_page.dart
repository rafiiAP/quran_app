import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/core/widgets/app_shimmer.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/features/bookmark/presentation/cubits/bookmark_cubit/bookmark_cubit.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookmarkCubit>().loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookmarkCubit, BookmarkState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          navigateToDetail: (nomorSurah, nomorAyat) {
            context.push('/detail-surah/$nomorSurah?ayat=$nomorAyat').then((_) {
              if (context.mounted) {
                context.read<BookmarkCubit>().loadBookmarks();
              }
            });
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: appText.title(text: 'Bookmark'),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            loading: () => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: appShimmer.shimmer(width: double.infinity, height: 120),
              ),
            ),
            loaded: (bookmarks) {
              if (bookmarks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 64,
                        color: colorConfig.grey,
                      ),
                      appPadding.paddingheight16(),
                      appText.textBody(
                        text: 'Belum ada bookmark',
                        color: colorConfig.grey,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final BookmarkModel bookmark = bookmarks[index];
                  return InkWell(
                    onTap: () {
                      context.read<BookmarkCubit>().navigateToDetail(bookmark);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? colorConfig.bgBottom
                                : colorConfig.lightGrey.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              appText.textBody(
                                text:
                                    '${bookmark.namaLatin} : ${bookmark.nomorSurah}',
                                fontWeight: FontWeight.w500,
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  final copyText = context
                                      .read<BookmarkCubit>()
                                      .formatCopyText(bookmark);
                                  await Clipboard.setData(
                                    ClipboardData(text: copyText),
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Berhasil disalin'),
                                      ),
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.share,
                                  color: colorConfig.primary,
                                ),
                              ),
                              appPadding.paddingWidtht8(),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<BookmarkCubit>()
                                      .deleteBookmark(bookmark);
                                },
                                child: Icon(
                                  Icons.delete_outline,
                                  color: colorConfig.primary,
                                ),
                              ),
                              appPadding.paddingWidtht8(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  bookmark.teksArab,
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
                                '${bookmark.teksLatin} (${bookmark.nomorAyat})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              appPadding.paddingheight5(),
                              appText.textBody(
                                text:
                                    '${bookmark.teksIndonesia} (${bookmark.nomorAyat})',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              appPadding.paddingheight16(),
                              Divider(color: colorConfig.grey),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

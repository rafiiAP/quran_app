import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/presentation/controller/dashboard/home_cubit/home_cubit.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey tandaiKey = GlobalKey();
  final GlobalKey helpKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Trigger surah list fetch on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GetSurahCubit>().getPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetSurahCubit, GetSurahState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          error: (message) => W.messageInfo(message: message),
          success: (surah) => context.read<HomeCubit>().setSurahList(surah),
        );
      },
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            navigateToDetail: (nomorSurah, indexTandai) {
              final route = indexTandai != null
                  ? '/detail-surah/$nomorSurah?ayat=$indexTandai'
                  : '/detail-surah/$nomorSurah';
              context.push(route).then((_) {
                if (context.mounted) {
                  context.read<HomeCubit>().refreshLastRead();
                }
              });
            },
            showMessage: (message) => W.messageInfo(message: message),
          );
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: W.title(text: 'Quran App'),
              actions: [
                IconButton(
                  onPressed: () => context.push('/search'),
                  icon: const Icon(Icons.search_rounded),
                ),
              ],
            ),
            floatingActionButton: Showcase(
              key: helpKey,
              description: 'Ketuk untuk menampilkan panduan',
              child: FloatingActionButton(
                child: const Icon(Icons.help_outline_rounded),
                onPressed: () {
                  C.showCase(
                    context: context,
                    cacheKey: config.cacheShowCase,
                    keys: [tandaiKey],
                    isShowHelp: true,
                  );
                },
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      W.paddingheight16(),
                      _cardLastRead(context, state),
                      W.paddingheight16(),
                      W.paddingheight16(),
                      _buildSurahList(context, state),
                    ],
                  ),
                ),
                Builder(
                  builder: (innerContext) {
                    C.showCase(
                      context: innerContext,
                      cacheKey: config.cacheShowCase,
                      keys: [helpKey, tandaiKey],
                    );
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSurahList(BuildContext context, HomeState state) {
    return BlocBuilder<GetSurahCubit, GetSurahState>(
      builder: (context, getSurahState) {
        return getSurahState.maybeWhen(
          orElse: () => Container(),
          loading: () => ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _loadList(),
          ),
          success: (surah) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: surah.length,
            itemBuilder: (context, index) {
              final surahEntity = surah[index];
              return _listSurah(context, surahEntity);
            },
          ),
        );
      },
    );
  }

  Widget _loadList() {
    return Column(
      children: [
        W.paddingheight5(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                W.shimmer(width: 40, height: 40),
                W.paddingWidtht16(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    W.shimmer(width: 200, height: 15),
                    W.paddingheight5(),
                    W.shimmer(width: 200, height: 15),
                  ],
                ),
              ],
            ),
            W.shimmer(width: 100, height: 30),
          ],
        ),
        W.paddingheight5(),
        Divider(color: colorConfig.grey),
      ],
    );
  }

  Widget _cardLastRead(BuildContext context, HomeState state) {
    final String namaLatin = state.maybeWhen(
      orElse: () => '',
      loaded: (namaLatin, _, __, ___) => namaLatin,
    );
    final int nomorSurah = state.maybeWhen(
      orElse: () => 0,
      loaded: (_, nomorSurah, __, ___) => nomorSurah,
    );
    final int nomorAyat = state.maybeWhen(
      orElse: () => 0,
      loaded: (_, __, nomorAyat, ___) => nomorAyat,
    );

    return Showcase(
      key: tandaiKey,
      description: 'Ketuk untuk ke halaman bacaan terakhir',
      child: InkWell(
        onTap: () => context.read<HomeCubit>().toLastRead(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorConfig.secondary, colorConfig.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(imageConfig.bookCard),
                        W.paddingWidtht5(),
                        W.textBody(
                          text: 'Terakhir dibaca',
                          fontWeight: FontWeight.w500,
                          color: colorConfig.white,
                        ),
                      ],
                    ),
                    W.paddingheight16(),
                    W.textBody(
                      text: namaLatin,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorConfig.white,
                    ),
                    W.paddingheight5(),
                    W.textBody(
                      text:
                          'Surah : ${nomorSurah == 0 ? '-' : nomorSurah} , Ayat : ${nomorAyat == 0 ? '-' : nomorAyat}',
                      color: colorConfig.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -30,
                bottom: -30,
                child: Image.asset(
                  imageConfig.quran,
                  width: MediaQuery.sizeOf(context).width * 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listSurah(BuildContext context, SurahEntity surahEntity) {
    return InkWell(
      onTap: () => context.read<HomeCubit>().getDetailSurah(surahEntity),
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          W.paddingheight5(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imageConfig.borderNum),
                        ),
                      ),
                      child: Align(
                        child: W.textBody(
                          text: surahEntity.nomor.toString(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    W.paddingWidtht16(),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          W.textBody(
                            text: surahEntity.namaLatin,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          W.textBody(
                            text:
                                '${surahEntity.tempatTurun} - ${surahEntity.jumlahAyat} ayat',
                            fontWeight: FontWeight.w500,
                            color: colorConfig.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: W.textBody(
                  text: surahEntity.nama,
                  color: colorConfig.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          W.paddingheight5(),
          Divider(color: colorConfig.grey),
        ],
      ),
    );
  }
}

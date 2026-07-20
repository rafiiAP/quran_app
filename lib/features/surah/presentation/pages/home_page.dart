import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/core/widgets/app_bottomsheet.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/services/showcase_service.dart';
import 'package:quran_app/features/surah/domain/usecases/get_surah_usecase.dart';
import 'package:quran_app/features/surah/presentation/cubits/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/features/surah/presentation/pages/widgets/last_read_card.dart';
import 'package:quran_app/features/surah/presentation/pages/widgets/surah_list_item.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.getSurahCubit});

  /// Optional cubit for testing. If null, creates one from the service locator.
  final GetSurahCubit? getSurahCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetSurahCubit>(
      create: (_) =>
          getSurahCubit ?? GetSurahCubit(usecase: locator<GetSurahUseCase>()),
      child: const _HomePageBody(),
    );
  }
}

class _HomePageBody extends StatefulWidget {
  const _HomePageBody();

  @override
  State<_HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<_HomePageBody> {
  final GlobalKey tandaiKey = GlobalKey();
  final GlobalKey helpKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GetSurahCubit>().getPosts();
        locator<ShowcaseService>().showCase(
          context: context,
          cacheKey: config.cacheShowCase,
          keys: [helpKey, tandaiKey],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetSurahCubit, GetSurahState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          error: (message) => appBottomsheet.messageInfo(message: message),
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
            showMessage: (message) =>
                appBottomsheet.messageInfo(message: message),
          );
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: appText.title(text: 'Quran App'),
              actions: [
                IconButton(
                  onPressed: () => context.push(AppConfig.routeSearch),
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
                  locator<ShowcaseService>().showCase(
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
                      appPadding.paddingheight16(),
                      LastReadCard(tandaiKey: tandaiKey),
                      appPadding.paddingheight16(),
                      appPadding.paddingheight16(),
                      _buildSurahList(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSurahList(BuildContext context) {
    return BlocBuilder<GetSurahCubit, GetSurahState>(
      builder: (context, getSurahState) {
        return getSurahState.maybeWhen(
          orElse: () => Container(),
          loading: () => ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => const SurahListItemShimmer(),
          ),
          success: (surah) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: surah.length,
            itemBuilder: (context, index) {
              final surahEntity = surah[index];
              return SurahListItem(
                surah: surahEntity,
                onTap: () =>
                    context.read<HomeCubit>().getDetailSurah(surahEntity),
              );
            },
          ),
        );
      },
    );
  }
}

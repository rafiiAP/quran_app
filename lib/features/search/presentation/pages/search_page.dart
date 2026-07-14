import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/core/widgets/app_input.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/presentation/cubits/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/features/search/presentation/cubits/search_cubit/search_cubit.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: BlocBuilder<GetSurahCubit, GetSurahState>(
            builder: (context, getSurahState) {
              final List<SurahEntity> surahList = getSurahState.maybeWhen(
                success: (surah) => surah,
                orElse: () => const [],
              );

              return Column(
                children: [
                  appInput.input(
                    controller: _searchController,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? colorConfig.white
                        : colorConfig.black,
                    prefixIcon: Icon(
                      Icons.search,
                      color: colorConfig.grey.withValues(alpha: 0.4),
                    ),
                    onChanged: (val) {
                      if (val.isEmpty) {
                        context.read<SearchCubit>().clearSearch();
                      } else {
                        context.read<SearchCubit>().onSearch(
                              surahList: surahList,
                              query: val,
                            );
                      }
                    },
                  ),
                  appPadding.paddingheight16(),
                  Expanded(
                    child: BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, searchState) {
                        return searchState.maybeWhen(
                          orElse: () => const SizedBox.shrink(),
                          results: (results) {
                            if (results.isEmpty &&
                                _searchController.text.isNotEmpty) {
                              return appText.textBody(
                                text: 'Surah tidak ditemukan',
                              );
                            }
                            if (results.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                return _listSurah(context, results[index]);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _listSurah(BuildContext context, SurahEntity surahEntity) {
    return InkWell(
      onTap: () {
        context.push('/detail-surah/${surahEntity.nomor}');
      },
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          appPadding.paddingheight5(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            imageConfig.borderNum,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: appText.textBody(
                          text: surahEntity.nomor.toString(),
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    appPadding.paddingWidtht16(),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText.textBody(
                            text: surahEntity.namaLatin,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          appText.textBody(
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
                child: appText.textBody(
                  text: surahEntity.nama,
                  color: colorConfig.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          appPadding.paddingheight5(),
          Divider(
            color: colorConfig.grey,
          ),
        ],
      ),
    );
  }
}

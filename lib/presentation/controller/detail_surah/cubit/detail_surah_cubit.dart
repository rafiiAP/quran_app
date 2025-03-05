import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';

part 'detail_surah_state.dart';
part 'detail_surah_cubit.freezed.dart';

class DetailSurahCubit extends Cubit<DetailSurahState> {
  RemoteUsecase quranUsecase;
  DetailSurahCubit({required this.quranUsecase}) : super(const DetailSurahState.initial());
  Future<void> getPosts({int number = 0}) async {
    emit(const DetailSurahState.loading());

    final result = await quranUsecase.getDetailSurah(nomor: number);
    result.fold(
      (l) => emit(DetailSurahState.error(l.message)),
      (r) => emit(DetailSurahState.success(r)),
    );
  }
}

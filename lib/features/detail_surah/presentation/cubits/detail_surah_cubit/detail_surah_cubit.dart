import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/domain/usecases/get_detail_surah_usecase.dart';

part 'detail_surah_state.dart';
part 'detail_surah_cubit.freezed.dart';

class DetailSurahCubit extends Cubit<DetailSurahState> {
  DetailSurahCubit({required this.usecase})
      : super(const DetailSurahState.initial());
  final GetDetailSurahUseCase usecase;

  Future<void> getPosts({final int number = 0}) async {
    emit(const DetailSurahState.loading());

    final Either<Failure, DetailEntity> result = await usecase(number);
    result.match(
      (final Failure l) => emit(DetailSurahState.error(l.message)),
      (final DetailEntity r) => emit(DetailSurahState.success(r)),
    );
  }
}

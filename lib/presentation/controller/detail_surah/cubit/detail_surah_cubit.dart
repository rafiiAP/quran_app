import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';
import 'package:quran_app/domain/use_case/remote_usecase.dart';

part 'detail_surah_state.dart';
part 'detail_surah_cubit.freezed.dart';

class DetailSurahCubit extends Cubit<DetailSurahState> {
  DetailSurahCubit({required this.quranUsecase})
      : super(const DetailSurahState.initial());
  final RemoteUsecase quranUsecase;
  Future<void> getPosts({final int number = 0}) async {
    emit(const DetailSurahState.loading());

    final Either<Failure, DetailEntity> result =
        await quranUsecase.getDetailSurah(nomor: number);
    result.fold(
      (final Failure l) => emit(DetailSurahState.error(l.message)),
      (final DetailEntity r) => emit(DetailSurahState.success(r)),
    );
  }
}

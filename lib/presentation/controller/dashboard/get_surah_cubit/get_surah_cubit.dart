import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';
import 'package:quran_app/domain/use_case/remote_usecase.dart';

part 'get_surah_state.dart';
part 'get_surah_cubit.freezed.dart';

class GetSurahCubit extends Cubit<GetSurahState> {
  GetSurahCubit({required this.quranUsecase})
      : super(const GetSurahState.initial());
  final RemoteUsecase quranUsecase;

  void getPosts() async {
    emit(const GetSurahState.loading());

    final Either<Failure, List<SurahEntity>> result =
        await quranUsecase.execute();
    result.fold(
      (final Failure l) => emit(GetSurahState.error(l.message)),
      (final List<SurahEntity> r) => emit(GetSurahState.success(r)),
    );
  }
}

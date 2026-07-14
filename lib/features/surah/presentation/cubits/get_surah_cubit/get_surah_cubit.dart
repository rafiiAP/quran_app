import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/domain/usecases/get_surah_usecase.dart';

part 'get_surah_state.dart';
part 'get_surah_cubit.freezed.dart';

class GetSurahCubit extends Cubit<GetSurahState> {
  GetSurahCubit({required this.usecase}) : super(const GetSurahState.initial());
  final GetSurahUseCase usecase;

  void getPosts() async {
    // Skip jika data sudah ada — mencegah re-fetch saat tab navigation
    if (state is _Success) return;

    emit(const GetSurahState.loading());

    final Either<Failure, List<SurahEntity>> result = await usecase();
    result.match(
      (final Failure l) => emit(GetSurahState.error(l.message)),
      (final List<SurahEntity> r) => emit(GetSurahState.success(r)),
    );
  }
}

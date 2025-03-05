import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';

part 'get_surah_state.dart';
part 'get_surah_cubit.freezed.dart';

class GetSurahCubit extends Cubit<GetSurahState> {
  RemoteUsecase quranUsecase;
  GetSurahCubit({required this.quranUsecase}) : super(const GetSurahState.initial());
  Future<void> getPosts() async {
    emit(const GetSurahState.loading());

    final result = await quranUsecase.execute();
    result.fold(
      (l) => emit(GetSurahState.error(l.message)),
      (r) => emit(GetSurahState.success(r)),
    );
  }
}

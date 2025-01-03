import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';

part 'detail_surah_event.dart';
part 'detail_surah_state.dart';
part 'detail_surah_bloc.freezed.dart';

class DetailSurahBloc extends Bloc<DetailSurahEvent, DetailSurahState> {
  QuranUsecase quranUsecase;

  DetailSurahBloc({required this.quranUsecase}) : super(const _Initial()) {
    on<_GetDetailSurah>((event, emit) async {
      emit(const _Loading());
      final result = await quranUsecase.getDetailSurah(nomor: event.nomor);
      result.fold(
        (l) => emit(_Error(l.message)),
        (r) => emit(_Success(r)),
      );
    });
  }
}

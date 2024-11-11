import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/data/model/detail_model.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';
import 'package:quran_app/injection.dart';

part 'detail_surah_event.dart';
part 'detail_surah_state.dart';
part 'detail_surah_bloc.freezed.dart';

class DetailSurahBloc extends Bloc<DetailSurahEvent, DetailSurahState> {
  final quranUsecase = locator<QuranUsecase>();
  DetailSurahBloc() : super(const _Initial()) {
    on<_GetDetailSurah>((event, emit) async {
      emit(const _Loading());
      final result = await quranUsecase.getDetailSurah(nomor: event.nomor);
      result.fold(
        (l) => emit(_Error(l.message)),
        (r) => emit(_Success(r.data!)),
      );
    });
  }
}

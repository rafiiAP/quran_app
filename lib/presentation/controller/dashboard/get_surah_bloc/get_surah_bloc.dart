import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/data/model/surah_model.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';
import 'package:quran_app/injection.dart';

part 'get_surah_event.dart';
part 'get_surah_state.dart';
part 'get_surah_bloc.freezed.dart';

class GetSurahBloc extends Bloc<GetSurahEvent, GetSurahState> {
  final quranUsecase = locator<QuranUsecase>();
  GetSurahBloc() : super(const _Initial()) {
    on<_GetSurah>((event, emit) async {
      emit(const _Loading());
      final result = await quranUsecase.getSurah();
      result.fold((l) => emit(_Error(l.message)), (r) {
        emit(_Success(r.data!));
      });
    });
  }
}

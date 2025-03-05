import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';

part 'get_surah_event.dart';
part 'get_surah_state.dart';
part 'get_surah_bloc.freezed.dart';

class GetSurahBloc extends Bloc<GetSurahEvent, GetSurahState> {
  RemoteUsecase quranUsecase;

  GetSurahBloc({required this.quranUsecase}) : super(const _Initial()) {
    on<_GetSurah>((event, emit) async {
      emit(const _Loading());
      final result = await quranUsecase.execute();
      result.fold((l) => emit(_Error(l.message)), (r) {
        emit(_Success(r));
      });
    });
  }
}

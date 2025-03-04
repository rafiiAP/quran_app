import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';

part 'jadwal_sholat_event.dart';
part 'jadwal_sholat_state.dart';
part 'jadwal_sholat_bloc.freezed.dart';

class JadwalSholatBloc extends Bloc<JadwalSholatEvent, JadwalSholatState> {
  final RemoteUsecase usecase;
  JadwalSholatBloc({required this.usecase}) : super(const _Initial()) {
    on<_GetJadwalSholat>((event, emit) async {
      emit(const _Loading());
      final result =
          await usecase.getJadwalSholat(latitude: event.latitude, longitude: event.longitude, date: event.date);
      result.fold(
        (l) => emit(_Error(l.message)),
        (r) => emit(_Success(r)),
      );
    });
  }
}

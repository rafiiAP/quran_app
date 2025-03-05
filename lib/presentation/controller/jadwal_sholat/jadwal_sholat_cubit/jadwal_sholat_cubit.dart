import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';

part 'jadwal_sholat_state.dart';
part 'jadwal_sholat_cubit.freezed.dart';

class JadwalSholatCubit extends Cubit<JadwalSholatState> {
  final RemoteUsecase usecase;
  JadwalSholatCubit({required this.usecase}) : super(const JadwalSholatState.initial());

  Future<void> getPosts({double latitude = 0.0, double longitude = 0.0, String date = ''}) async {
    emit(const JadwalSholatState.loading());

    final result = await usecase.getJadwalSholat(latitude: latitude, longitude: longitude, date: date);

    result.fold(
      (l) => emit(JadwalSholatState.error(l.message)),
      (r) => emit(JadwalSholatState.success(r)),
    );
  }
}

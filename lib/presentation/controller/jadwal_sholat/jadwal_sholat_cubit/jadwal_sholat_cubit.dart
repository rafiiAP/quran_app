import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/domain/repositories/remote_repository.dart';
import 'package:quran_app/domain/use_case/remote_usecase.dart';

part 'jadwal_sholat_state.dart';
part 'jadwal_sholat_cubit.freezed.dart';

class JadwalSholatCubit extends Cubit<JadwalSholatState> {
  JadwalSholatCubit({required this.usecase})
      : super(const JadwalSholatState.initial());

  final RemoteUsecase usecase;

  void getPosts(
      {final double latitude = 0.0,
      final double longitude = 0.0,
      final String date = ''}) async {
    emit(const JadwalSholatState.loading());

    final Either<Failure, JadwalSholatEntity> result = await usecase
        .getJadwalSholat(latitude: latitude, longitude: longitude, date: date);

    result.fold(
      (final Failure l) => emit(JadwalSholatState.error(l.message)),
      (final JadwalSholatEntity r) => emit(JadwalSholatState.success(r)),
    );
  }
}

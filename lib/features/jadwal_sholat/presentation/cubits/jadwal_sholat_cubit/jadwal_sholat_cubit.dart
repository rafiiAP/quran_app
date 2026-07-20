import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/domain/usecases/get_jadwal_sholat_usecase.dart';

part 'jadwal_sholat_state.dart';
part 'jadwal_sholat_cubit.freezed.dart';

class JadwalSholatCubit extends Cubit<JadwalSholatState> {
  JadwalSholatCubit({required this.usecase})
      : super(const JadwalSholatState.initial());

  final GetJadwalSholatUseCase usecase;

  Future<void> getPosts({
    final double latitude = 0.0,
    final double longitude = 0.0,
    final String date = '',
  }) async {
    emit(const JadwalSholatState.loading());

    final Either<Failure, JadwalSholatEntity> result = await usecase(
      JadwalSholatParams(
        latitude: latitude,
        longitude: longitude,
        date: date,
      ),
    );

    result.match(
      (final Failure l) => emit(JadwalSholatState.error(l.message)),
      (final JadwalSholatEntity r) => emit(JadwalSholatState.success(r)),
    );
  }
}

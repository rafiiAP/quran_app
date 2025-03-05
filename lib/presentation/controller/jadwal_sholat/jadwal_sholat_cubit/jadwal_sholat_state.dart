part of 'jadwal_sholat_cubit.dart';

@freezed
class JadwalSholatState with _$JadwalSholatState {
  const factory JadwalSholatState.initial() = _Initial;
  const factory JadwalSholatState.loading() = _Loading;
  const factory JadwalSholatState.success(JadwalSholatEntity data) = _Success;
  const factory JadwalSholatState.error(String message) = _Error;
}

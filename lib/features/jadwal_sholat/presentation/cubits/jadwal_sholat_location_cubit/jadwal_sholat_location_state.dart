part of 'jadwal_sholat_location_cubit.dart';

@freezed
class JadwalSholatLocationState with _$JadwalSholatLocationState {
  const factory JadwalSholatLocationState.initial() = _Initial;
  const factory JadwalSholatLocationState.loading() = _Loading;
  const factory JadwalSholatLocationState.located({
    required String city,
    required String timezone,
    required double latitude,
    required double longitude,
  }) = _Located;
  const factory JadwalSholatLocationState.error({
    required String message,
    required int retryCount,
  }) = _Error;
  const factory JadwalSholatLocationState.permissionError({
    required String message,
  }) = _PermissionError;
}

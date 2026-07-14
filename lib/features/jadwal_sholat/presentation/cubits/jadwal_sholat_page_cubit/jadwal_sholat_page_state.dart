part of 'jadwal_sholat_page_cubit.dart';

@freezed
class JadwalSholatPageState with _$JadwalSholatPageState {
  const factory JadwalSholatPageState.initial() = _Initial;
  const factory JadwalSholatPageState.loading() = _Loading;
  const factory JadwalSholatPageState.awaitingSchedule({
    required String city,
    required double latitude,
    required double longitude,
  }) = _AwaitingSchedule;
  const factory JadwalSholatPageState.loaded({
    required String city,
    required String timezone,
    required List<SetNotifModel> jadwalList,
    required String countdownText,
    required String sholatText,
    required String timeText,
    required JadwalSholatEntity
        entity, // sunrise/sunset/midnight tidak hilang saat widget re-create
  }) = _Loaded;
  const factory JadwalSholatPageState.locationError({
    required String message,
    required int retryCount,
  }) = _LocationError;
  const factory JadwalSholatPageState.locationPermissionError({
    required String message,
  }) = _LocationPermissionError;
}

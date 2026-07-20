part of 'jadwal_sholat_page_cubit.dart';

@freezed
class JadwalSholatPageState with _$JadwalSholatPageState {
  const factory JadwalSholatPageState.initial() = _Initial;
  const factory JadwalSholatPageState.loaded({
    required String city,
    required String timezone,
    required List<SetNotifModel> jadwalList,
    required String countdownText,
    required String sholatText,
    required String timeText,
    required JadwalSholatEntity entity,
  }) = _Loaded;
}

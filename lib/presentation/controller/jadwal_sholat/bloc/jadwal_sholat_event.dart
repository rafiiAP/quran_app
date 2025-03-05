part of 'jadwal_sholat_bloc.dart';

@freezed
class JadwalSholatEvent with _$JadwalSholatEvent {
  const factory JadwalSholatEvent.started() = _Started;
  const factory JadwalSholatEvent.getJadwalSholat({
    required double latitude,
    required double longitude,
    required String date,
  }) = _GetJadwalSholat;
}

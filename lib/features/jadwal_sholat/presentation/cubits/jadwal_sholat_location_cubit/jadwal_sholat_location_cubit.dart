import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/services/location_service.dart';

part 'jadwal_sholat_location_state.dart';
part 'jadwal_sholat_location_cubit.freezed.dart';

/// Cubit responsible solely for GPS location acquisition and timezone resolution.
///
/// Separated from page-level presentation logic (countdown, notifications)
/// to maintain single responsibility. Emits location data that the
/// [JadwalSholatPageCubit] consumes to trigger schedule fetching.
class JadwalSholatLocationCubit extends Cubit<JadwalSholatLocationState> {
  JadwalSholatLocationCubit({required this.locationService})
      : super(const JadwalSholatLocationState.initial());

  final LocationService locationService;

  int _retryCount = 0;
  static const int _maxRetries = 3;

  /// Gets GPS position, timezone, city name — then emits [located]
  /// or emits [error]/[permissionError] if GPS fails.
  Future<void> init() async {
    if (state is _Located || state is _Loading) return;

    emit(const JadwalSholatLocationState.loading());

    final String timezone = await locationService.getLocalTimezone();
    final position = await locationService.getCurrentPosition();

    if (position == null) {
      _retryCount++;
      if (_retryCount >= _maxRetries) {
        emit(
          const JadwalSholatLocationState.permissionError(
            message:
                'Gagal mendapatkan lokasi setelah 3 percobaan. Periksa pengaturan lokasi di perangkat Anda.',
          ),
        );
      } else {
        emit(
          JadwalSholatLocationState.error(
            message: 'Gagal mendapatkan lokasi. Ketuk untuk coba lagi.',
            retryCount: _retryCount,
          ),
        );
      }
      return;
    }

    _retryCount = 0;

    final String city = await locationService.getCityName(
      position.latitude,
      position.longitude,
    );

    emit(
      JadwalSholatLocationState.located(
        city: city,
        timezone: timezone,
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }

  /// Retries GPS location acquisition after a failure.
  void retryInit() => init();
}

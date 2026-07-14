import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

/// Abstract location service — can be mocked in unit tests.
///
/// Wraps GPS (Geolocator), geocoding, and timezone platform calls
/// behind a testable interface.
abstract class LocationService {
  /// Returns the current GPS position, or null if unavailable.
  Future<Position?> getCurrentPosition();

  /// Returns the city name for the given coordinates, or a fallback string.
  Future<String> getCityName(double latitude, double longitude);

  /// Returns the local timezone identifier (e.g., 'Asia/Jakarta').
  Future<String> getLocalTimezone();
}

/// Production implementation using platform plugins.
class LocationServiceImpl implements LocationService {
  const LocationServiceImpl();

  @override
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String> getCityName(double latitude, double longitude) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality ?? 'Tidak diketahui';
      }
    } catch (_) {}
    return 'Tidak diketahui';
  }

  @override
  Future<String> getLocalTimezone() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      return '';
    }
  }
}

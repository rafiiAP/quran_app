import 'dart:io';

/// Abstract interface for checking network connectivity.
///
/// Allows fast-failing with a user-friendly offline message
/// instead of waiting through retry delays when the device is offline.
abstract class ConnectivityService {
  /// Returns true if the device has an active internet connection.
  Future<bool> hasConnection();
}

/// Implementation using a DNS lookup to verify actual connectivity.
///
/// More reliable than checking wifi/mobile state alone, since
/// a connected network adapter doesn't guarantee internet access.
class ConnectivityServiceImpl implements ConnectivityService {
  const ConnectivityServiceImpl();

  @override
  Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

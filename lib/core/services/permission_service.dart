import 'package:permission_handler/permission_handler.dart';

/// Abstract interface for permission requests.
///
/// Can be mocked independently in unit tests.
abstract class PermissionService {
  /// Requests only the permissions that haven't been granted yet.
  /// Returns true if all required permissions are granted.
  Future<bool> requestRequiredPermissions();

  /// Requests only notification permission if not yet granted.
  /// Returns true if granted.
  Future<bool> requestNotificationPermission();

  /// Requests only location permission if not yet granted.
  /// Returns true if granted.
  Future<bool> requestLocationPermission();
}

/// Implementation using the `permission_handler` package.
///
/// Only prompts users for permissions they haven't already granted,
/// avoiding unnecessary permission dialogs on every app launch.
class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> requestRequiredPermissions() async {
    final results = await Future.wait([
      requestNotificationPermission(),
      requestLocationPermission(),
    ]);
    return results.every((final bool granted) => granted);
  }

  @override
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) return false;

    final result = await Permission.notification.request();
    return result.isGranted;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) return false;

    final result = await Permission.location.request();
    return result.isGranted;
  }
}

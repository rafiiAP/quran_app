import 'package:permission_handler/permission_handler.dart';

/// Abstract interface for permission requests.
///
/// Can be mocked independently in unit tests.
abstract class PermissionService {
  /// Requests all required permissions (notification + location).
  /// Returns true if all were granted.
  Future<bool> requestAllPermissions();

  /// Requests only notification permission. Returns true if granted.
  Future<bool> requestNotificationPermission();

  /// Requests only location permission. Returns true if granted.
  Future<bool> requestLocationPermission();
}

/// Implementation using the `permission_handler` package.
class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> requestAllPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await <Permission>[
      Permission.notification,
      Permission.location,
    ].request();

    return statuses.values
        .every((final PermissionStatus status) => status.isGranted);
  }

  @override
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  @override
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }
}

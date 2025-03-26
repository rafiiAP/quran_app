part of 'main_function.dart';

mixin PermissionService {
  Future<bool> requestAllPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await <Permission>[
      Permission.notification,
      Permission.location,
    ].request();

    return statuses.values
        .every((final PermissionStatus status) => status.isGranted);
  }
}

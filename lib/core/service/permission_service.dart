import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();

  PermissionService._internal();

  factory PermissionService() {
    return _instance;
  }

  static Future<bool> requestAllPermissions() async {
    final statuses = await [
      Permission.notification,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }
}

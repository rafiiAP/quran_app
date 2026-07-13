import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/data/datasources/local_storage_service.dart';
import 'package:quran_app/injection.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/constant/config.dart';
import '../widgets/main_widget.dart';

part 'api_service.dart';
part 'datetime_com.dart';
part 'local_notification_service.dart';
part 'permission_service.dart';

/// Getter global untuk mempermudah akses singleton
MainFunction get C => locator<MainFunction>();

class MainFunction
    with
        ApiService,
        DatetimeComponent,
        LocalNotificationService,
        PermissionService {
  bool isDark(final BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  void showLog({
    required final dynamic log,
  }) {
    if (config.lShowLog) dev.log("$log");
  }

  void showCase({
    required BuildContext context,
    required List<GlobalKey> keys,
    required String cacheKey,
    isShowHelp = false,
  }) {
    final storageService = locator<LocalStorageService>();
    final alreadyShown = storageService.getBool(key: cacheKey);

    if (!alreadyShown) {
      storageService.setBool(key: cacheKey, value: true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!context.mounted) return;

        ShowCaseWidget.of(context).startShowCase(keys);
      });
    }

    if (isShowHelp) {
      ShowCaseWidget.of(context).startShowCase(keys);
    }
  }
}

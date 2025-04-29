import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';
import 'package:quran_app/injection.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:translator/translator.dart';

import '../../data/constant/config.dart';
import '../widgets/main_widget.dart';

part 'api_service.dart';
part 'navigation_com.dart';
part 'datetime_com.dart';
part 'get_storage_com.dart';
part 'local_notification_service.dart';
part 'permission_service.dart';

/// Getter global untuk mempermudah akses singleton
MainFunction get C => locator<MainFunction>();

class MainFunction
    with
        ApiService,
        NavigationCom,
        DatetimeComponent,
        GetStorageComponent,
        LocalNotificationService,
        PermissionService {
  /*Future<String> translateToIndonesian(String text) async {
    final translator = GoogleTranslator();

    try {
      // Terjemahkan teks
      final translation = await translator.translate(
        text,
        to: 'id', // Bahasa Indonesia
        from: 'en', // Bahasa Inggris
      );
      return translation.text;
    } catch (e) {
      // Tangani error
      C.showLog(log: "Error translating text: $e");
      return text;
    }
  }*/

  bool isDark(final BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  double getHeight() => Get.height;
  double getWidth() => Get.width;

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
    final alreadyShown = C.getBool(cKey: cacheKey, lDefaultValue: false);

    if (!alreadyShown) {
      C.setBool(cKey: cacheKey, lValue: true);
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

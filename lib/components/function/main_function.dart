import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dio/dio.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/data/model/surah_model.dart';

import '../../data/constant/config.dart';
import '../widgets/main_widget.dart';

part 'api_service.dart';
part 'navigation_com.dart';
part 'datetime_com.dart';
part 'get_storage_com.dart';

MainFunction get C => MainFunction();

class MainFunction with ApiService, NavigationCom, DatetimeComponent, GetStorageComponent {
  static final MainFunction _instance = MainFunction._internal();

  MainFunction._internal();

  factory MainFunction() {
    return _instance;
  }

  String cleanString(String input) {
    return input.replaceAll(RegExp(r'[\u0000-\u001F\u007F-\u009F\u202E\u2060\u200B-\u200F\u202A-\u202E]'), '');
  }

  bool isDark(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  getHeight() {
    return Get.height;
  }

  getWidth() {
    return Get.width;
  }

  void showLog({
    required dynamic log,
  }) {
    if (AppConfig.lShowLog) dev.log("$log");
  }
}

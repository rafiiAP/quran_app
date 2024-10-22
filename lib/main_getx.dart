import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/presentation/view/dashboard/dashboard_page.dart';
import 'package:quran_app/presentation/view/started_page.dart';

class MainGetx extends GetxController {
  Widget? page;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onReady() {
    init();
    super.onReady();
  }

  init() {
    getCache();
  }

  getCache() {
    if (C.getBool(cKey: AppConfig.cacheStarted, lDefaultValue: false)) {
      page = DashboardPage();
    } else {
      page = const StartedPage();
    }
  }
}

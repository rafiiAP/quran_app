import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/config.dart';

import 'package:quran_app/presentation/view/dashboard/bookmark_page.dart';
import 'package:quran_app/presentation/view/dashboard/home_page.dart';
import 'package:quran_app/presentation/view/jadwal_sholat/jadwal_sholat_page.dart';

class DashboardGetx extends GetxController {
  List<Widget> vaPage = <Widget>[
    const HomePage(),
    BookmarkPage(),
    const JadwalSholatPage(),
  ];

  RxInt nIndex = 0.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    setCache();
  }

  void setCache() async {
    await C.setBool(cKey: config.cacheStarted, lValue: true);
  }
}

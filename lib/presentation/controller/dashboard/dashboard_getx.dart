import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/config.dart';

import 'package:quran_app/presentation/view/dashboard/bookmark_page.dart';
import 'package:quran_app/presentation/view/dashboard/home_page.dart';
import 'package:quran_app/presentation/view/jadwal_sholat/jadwal_sholat_page.dart';

class DashboardGetx extends GetxController {
  List vaPage = [
    const HomePage(),
    BookmarkPage(),
    const JadwalSholatPage(),
  ];

  var nIndex = 0.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  init() {
    setCache();
  }

  setCache() {
    C.setBool(cKey: AppConfig.cacheStarted, lValue: true);
    C.showLog(log: '--${C.getBool(cKey: AppConfig.cacheStarted, lDefaultValue: false)}');
  }
}

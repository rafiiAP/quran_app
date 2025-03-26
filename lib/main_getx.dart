import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    getPermission();
    super.onReady();
  }

  void init() {
    getCache();
  }

  void getCache() {
    if (C.getBool(cKey: config.cacheStarted, lDefaultValue: false)) {
      page = DashboardPage();
    } else {
      page = const StartedPage();
    }
  }

  void getPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      C.showLog(log: '--Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        C.showLog(log: '--Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      // Permissions are denied forever, handle appropriately.
      C.showLog(
          log:
              '--Location permissions are permanently denied, we cannot request permissions.');
    }
    C.showLog(log: '--Location permissions are granted');
  }
}

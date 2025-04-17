import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/presentation/controller/dashboard/dashboard_getx.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final c = Get.put(DashboardGetx());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Obx(() => c.vaPage[c.nIndex.value]),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     try {
        //       throw Exception('--tes kok gak walawe');
        //     } catch (e, stackTrace) {
        //       FirebaseCrashlytics.instance
        //           .recordError(e, stackTrace, fatal: true);
        //     }
        //   },
        // ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            onTap: (value) => c.nIndex.value = value,
            elevation: 0,
            currentIndex: c.nIndex.value,
            selectedItemColor: colorConfig.primary,
            unselectedItemColor: colorConfig.grey,
            backgroundColor:
                C.isDark(context) ? colorConfig.bgBottom : colorConfig.white,
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset(
                  imageConfig.bookNav,
                  color: c.nIndex.value == 0
                      ? colorConfig.primary
                      : colorConfig.grey,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset(
                  imageConfig.bookmark,
                  color: c.nIndex.value == 1
                      ? colorConfig.primary
                      : colorConfig.grey,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Image.asset(
                  imageConfig.shalat,
                  width: 30,
                  color: c.nIndex.value == 2
                      ? colorConfig.primary
                      : colorConfig.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

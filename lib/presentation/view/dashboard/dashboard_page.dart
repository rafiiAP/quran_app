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
    return Scaffold(
      body: Obx(() => c.vaPage[c.nIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (value) => c.nIndex.value = value,
          elevation: 0,
          currentIndex: c.nIndex.value,
          selectedItemColor: AppColorConfig.primary,
          unselectedItemColor: AppColorConfig.grey,
          backgroundColor: C.isDark(context) ? AppColorConfig.bgBottom : AppColorConfig.white,
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                MyImage.bookNav,
                color: c.nIndex.value == 0 ? AppColorConfig.primary : AppColorConfig.grey,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                MyImage.bookmark,
                color: c.nIndex.value == 1 ? AppColorConfig.primary : AppColorConfig.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SetNotifModel {
  SetNotifModel({
    required this.iconsax,
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
    required this.isAlarmSet,
  });

  final IconData iconsax;
  final int hour;
  final int minute;
  final String title;
  final String body;
  RxBool isAlarmSet = false.obs;
}

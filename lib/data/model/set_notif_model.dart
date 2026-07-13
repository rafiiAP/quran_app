import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class SetNotifModel extends Equatable {
  const SetNotifModel({
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
  final bool isAlarmSet;

  SetNotifModel copyWith({
    IconData? iconsax,
    int? hour,
    int? minute,
    String? title,
    String? body,
    bool? isAlarmSet,
  }) {
    return SetNotifModel(
      iconsax: iconsax ?? this.iconsax,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      title: title ?? this.title,
      body: body ?? this.body,
      isAlarmSet: isAlarmSet ?? this.isAlarmSet,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        iconsax,
        hour,
        minute,
        title,
        body,
        isAlarmSet,
      ];
}

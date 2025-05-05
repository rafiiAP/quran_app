import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';

class JadwalSholatGetx extends GetxController {
  GlobalKey notifKey = GlobalKey();

  RxList<SetNotifModel> vaJadwal = RxList<SetNotifModel>();
  Rxn<Position> position = Rxn<Position>();

  RxString city = ''.obs,
      cSholat = ''.obs,
      countdownText = ''.obs,
      timezone = ''.obs;

  @override
  void onInit() {
    //mengabil nama kota sekarang
    getLoacationName();
    //mengambil timezone lokasi sekrang
    getTimeZone();
    vaJadwal.value = vaJadwal.value = <SetNotifModel>[
      SetNotifModel(
        iconsax: Iconsax.moon1,
        hour: 0,
        minute: 0,
        title: 'Subuh',
        body: 'Waktunya sholat Subuh',
        isAlarmSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun,
        hour: 0,
        minute: 0,
        title: 'Dzuhur',
        body: 'Waktunya sholat Dzuhur',
        isAlarmSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun_1,
        hour: 0,
        minute: 0,
        title: 'Ashar',
        body: 'Waktunya sholat Ashar',
        isAlarmSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun_fog,
        hour: 0,
        minute: 0,
        title: 'Maghrib',
        body: 'Waktunya sholat Maghrib',
        isAlarmSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.moon5,
        hour: 0,
        minute: 0,
        title: 'Isya',
        body: 'Waktunya sholat Isya',
        isAlarmSet: false.obs,
      ),
    ];

    super.onInit();
  }

  void getLoacationName() async {
    // C.showLog(log: 'log: --baaa');
    position.value = await determinePosition();
    // C.showLog(log: '--baaa position: $position');

    if (position.value == null) {
      city.value = 'Tidak diketahui';
      return;
    }

    // Ambil nama kota/kabupaten
    var placemarks = await placemarkFromCoordinates(
        position.value!.latitude, position.value!.longitude);
    // C.showLog(log: '--baaa placemarks: $placemarks');

    if (placemarks.isNotEmpty) {
      city.value = placemarks[0].locality ?? "Tidak diketahui";
      // C.showLog(log: '--baaa City: $city');.va
    } else {
      city.value = 'Tidak diketahui';
    }
  }

  void getTimeZone() async {
    timezone.value = await FlutterTimezone.getLocalTimezone();
  }

  @override
  Future<void> onReady() async {
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      jadwalSholat();
    });
    if (Platform.isAndroid) {
      if (await Permission.scheduleExactAlarm.isDenied) {
        await W.messageInfo(
            message: 'Permission alarm dibutuhkan untuk melanjutkan aplikasi');
        await Permission.scheduleExactAlarm.request();
      }
    }
    super.onReady();
  }

  void jadwalSholat() async {
    // Simpan BuildContext sebelum operasi async
    final BuildContext? context = Get.context;
    if (context == null) return;

    // Dapatkan tanggal sekarang
    final String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // Ambil lokasi
    position.value = await determinePosition();

    if (position.value == null) {
      // jadwalSholat();
      return;
    }

    // Pastikan context masih valid setelah async selesai
    if (!context.mounted) return;

    context.read<JadwalSholatCubit>().getPosts(
          latitude: position.value!.latitude,
          longitude: position.value!.longitude,
          date: date,
        );
  }

  void onSuccess(final JadwalSholatEntity data) async {
    vaJadwal.value = <SetNotifModel>[
      SetNotifModel(
        iconsax: Iconsax.moon1,
        hour: int.parse(data.fajr.split(":")[0]),
        minute: int.parse(data.fajr.split(":")[1]),
        title: 'Subuh',
        body: 'Waktunya sholat Subuh',
        isAlarmSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun,
        hour: int.parse(data.dhuhr.split(":")[0]),
        minute: int.parse(data.dhuhr.split(":")[1]),
        title: 'Dzuhur',
        body: 'Waktunya sholat Dzuhur',
        isAlarmSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun_1,
        hour: int.parse(data.asr.split(":")[0]),
        minute: int.parse(data.asr.split(":")[1]),
        title: 'Ashar',
        body: 'Waktunya sholat Ashar',
        isAlarmSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun_fog,
        hour: int.parse(data.maghrib.split(":")[0]),
        minute: int.parse(data.maghrib.split(":")[1]),
        title: 'Maghrib',
        body: 'Waktunya sholat Maghrib',
        isAlarmSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.moon5,
        hour: int.parse(data.isha.split(":")[0]),
        minute: int.parse(data.isha.split(":")[1]),
        title: 'Isya',
        body: 'Waktunya sholat Isya',
        isAlarmSet: false.obs,
      ),
    ];

    loadAlarmStatus();
    startTimer();
    updateSholat();
  }

  Future<void> requestExactAlarmPermission() async {}

  void startTimer() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      updateCountdown();
      startTimer();
    });
  }

  void updateSholat() {
    Future.delayed(const Duration(hours: 3)).then(
      (final _) {
        getTimeText();
        updateSholat();
      },
    );
  }

  // 🔥 Konversi Durasi ke Format HH:mm:ss 🔥
  String formatDuration(final Duration duration) {
    String twoDigits(final int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void updateCountdown() {
    final DateTime now = DateTime.now();

    for (var entry in vaJadwal) {
      final DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );

      if (now.isBefore(waktuSholat)) {
        final Duration remaining = waktuSholat.difference(now);
        countdownText.value =
            "${entry.title} dalam\n${formatDuration(remaining)}";
        return;
      }
    }

    // Jika sudah melewati semua jadwal, tampilkan countdown untuk Subuh besok

    final DateTime waktuSubuhBesok = DateTime(
      now.year,
      now.month,
      now.day + 1,
      vaJadwal.first.hour,
      vaJadwal.first.minute,
    );
    final Duration remaining = waktuSubuhBesok.difference(now);
    countdownText.value = "Subuh dalam\n${formatDuration(remaining)}";
  }

  String getSholatText() {
    // Gunakan waktu statis 18:30 (6:30 PM) saat debugging
    final DateTime now = DateTime.now();
    // now = DateTime(now.year, now.month, now.day, 20, 35);
    // C.showLog(log: '--baaa now: $now');

    for (final SetNotifModel entry in vaJadwal) {
      final DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );

      if (now.isBefore(waktuSholat)) {
        return "Mendekati waktu ${entry.title}";
      }
    }

    return "Subuh Besok";
  }

  String getTimeText() {
    final DateTime now = DateTime.now();

    if (vaJadwal.isEmpty) {
      return "-"; // atau kamu bisa return string lain sebagai fallback
    }

    for (final SetNotifModel entry in vaJadwal) {
      final DateTime waktuSholat =
          DateTime(now.year, now.month, now.day, entry.hour, entry.minute);

      if (now.isBefore(waktuSholat)) {
        return "${entry.hour.toString().padLeft(2, '0')}:${entry.minute.toString().padLeft(2, '0')}";
      }
    }

    // fallback ke jadwal pertama (kalau semua sudah lewat)
    final first = vaJadwal.first;
    return "${first.hour.toString().padLeft(2, '0')}:${first.minute.toString().padLeft(2, '0')}";
  }

  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future? determinePosition() async {
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      final Position position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      C.showLog(log: '--Error getting location: $e');
      return null;
    }
  }

  void loadAlarmStatus() async {
    for (final SetNotifModel item in vaJadwal) {
      final bool status =
          C.getBool(cKey: "alarm_${item.title}", lDefaultValue: false);
      item.isAlarmSet.value = status;

      if (item.isAlarmSet.value) {
        await C.scheduleNotification(
          vaJadwal.indexOf(item),
          item.hour,
          item.minute,
          title: item.title,
          body: item.body,
        );
      }
    }
  }

  void setNotif(final int index, final SetNotifModel model) async {
    if (model.isAlarmSet.value) {
      model.isAlarmSet.value = false;
      C.setBool(cKey: "alarm_${model.title}", lValue: model.isAlarmSet.value);
      await C.cancelNotification(index);
    } else {
      model.isAlarmSet.value = true;
      await C
          .scheduleNotification(
        index,
        model.hour,
        model.minute,
        title: model.title,
        body: model.body,
      )
          .then(
        (final _) {
          C.checkScheduledNotifications().then(
            (final List<PendingNotificationRequest> value) {
              if (value.isEmpty) {
                Get.snackbar(
                    'Gagal', 'Pengingat waktu sholat gagal diaktifkan');
                return;
              } else {
                final DateTime now = DateTime.now();

                final DateTime waktuSholat = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  model.hour,
                  model.minute,
                );

                C.setBool(
                    cKey: "alarm_${model.title}",
                    lValue: model.isAlarmSet.value);

                final Duration remaining = waktuSholat.difference(now);

                Get.snackbar('Berhasil',
                    "Pengingat waktu sholat ${model.title} dalam\n${remaining.inHours} jam ${remaining.inMinutes.remainder(60)} menit");
              }
            },
          );
        },
      );
    }
  }
}

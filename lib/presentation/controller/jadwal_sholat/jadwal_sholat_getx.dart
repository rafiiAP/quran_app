import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/core/service/local_notification_service.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';

class JadwalSholatGetx extends GetxController {
  RxMap<String, String> jadwal = RxMap<String, String>();
  RxList<SetNotifModel> vaJadwal = RxList<SetNotifModel>();
  Rxn<Position> position = Rxn<Position>();

  var city = ''.obs, cSholat = ''.obs, countdownText = ''.obs, timezone = ''.obs;

  @override
  void onInit() {
    //mengabil nama kota sekarang
    getLoacationName();
    //mengambil timezone lokasi sekrang
    getTimeZone();

    super.onInit();
  }

  @override
  void onReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jadwalSholat();
    });
    super.onReady();
  }

  void jadwalSholat() async {
    // Simpan BuildContext sebelum operasi async
    final BuildContext? context = Get.context;
    if (context == null) return;

    // Dapatkan tanggal sekarang
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

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

  onSuccess(JadwalSholatEntity data) {
    vaJadwal.value = [
      SetNotifModel(
        iconsax: Iconsax.moon1,
        hour: int.parse(data.fajr.split(":")[0]),
        minute: int.parse(data.fajr.split(":")[1]),
        title: 'Subuh',
        body: 'Waktunya sholat Subuh',
        isSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun,
        hour: int.parse(data.dhuhr.split(":")[0]),
        minute: int.parse(data.dhuhr.split(":")[1]),
        title: 'Dzuhur',
        body: 'Waktunya sholat Dzuhur',
        isSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun_1,
        hour: int.parse(data.asr.split(":")[0]),
        minute: int.parse(data.asr.split(":")[1]),
        title: 'Ashar',
        body: 'Waktunya sholat Ashar',
        isSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.sun_fog,
        hour: int.parse(data.maghrib.split(":")[0]),
        minute: int.parse(data.maghrib.split(":")[1]),
        title: 'Maghrib',
        body: 'Waktunya sholat Maghrib',
        isSet: false.obs,
      ),
      SetNotifModel(
        iconsax: Iconsax.moon5,
        hour: int.parse(data.isha.split(":")[0]),
        minute: int.parse(data.isha.split(":")[1]),
        title: 'Isya',
        body: 'Waktunya sholat Isya',
        isSet: false.obs,
      ),
    ];
    loadAlarmStatus();
    startTimer();
    updateSholat();
  }

  Future<void> requestExactAlarmPermission() async {}

  void startTimer() {
    Future.delayed(const Duration(milliseconds: 500), () {
      updateCountdown();
      startTimer();
    });
  }

  void updateSholat() {
    Future.delayed(const Duration(hours: 3)).then(
      (value) {
        getNextSholatText();
        getNextSholatText();
        getTimeText();
        getNextTime();
        updateSholat();
      },
    );
  }

  // 🔥 Konversi Durasi ke Format HH:mm:ss 🔥
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void updateCountdown() {
    DateTime now = DateTime.now();

    for (var entry in vaJadwal) {
      DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );

      if (now.isBefore(waktuSholat)) {
        Duration remaining = waktuSholat.difference(now);
        countdownText.value = "${entry.title} dalam\n${formatDuration(remaining)}";
        return;
      }
    }

    // Jika sudah melewati semua jadwal, tampilkan countdown untuk Subuh besok

    DateTime waktuSubuhBesok = DateTime(
      now.year,
      now.month,
      now.day + 1,
      vaJadwal.first.hour,
      vaJadwal.first.minute,
    );
    Duration remaining = waktuSubuhBesok.difference(now);
    countdownText.value = "Subuh dalam\n${formatDuration(remaining)}";
  }

  String getSholatText() {
    DateTime now = DateTime.now();

    for (var entry in vaJadwal) {
      DateTime waktuSholat = DateTime(
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
    return "-";
  }

  String getNextSholatText() {
    DateTime now = DateTime.now();

    List<DateTime> times = vaJadwal.map((key) {
      return DateTime(now.year, now.month, now.day, key.hour, key.minute);
    }).toList();

    int nextIndex = -1;

    for (int i = 0; i < times.length; i++) {
      if (now.isBefore(times[i])) {
        nextIndex = i + 1; // Loncat satu kali ke waktu berikutnya
        break;
      }
    }

    // Jika nextIndex melewati Isya, kembali ke Subuh besok
    if (nextIndex >= times.length) {
      nextIndex = 0;
    }

    return vaJadwal[nextIndex].title;
  }

  String getNextTime() {
    DateTime now = DateTime.now();

    List<DateTime> dateTimes = vaJadwal.map((time) {
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    }).toList();

    int nextIndex = -1;

    for (int i = 0; i < dateTimes.length; i++) {
      if (now.isBefore(dateTimes[i])) {
        nextIndex = i + 1; // Loncat +1 ke setelah yang berikutnya
        break;
      }
    }

    // Jika nextIndex melebihi daftar, kembali ke awal (Subuh besok)
    if (nextIndex >= dateTimes.length) {
      nextIndex = nextIndex % dateTimes.length;
    }

    return DateFormat('HH:mm').format(dateTimes[nextIndex]);
  }

  String getTimeText() {
    DateTime now = DateTime.now();

    for (var entry in vaJadwal) {
      DateTime waktuSholat = DateTime(now.year, now.month, now.day, entry.hour, entry.minute);

      if (now.isBefore(waktuSholat)) {
        return "${entry.hour}:${entry.minute}";
      }
    }
    return "";
  }

  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future? determinePosition() async {
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      final position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      C.showLog(log: '--Error getting location: $e');
      return null;
    }
  }

  getLoacationName() async {
    // C.showLog(log: 'log: --baaa');
    position.value = await determinePosition();
    // C.showLog(log: '--baaa position: $position');

    if (position.value == null) {
      city.value = 'Tidak diketahui';
      return;
    }

    // Ambil nama kota/kabupaten
    var placemarks = await placemarkFromCoordinates(position.value!.latitude, position.value!.longitude);
    // C.showLog(log: '--baaa placemarks: $placemarks');

    if (placemarks.isNotEmpty) {
      city.value = placemarks[0].locality ?? "Tidak diketahui";
      // C.showLog(log: '--baaa City: $city');.va
    } else {
      city.value = 'Tidak diketahui';
    }
  }

  getTimeZone() async {
    timezone.value = await FlutterTimezone.getLocalTimezone();
  }

  loadAlarmStatus() async {
    for (var item in vaJadwal) {
      bool? status = C.getBool(cKey: "alarm_${item.title}", lDefaultValue: false);
      item.isSet.value = status;

      if (item.isSet.value) {
        await LocalNotificationService.scheduleNotification(
          vaJadwal.indexOf(item),
          item.hour,
          item.minute,
          title: item.title,
          body: item.body,
        );
      }
    }
  }

  setNotif(int index, SetNotifModel model) async {
    // for (var i = 0; i < jadwal.length; i++) {
    //   List<String> splitTime = jadwal.values.elementAt(i).split(":");
    //   LocalNotificationService.scheduleNotification(
    //     i,
    //     int.parse(splitTime[0]),
    //     int.parse(splitTime[1]),
    //     title: jadwal.keys.elementAt(i),
    //     body: 'Waktunya sholat ${jadwal.keys.elementAt(i)}',
    //   );
    // }
    if (model.isSet.value) {
      model.isSet.value = false;
      await LocalNotificationService.cancelNotification(index);
    } else {
      model.isSet.value = true;
      LocalNotificationService.scheduleNotification(
        index,
        model.hour,
        model.minute,
        title: model.title,
        body: model.body,
      ).then(
        (value) {
          LocalNotificationService.checkScheduledNotifications()!.then(
            (value) {
              if (value == null) {
                Get.snackbar('Gagal', 'Pengingat waktu sholat gagal diaktifkan');
                return;
              } else {
                DateTime now = DateTime.now();

                DateTime waktuSholat = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  model.hour,
                  model.minute,
                );

                for (int i = 0; i < vaJadwal.length; i++) {
                  C.setBool(cKey: "alarm_${vaJadwal[i].title}", lValue: vaJadwal[i].isSet.value);
                }

                Duration remaining = waktuSholat.difference(now);

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

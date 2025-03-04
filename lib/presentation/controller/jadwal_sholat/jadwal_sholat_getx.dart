import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/bloc/jadwal_sholat_bloc.dart';
// import 'package:quran_app/data/datasources/remote_api_datasource/remote_api_datasource.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class JadwalSholatGetx extends GetxController {
  // JadwalSholatEntity data;
  // JadwalSholatGetx({
  //   required this.data,
  // });
  var city = ''.obs, cSholat = ''.obs, countdownText = ''.obs, timezone = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    jadwalSholat();

    getLoacationName();
    getTimeZone();
    super.onReady();
  }

  void startTimer(JadwalSholatEntity data) {
    Future.delayed(Duration(seconds: 1), () {
      updateCountdown(data);
      startTimer(data);
    });
  }

  void updateSholat(JadwalSholatEntity data) {
    Future.delayed(Duration(hours: 3)).then(
      (value) {
        getNextSholatText(data);
        getNextSholatText(data);
        getTimeText(data);
        getNextTime(data);
        updateSholat(data);
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

  void updateCountdown(JadwalSholatEntity data) {
    DateTime now = DateTime.now();
    Map<String, String> jadwal = {
      "Subuh": data.fajr,
      "Zuhur": data.dhuhr,
      "Asar": data.asr,
      "Maghrib": data.maghrib,
      "Isya": data.isha,
    };

    for (var entry in jadwal.entries) {
      List<String> splitTime = entry.value.split(":");
      DateTime waktuSholat = DateTime(now.year, now.month, now.day, int.parse(splitTime[0]), int.parse(splitTime[1]));

      if (now.isBefore(waktuSholat)) {
        Duration remaining = waktuSholat.difference(now);
        countdownText.value = "${entry.key} dalam\n${formatDuration(remaining)}";
        return;
      }
    }

    // Jika sudah melewati semua jadwal, tampilkan countdown untuk Subuh besok
    List<String> splitTime = data.fajr.split(":");
    DateTime waktuSubuhBesok =
        DateTime(now.year, now.month, now.day + 1, int.parse(splitTime[0]), int.parse(splitTime[1]));
    Duration remaining = waktuSubuhBesok.difference(now);
    countdownText.value = "Subuh dalam\n${formatDuration(remaining)}";
  }

  String getSholatText(JadwalSholatEntity data) {
    DateTime now = DateTime.now();
    Map<String, String> jadwal = {
      "Subuh": data.fajr,
      "Zuhur": data.dhuhr,
      "Asar": data.asr,
      "Maghrib": data.maghrib,
      "Isya": data.isha,
    };

    for (var entry in jadwal.entries) {
      List<String> splitTime = entry.value.split(":");
      DateTime waktuSholat = DateTime(now.year, now.month, now.day, int.parse(splitTime[0]), int.parse(splitTime[1]));

      if (now.isBefore(waktuSholat)) {
        return "Mendekati waktu ${entry.key}";
      }
    }
    return "-";
  }

  String getNextSholatText(JadwalSholatEntity data) {
    DateTime now = DateTime.now();
    Map<String, String> jadwal = {
      "Subuh": data.fajr,
      "Zuhur": data.dhuhr,
      "Asar": data.asr,
      "Maghrib": data.maghrib,
      "Isya": data.isha,
    };

    List<String> keys = jadwal.keys.toList(); // Urutan sholat
    List<DateTime> times = keys.map((key) {
      List<String> splitTime = jadwal[key]!.split(":");
      return DateTime(now.year, now.month, now.day, int.parse(splitTime[0]), int.parse(splitTime[1]));
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

    return keys[nextIndex];
  }

  String getNextTime(JadwalSholatEntity data) {
    DateTime now = DateTime.now();
    Map<String, String> jadwal = {
      "Subuh": data.fajr,
      "Zuhur": data.dhuhr,
      "Asar": data.asr,
      "Maghrib": data.maghrib,
      "Isya": data.isha,
    };

    List<String> times = jadwal.values.toList(); // Ambil semua waktu sholat

    List<DateTime> dateTimes = times.map((time) {
      List<String> splitTime = time.split(":");
      return DateTime(now.year, now.month, now.day, int.parse(splitTime[0]), int.parse(splitTime[1]));
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

  String getTimeText(JadwalSholatEntity data) {
    DateTime now = DateTime.now();
    Map<String, String> jadwal = {
      "Subuh": data.fajr,
      "Zuhur": data.dhuhr,
      "Asar": data.asr,
      "Maghrib": data.maghrib,
      "Isya": data.isha,
    };

    for (var entry in jadwal.entries) {
      List<String> splitTime = entry.value.split(":");
      DateTime waktuSholat = DateTime(now.year, now.month, now.day, int.parse(splitTime[0]), int.parse(splitTime[1]));

      if (now.isBefore(waktuSholat)) {
        return entry.value;
      }
    }
    return "";
  }

  waktuSholat(String cSholat) {
    // switch (DateTime.now().hour){
    //   case cSholat.toString()
    // }
  }

  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // C.showLog(log: '--Location services are disabled.');
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
        // C.showLog(log: '--Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // C.showLog(log: '--Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void jadwalSholat() async {
    // Simpan BuildContext sebelum operasi async
    final BuildContext? context = Get.context;
    if (context == null) return;

    // Dapatkan tanggal sekarang
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // Ambil lokasi
    Position position = await determinePosition();

    // Pastikan context masih valid setelah async selesai
    if (!context.mounted) return;

    context.read<JadwalSholatBloc>().add(
          JadwalSholatEvent.getJadwalSholat(
            latitude: position.latitude,
            longitude: position.longitude,
            date: date,
          ),
        );
  }

  getLoacationName() async {
    Position position = await determinePosition();

    // Ambil nama kota/kabupaten
    var placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      city.value = placemarks[0].locality ?? "Tidak diketahui";
      // C.showLog(log: '--City: $city');
    }
  }

  getTimeZone() async {
    timezone.value = await FlutterTimezone.getLocalTimezone();
  }
}

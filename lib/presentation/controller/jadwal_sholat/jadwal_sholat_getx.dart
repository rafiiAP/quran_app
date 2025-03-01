import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran_app/components/function/main_function.dart';
// import 'package:geocoding/geocoding.dart';

class JadwalSholatGetx extends GetxController {
  var city = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async {
    // getLoacationName();
    super.onReady();
  }

  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
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

  // getLoacationName() async {
  //   Position position = await determinePosition();

  //   // Ambil nama kota/kabupaten
  //   var placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

  //   if (placemarks.isNotEmpty) {
  //     city.value = placemarks[0].locality ?? "Tidak diketahui";
  //     // C.showLog(log: '--City: $city');
  //   }
  // }
}

import 'package:equatable/equatable.dart';

class JadwalSholatDioEntity extends Equatable {
  final int code;
  final String status;
  final JadwalSholatDataEntity data;

  const JadwalSholatDioEntity({
    required this.code,
    required this.status,
    required this.data,
  });

  @override
  List<Object?> get props => [code, status, data];
}

class JadwalSholatDataEntity extends Equatable {
  final JadwalSholatEntity timings;

  const JadwalSholatDataEntity({
    required this.timings,
  });

  @override
  List<Object?> get props => [timings];
}

class JadwalSholatEntity extends Equatable {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;
  final String firstthird;
  final String lastthird;

  const JadwalSholatEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstthird,
    required this.lastthird,
  });

  @override
  List<Object?> get props => [
        fajr,
        sunrise,
        dhuhr,
        asr,
        sunset,
        maghrib,
        isha,
        imsak,
        midnight,
        firstthird,
        lastthird,
      ];
}

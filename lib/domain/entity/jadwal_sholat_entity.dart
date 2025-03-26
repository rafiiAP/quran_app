import 'package:equatable/equatable.dart';

class JadwalSholatDioEntity extends Equatable {
  const JadwalSholatDioEntity({
    required this.code,
    required this.status,
    required this.data,
  });

  final int code;
  final String status;
  final JadwalSholatDataEntity data;

  @override
  List<Object?> get props => <Object?>[code, status, data];
}

class JadwalSholatDataEntity extends Equatable {
  const JadwalSholatDataEntity({
    required this.timings,
  });

  final JadwalSholatEntity timings;

  @override
  List<Object?> get props => <Object?>[timings];
}

class JadwalSholatEntity extends Equatable {
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

  @override
  List<Object?> get props => <Object?>[
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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';

class JadwalSholatDioModel extends Equatable {
  const JadwalSholatDioModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory JadwalSholatDioModel.fromJson(final String str) =>
      JadwalSholatDioModel.fromMap(json.decode(str));

  factory JadwalSholatDioModel.fromMap(final Map<String, dynamic> json) =>
      JadwalSholatDioModel(
        code: json["code"],
        status: json["status"],
        data: JadwalSholatDataModel.fromMap(json["data"]),
      );

  String toJson() => json.encode(toMap());

  final int code;
  final String status;
  final JadwalSholatDataModel data;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "code": code,
        "status": status,
        "data": data.toMap(),
      };

  @override
  List<Object?> get props => <Object?>[code, status, data];
}

class JadwalSholatDataModel extends Equatable {
  const JadwalSholatDataModel({
    required this.timings,
  });

  factory JadwalSholatDataModel.fromJson(final String str) =>
      JadwalSholatDataModel.fromMap(json.decode(str));

  factory JadwalSholatDataModel.fromMap(final Map<String, dynamic> json) =>
      JadwalSholatDataModel(
        timings: JadwalSholatModel.fromMap(json["timings"]),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        "timings": timings.toMap(),
      };
  String toJson() => json.encode(toMap());

  final JadwalSholatModel timings;
  @override
  List<Object?> get props => <Object?>[timings];
}

class JadwalSholatModel extends Equatable {
  const JadwalSholatModel({
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

  factory JadwalSholatModel.fromJson(final String str) =>
      JadwalSholatModel.fromMap(json.decode(str));

  factory JadwalSholatModel.fromMap(final Map<String, dynamic> json) =>
      JadwalSholatModel(
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        sunset: json["Sunset"],
        maghrib: json["Maghrib"],
        isha: json["Isha"],
        imsak: json["Imsak"],
        midnight: json["Midnight"],
        firstthird: json["Firstthird"],
        lastthird: json["Lastthird"],
      );

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

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() => <String, dynamic>{
        "Fajr": fajr,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": asr,
        "Sunset": sunset,
        "Maghrib": maghrib,
        "Isha": isha,
        "Imsak": imsak,
        "Midnight": midnight,
        "Firstthird": firstthird,
        "Lastthird": lastthird,
      };

  JadwalSholatEntity toEntity() {
    return JadwalSholatEntity(
      fajr: fajr,
      sunrise: sunrise,
      dhuhr: dhuhr,
      asr: asr,
      sunset: sunset,
      maghrib: maghrib,
      isha: isha,
      imsak: imsak,
      midnight: midnight,
      firstthird: firstthird,
      lastthird: lastthird,
    );
  }

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

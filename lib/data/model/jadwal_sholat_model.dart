import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_app/domain/entity/jadwal_sholat_entity.dart';

class JadwalSholatDioModel extends Equatable {
  final int code;
  final String status;
  final JadwalSholatDataModel data;

  const JadwalSholatDioModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory JadwalSholatDioModel.fromJson(String str) =>
      JadwalSholatDioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JadwalSholatDioModel.fromMap(Map<String, dynamic> json) =>
      JadwalSholatDioModel(
        code: json["code"],
        status: json["status"],
        data: JadwalSholatDataModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "data": data.toMap(),
      };

  @override
  List<Object?> get props => [code, status, data];
}

class JadwalSholatDataModel extends Equatable {
  final JadwalSholatModel timings;

  const JadwalSholatDataModel({
    required this.timings,
  });

  factory JadwalSholatDataModel.fromJson(String str) =>
      JadwalSholatDataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JadwalSholatDataModel.fromMap(Map<String, dynamic> json) =>
      JadwalSholatDataModel(
        timings: JadwalSholatModel.fromMap(json["timings"]),
      );

  Map<String, dynamic> toMap() => {
        "timings": timings.toMap(),
      };

  @override
  List<Object?> get props => [timings];
}

class JadwalSholatModel extends Equatable {
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

  factory JadwalSholatModel.fromJson(String str) =>
      JadwalSholatModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JadwalSholatModel.fromMap(Map<String, dynamic> json) =>
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

  Map<String, dynamic> toMap() => {
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

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';

class ResponseDetailModel extends Equatable {
  final int code;
  final String message;
  final DetailModel data;

  const ResponseDetailModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseDetailModel.fromJson(String str) =>
      ResponseDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseDetailModel.fromMap(Map<String, dynamic> json) =>
      ResponseDetailModel(
        code: json["code"],
        message: json["message"],
        data: DetailModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "data": data.toMap(),
      };

  @override
  List<Object?> get props => [code, message, data];
}

class DetailModel extends Equatable {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;
  final List<AyatDetailModel> ayat;

  const DetailModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
    required this.ayat,
  });

  factory DetailModel.fromJson(String str) =>
      DetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailModel.fromMap(Map<String, dynamic> json) => DetailModel(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audioFull: Map.from(json["audioFull"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        ayat: List<AyatDetailModel>.from(
            json["ayat"].map((x) => AyatDetailModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
        "tempatTurun": tempatTurun,
        "arti": arti,
        "deskripsi": deskripsi,
        "audioFull":
            Map.from(audioFull).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "ayat": List<dynamic>.from(ayat.map((x) => x.toMap())),
      };

  DetailEntity toEntity() {
    return DetailEntity(
        nomor: nomor,
        nama: nama,
        namaLatin: namaLatin,
        jumlahAyat: jumlahAyat,
        tempatTurun: tempatTurun,
        arti: arti,
        deskripsi: deskripsi,
        audioFull: audioFull,
        ayat: ayat.map((x) => x.toEntity()).toList());
  }

  @override
  List<Object?> get props => [
        nomor,
        nama,
        namaLatin,
        jumlahAyat,
        tempatTurun,
        arti,
        deskripsi,
        audioFull,
        ayat
      ];
}

class AyatDetailModel extends Equatable {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audio;

  const AyatDetailModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory AyatDetailModel.fromJson(String str) =>
      AyatDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AyatDetailModel.fromMap(Map<String, dynamic> json) => AyatDetailModel(
        nomorAyat: json["nomorAyat"],
        teksArab: json["teksArab"],
        teksLatin: json["teksLatin"],
        teksIndonesia: json["teksIndonesia"],
        audio: Map.from(json["audio"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toMap() => {
        "nomorAyat": nomorAyat,
        "teksArab": teksArab,
        "teksLatin": teksLatin,
        "teksIndonesia": teksIndonesia,
        "audio": Map.from(audio).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };

  AyatDetailEntity toEntity() {
    return AyatDetailEntity(
      nomorAyat: nomorAyat,
      teksArab: teksArab,
      teksLatin: teksLatin,
      teksIndonesia: teksIndonesia,
      audio: audio,
    );
  }

  @override
  List<Object?> get props =>
      [nomorAyat, teksArab, teksLatin, teksIndonesia, audio];
}

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';

class ResponseDetailModel extends Equatable {
  const ResponseDetailModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseDetailModel.fromJson(final String str) =>
      ResponseDetailModel.fromMap(json.decode(str));

  factory ResponseDetailModel.fromMap(final Map<String, dynamic> json) =>
      ResponseDetailModel(
        code: json["code"],
        message: json["message"],
        data: DetailModel.fromMap(json["data"]),
      );

  final int code;
  final String message;
  final DetailModel data;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => <String, dynamic>{
        "code": code,
        "message": message,
        "data": data.toMap(),
      };

  @override
  List<Object?> get props => <Object>[code, message, data];
}

class DetailModel extends Equatable {
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

  factory DetailModel.fromJson(final String str) =>
      DetailModel.fromMap(json.decode(str));

  factory DetailModel.fromMap(final Map<String, dynamic> json) => DetailModel(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audioFull:
            Map<String, String>.from(json["audioFull"]).map(MapEntry.new),
        ayat: List<AyatDetailModel>.from((json["ayat"])
            .map((final dynamic x) => AyatDetailModel.fromMap(x))),
      );

  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;
  final List<AyatDetailModel> ayat;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => <String, dynamic>{
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
        "tempatTurun": tempatTurun,
        "arti": arti,
        "deskripsi": deskripsi,
        "audioFull": Map<String, String>.from(audioFull).map(MapEntry.new),
        "ayat": List<AyatDetailModel>.from(
            ayat.map((final AyatDetailModel x) => x.toMap())),
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
        ayat: ayat.map((final AyatDetailModel x) => x.toEntity()).toList());
  }

  @override
  List<Object?> get props => <Object>[
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
  const AyatDetailModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory AyatDetailModel.fromJson(final String str) =>
      AyatDetailModel.fromMap(json.decode(str));

  factory AyatDetailModel.fromMap(final Map<String, dynamic> json) =>
      AyatDetailModel(
        nomorAyat: json["nomorAyat"],
        teksArab: json["teksArab"],
        teksLatin: json["teksLatin"],
        teksIndonesia: json["teksIndonesia"],
        audio: Map<String, String>.from(json["audio"]).map(MapEntry.new),
      );

  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audio;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => <String, dynamic>{
        "nomorAyat": nomorAyat,
        "teksArab": teksArab,
        "teksLatin": teksLatin,
        "teksIndonesia": teksIndonesia,
        "audio": Map<String, String>.from(audio).map(MapEntry.new),
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
      <Object>[nomorAyat, teksArab, teksLatin, teksIndonesia, audio];
}

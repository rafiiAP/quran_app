import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';

class SurahaDioModel extends Equatable {
  const SurahaDioModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SurahaDioModel.fromJson(final String str) =>
      SurahaDioModel.fromMap(json.decode(str));

  factory SurahaDioModel.fromMap(final Map<String, dynamic> json) =>
      SurahaDioModel(
        code: json["code"],
        message: json["message"],
        data: List<SurahModel>.from(
            (json["data"]).map((final dynamic x) => SurahModel.fromMap(x))),
      );

  final int code;
  final String message;
  final List<SurahModel> data;

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() => <String, dynamic>{
        "code": code,
        "message": message,
        "data":
            List<SurahModel>.from(data.map((final SurahModel x) => x.toMap())),
      };

  @override
  List<Object?> get props => <Object?>[code, message, data];
}

class SurahModel extends Equatable {
  const SurahModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
  });

  factory SurahModel.fromJson(final String str) =>
      SurahModel.fromMap(json.decode(str));

  factory SurahModel.fromMap(final Map<String, dynamic> json) => SurahModel(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audioFull:
            Map<String, String>.from(json["audioFull"]).map(MapEntry.new),
      );

  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;

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
      };

  SurahEntity toEntity() {
    return SurahEntity(
      nomor: nomor,
      nama: nama,
      namaLatin: namaLatin,
      jumlahAyat: jumlahAyat,
      tempatTurun: tempatTurun,
      arti: arti,
      deskripsi: deskripsi,
      audioFull: audioFull,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        nomor,
        nama,
        namaLatin,
        jumlahAyat,
        tempatTurun,
        arti,
        deskripsi,
        audioFull
      ];
}

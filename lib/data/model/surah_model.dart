import 'dart:convert';

class HTTPModel {
  int? code;
  String? message;
  List<SurahModel>? data;

  HTTPModel({
    this.code,
    this.message,
    this.data,
  });

  factory HTTPModel.fromJson(String str) => HTTPModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HTTPModel.fromMap(Map<String, dynamic> json) => HTTPModel(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<SurahModel>.from(json["data"]!.map((x) => SurahModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class SurahModel {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;
  String? tempatTurun;
  String? arti;
  String? deskripsi;
  Map<String, String>? audioFull;

  SurahModel({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audioFull,
  });

  factory SurahModel.fromJson(String str) => SurahModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SurahModel.fromMap(Map<String, dynamic> json) => SurahModel(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audioFull: Map.from(json["audioFull"]!).map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toMap() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
        "tempatTurun": tempatTurun,
        "arti": arti,
        "deskripsi": deskripsi,
        "audioFull": Map.from(audioFull!).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

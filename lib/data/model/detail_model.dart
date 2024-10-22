import 'dart:convert';

class HttpDetailModel {
  int? code;
  String? message;
  DetailModel? data;

  HttpDetailModel({
    this.code,
    this.message,
    this.data,
  });

  factory HttpDetailModel.fromJson(String str) => HttpDetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HttpDetailModel.fromMap(Map<String, dynamic> json) => HttpDetailModel(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : DetailModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "message": message,
        "data": data?.toMap(),
      };
}

class DetailModel {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;
  String? tempatTurun;
  String? arti;
  String? deskripsi;
  Map<String, String>? audioFull;
  List<AyatModel>? ayat;
  dynamic suratSelanjutnya;
  dynamic suratSebelumnya;

  DetailModel({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audioFull,
    this.ayat,
    this.suratSelanjutnya,
    this.suratSebelumnya,
  });

  factory DetailModel.fromJson(String str) => DetailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DetailModel.fromMap(Map<String, dynamic> json) => DetailModel(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audioFull: Map.from(json["audioFull"]!).map((k, v) => MapEntry<String, String>(k, v)),
        ayat: json["ayat"] == null ? [] : List<AyatModel>.from(json["ayat"]!.map((x) => AyatModel.fromMap(x))),
        suratSelanjutnya: json["suratSelanjutnya"] is bool
            ? json["suratSelanjutnya"]
            : SuratSelanjutnya.fromMap(json["suratSelanjutnya"]),
        suratSebelumnya: json["suratSebelumnya"] is bool
            ? json["suratSebelumnya"]
            : SuratSelanjutnya.fromMap(json["suratSebelumnya"]),
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
        "ayat": ayat == null ? [] : List<dynamic>.from(ayat!.map((x) => x.toMap())),
        "suratSelanjutnya": suratSelanjutnya?.toMap(),
        "suratSebelumnya": suratSebelumnya,
      };
}

class AyatModel {
  int? nomorAyat;
  String? teksArab;
  String? teksLatin;
  String? teksIndonesia;
  Map<String, String>? audio;

  AyatModel({
    this.nomorAyat,
    this.teksArab,
    this.teksLatin,
    this.teksIndonesia,
    this.audio,
  });

  factory AyatModel.fromJson(String str) => AyatModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AyatModel.fromMap(Map<String, dynamic> json) => AyatModel(
        nomorAyat: json["nomorAyat"],
        teksArab: json["teksArab"],
        teksLatin: json["teksLatin"],
        teksIndonesia: json["teksIndonesia"],
        audio: Map.from(json["audio"]!).map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toMap() => {
        "nomorAyat": nomorAyat,
        "teksArab": teksArab,
        "teksLatin": teksLatin,
        "teksIndonesia": teksIndonesia,
        "audio": Map.from(audio!).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class SuratSelanjutnya {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;

  SuratSelanjutnya({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
  });

  factory SuratSelanjutnya.fromJson(String str) => SuratSelanjutnya.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SuratSelanjutnya.fromMap(Map<String, dynamic> json) => SuratSelanjutnya(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
      );

  Map<String, dynamic> toMap() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
      };
}

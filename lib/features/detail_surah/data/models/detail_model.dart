import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_app/core/utils/model_validators.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';

class ResponseDetailModel extends Equatable {
  const ResponseDetailModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseDetailModel.fromJson(final String str) =>
      ResponseDetailModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory ResponseDetailModel.fromMap(final Map<String, dynamic> json) {
    requireField<int>(json, 'code');
    requireField<String>(json, 'message');
    requireField<Map<dynamic, dynamic>>(json, 'data');

    return ResponseDetailModel(
      code: json['code'] as int,
      message: json['message'] as String,
      data: DetailModel.fromMap(json['data'] as Map<String, dynamic>),
    );
  }

  final int code;
  final String message;
  final DetailModel data;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => <String, dynamic>{
        'code': code,
        'message': message,
        'data': data.toMap(),
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
      DetailModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory DetailModel.fromMap(final Map<String, dynamic> json) {
    requireField<int>(json, 'nomor');
    requireField<String>(json, 'nama');
    requireField<String>(json, 'namaLatin');
    requireField<int>(json, 'jumlahAyat');
    requireField<String>(json, 'tempatTurun');
    requireField<String>(json, 'arti');
    requireField<String>(json, 'deskripsi');
    requireField<Map<dynamic, dynamic>>(json, 'audioFull');
    requireField<List<dynamic>>(json, 'ayat');

    final ayatList = json['ayat'] as List<dynamic>;
    for (int i = 0; i < ayatList.length; i++) {
      if (ayatList[i] is! Map<String, dynamic>) {
        throw FormatException(
          'Field "ayat[$i]" expected type Map<String, dynamic>',
        );
      }
    }

    return DetailModel(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      jumlahAyat: json['jumlahAyat'] as int,
      tempatTurun: json['tempatTurun'] as String,
      arti: json['arti'] as String,
      deskripsi: json['deskripsi'] as String,
      audioFull: Map<String, String>.from(
        json['audioFull'] as Map<dynamic, dynamic>,
      ).map(MapEntry.new),
      ayat: ayatList
          .map(
            (final dynamic x) =>
                AyatDetailModel.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
    );
  }

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
        'nomor': nomor,
        'nama': nama,
        'namaLatin': namaLatin,
        'jumlahAyat': jumlahAyat,
        'tempatTurun': tempatTurun,
        'arti': arti,
        'deskripsi': deskripsi,
        'audioFull': Map<String, String>.from(audioFull).map(MapEntry.new),
        'ayat': ayat.map((final AyatDetailModel x) => x.toMap()).toList(),
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
      ayat: ayat.map((final AyatDetailModel x) => x.toEntity()).toList(),
    );
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
        ayat,
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
      AyatDetailModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory AyatDetailModel.fromMap(final Map<String, dynamic> json) {
    requireField<int>(json, 'nomorAyat');
    requireField<String>(json, 'teksArab');
    requireField<String>(json, 'teksLatin');
    requireField<String>(json, 'teksIndonesia');
    requireField<Map<dynamic, dynamic>>(json, 'audio');

    return AyatDetailModel(
      nomorAyat: json['nomorAyat'] as int,
      teksArab: json['teksArab'] as String,
      teksLatin: json['teksLatin'] as String,
      teksIndonesia: json['teksIndonesia'] as String,
      audio: Map<String, String>.from(
        json['audio'] as Map<dynamic, dynamic>,
      ).map(MapEntry.new),
    );
  }

  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audio;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => <String, dynamic>{
        'nomorAyat': nomorAyat,
        'teksArab': teksArab,
        'teksLatin': teksLatin,
        'teksIndonesia': teksIndonesia,
        'audio': Map<String, String>.from(audio).map(MapEntry.new),
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

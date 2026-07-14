import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quran_app/core/utils/model_validators.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';

class SurahaDioModel extends Equatable {
  const SurahaDioModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SurahaDioModel.fromJson(final String str) =>
      SurahaDioModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory SurahaDioModel.fromMap(final Map<String, dynamic> json) {
    requireField<int>(json, 'code');
    requireField<String>(json, 'message');
    requireField<List<dynamic>>(json, 'data');

    final dataList = json['data'] as List<dynamic>;
    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i] is! Map<String, dynamic>) {
        throw FormatException(
          'Field "data[$i]" expected type Map<String, dynamic>',
        );
      }
    }

    return SurahaDioModel(
      code: json['code'] as int,
      message: json['message'] as String,
      data: dataList
          .map(
            (final dynamic x) => SurahModel.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final int code;
  final String message;
  final List<SurahModel> data;

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() => <String, dynamic>{
        'code': code,
        'message': message,
        'data': data.map((final SurahModel x) => x.toMap()).toList(),
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
      SurahModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory SurahModel.fromMap(final Map<String, dynamic> json) {
    requireField<int>(json, 'nomor');
    requireField<String>(json, 'nama');
    requireField<String>(json, 'namaLatin');
    requireField<int>(json, 'jumlahAyat');
    requireField<String>(json, 'tempatTurun');
    requireField<String>(json, 'arti');
    requireField<String>(json, 'deskripsi');
    requireField<Map<dynamic, dynamic>>(json, 'audioFull');

    return SurahModel(
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
        audioFull,
      ];
}

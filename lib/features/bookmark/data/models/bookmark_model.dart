import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';

/// Data model for bookmark persistence (SQLite).
///
/// Handles serialization to/from [Map] for database operations
/// and conversion to the domain [BookmarkEntity].
class BookmarkModel {
  const BookmarkModel({
    this.id,
    required this.nomorSurah,
    required this.namaLatin,
    required this.nomorAyat,
    required this.teksArab,
    required this.teksIndonesia,
    required this.teksLatin,
  });

  /// Creates a [BookmarkModel] from a database row map.
  factory BookmarkModel.fromMap(final Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'] as int?,
      nomorSurah: map['nomor_surah'] as int,
      namaLatin: map['nama_latin'] as String,
      nomorAyat: map['nomor_ayat'] as int,
      teksArab: map['teks_arab'] as String,
      teksIndonesia: map['teks_indonesia'] as String,
      teksLatin: map['teks_latin'] as String,
    );
  }

  final int? id;
  final int nomorSurah;
  final String namaLatin;
  final int nomorAyat;
  final String teksArab;
  final String teksIndonesia;
  final String teksLatin;

  /// Converts to a map suitable for database insertion.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomor_surah': nomorSurah,
      'nama_latin': namaLatin,
      'nomor_ayat': nomorAyat,
      'teks_arab': teksArab,
      'teks_indonesia': teksIndonesia,
      'teks_latin': teksLatin,
    };
  }

  /// Converts to the domain [BookmarkEntity].
  BookmarkEntity toEntity() {
    return BookmarkEntity(
      id: id,
      nomorSurah: nomorSurah,
      namaLatin: namaLatin,
      nomorAyat: nomorAyat,
      teksArab: teksArab,
      teksIndonesia: teksIndonesia,
      teksLatin: teksLatin,
    );
  }
}

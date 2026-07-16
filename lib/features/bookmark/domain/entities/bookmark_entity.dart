import 'package:equatable/equatable.dart';

/// Pure domain entity for a saved bookmark.
///
/// Contains no serialization logic — mapping to/from persistence
/// is handled by [BookmarkModel] in the data layer.
class BookmarkEntity extends Equatable {
  const BookmarkEntity({
    this.id,
    required this.nomorSurah,
    required this.namaLatin,
    required this.nomorAyat,
    required this.teksArab,
    required this.teksIndonesia,
    required this.teksLatin,
  });

  final int? id;
  final int nomorSurah;
  final String namaLatin;
  final int nomorAyat;
  final String teksArab;
  final String teksIndonesia;
  final String teksLatin;

  @override
  List<Object?> get props => <Object?>[
        id,
        nomorSurah,
        namaLatin,
        nomorAyat,
        teksArab,
        teksIndonesia,
        teksLatin,
      ];
}

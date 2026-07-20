import 'package:equatable/equatable.dart';

/// Shared value object for bookmark data input.
///
/// Lives in `core/` to break the cross-feature dependency between
/// `bookmark` and `detail_surah`. Both features can depend on core
/// without depending on each other.
class BookmarkInput extends Equatable {
  const BookmarkInput({
    required this.nomorSurah,
    required this.namaLatin,
    required this.nomorAyat,
    required this.teksArab,
    required this.teksIndonesia,
    required this.teksLatin,
  });

  final int nomorSurah;
  final String namaLatin;
  final int nomorAyat;
  final String teksArab;
  final String teksIndonesia;
  final String teksLatin;

  @override
  List<Object?> get props => <Object?>[
        nomorSurah,
        namaLatin,
        nomorAyat,
        teksArab,
        teksIndonesia,
        teksLatin,
      ];
}

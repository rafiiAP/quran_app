class BookmarkModel {
  /// Constructor utama dengan required parameters
  const BookmarkModel({
    this.id,
    required this.nomorSurah,
    required this.namaLatin,
    required this.nomorAyat,
    required this.teksArab,
    required this.teksIndonesia,
    required this.teksLatin,
  });

  /// Factory method untuk konversi dari Map ke BookmarkModel
  factory BookmarkModel.fromMap(final Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'], // Misalnya ada kolom ID di tabel
      nomorSurah: map['nomor_surah'],
      namaLatin: map['nama_latin'],
      nomorAyat: map['nomor_ayat'],
      teksArab: map['teks_arab'],
      teksIndonesia: map['teks_indonesia'],
      teksLatin: map['teks_latin'],
    );
  }

  final int?
      id; // Optional karena ID biasanya otomatis di-generate oleh database
  final int nomorSurah;
  final String namaLatin;
  final int nomorAyat;
  final String teksArab;
  final String teksIndonesia;
  final String teksLatin;

  /// Konversi dari objek ke Map (untuk database)
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
}

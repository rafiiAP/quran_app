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
      id: map['id'] as int?,
      nomorSurah: map['nomor_surah'] as int,
      namaLatin: map['nama_latin'] as String,
      nomorAyat: map['nomor_ayat'] as int,
      teksArab: map['teks_arab'] as String,
      teksIndonesia: map['teks_indonesia'] as String,
      teksLatin: map['teks_latin'] as String,
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

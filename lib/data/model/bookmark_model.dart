class BookmarkModel {
  int? id; // Optional karena ID biasanya otomatis di-generate oleh database
  int nomorSurah;
  String namaLatin;
  int nomorAyat;
  String teksArab;
  String teksIndonesia;
  String teksLatin;

  BookmarkModel({
    this.id,
    required this.nomorSurah,
    required this.namaLatin,
    required this.nomorAyat,
    required this.teksArab,
    required this.teksIndonesia,
    required this.teksLatin,
  });

  // Untuk mengonversi dari Map (database) ke objek BookmarkModel
  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
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

  // Untuk mengonversi dari objek BookmarkModel ke Map (untuk disimpan ke database)
  Map<String, dynamic> toMap() {
    return {
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

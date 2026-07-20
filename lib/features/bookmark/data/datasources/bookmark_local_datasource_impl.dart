import 'package:quran_app/core/models/bookmark_input.dart';
import 'package:quran_app/core/storage/database_helper.dart';
import 'package:quran_app/features/bookmark/data/datasources/bookmark_local_datasource.dart';

/// Concrete [BookmarkLocalDatasource] implementation backed by SQLite.
///
/// Encapsulates the raw map serialization that was previously
/// spread across the repository.
class BookmarkLocalDatasourceImpl implements BookmarkLocalDatasource {
  const BookmarkLocalDatasourceImpl({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  final DatabaseHelper _databaseHelper;

  @override
  Future<bool> insertBookmark(BookmarkInput input) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'nomor_surah': input.nomorSurah,
      'nama_latin': input.namaLatin,
      'nomor_ayat': input.nomorAyat,
      'teks_arab': input.teksArab,
      'teks_indonesia': input.teksIndonesia,
      'teks_latin': input.teksLatin,
    };
    return _databaseHelper.insertBookmark(data);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBookmarks() {
    return _databaseHelper.getAllBookmarks();
  }

  @override
  Future<void> deleteBookmark(String teksIndonesia) {
    return _databaseHelper.deleteBookmark(teksIndonesia);
  }
}

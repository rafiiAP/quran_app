import 'dart:async';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:quran_app/injection.dart';
import 'package:sqflite/sqflite.dart';

DatabaseHelper get databaseHelper => locator<DatabaseHelper>();

class DatabaseHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final String path = await getDatabasesPath();
    final String dbPath = join(path, 'surah.db');

    return await openDatabase(dbPath, version: 1, onCreate: _createDb);
  }

  void _createDb(final Database db, final int version) async {
    // Create bookmark table
    await db.execute('''
      CREATE TABLE bookmark(
        nomor_surah INTEGER,
        nama_latin TEXT,
        nomor_ayat INTEGER,
        teks_arab TEXT,
        teks_indonesia TEXT PRIMARY KEY,
        teks_latin TEXT
      )
    ''');
  }

  // Insert data into tables
  void insertOrUpdateBookmark(final AyatDetailEntity ayatDetailEntity,
      final DetailEntity detailEntity) async {
    final Database dbClient = await db;

    // Cek apakah data dengan nama_latin tertentu sudah ada
    final List<Map<dynamic, dynamic>> existingData = await dbClient.query(
      'bookmark',
      where: 'teks_indonesia = ?',
      whereArgs: <Object>[ayatDetailEntity.teksIndonesia],
    );

    if (existingData.isEmpty) {
      // Jika tidak ada data, lakukan insert
      await dbClient.insert(
        'bookmark',
        <String, Object?>{
          "nomor_surah": detailEntity.nomor,
          "nama_latin": detailEntity.namaLatin,
          "nomor_ayat": ayatDetailEntity.nomorAyat,
          "teks_arab": ayatDetailEntity.teksArab,
          "teks_indonesia": ayatDetailEntity.teksIndonesia,
          "teks_latin": ayatDetailEntity.teksLatin,
        },
      );
      Get.snackbar('Sukses', 'Data berhasil disimpan');
    } else {
      Get.snackbar('Oops', 'Data sudah ada');
    }
  }

  // Get all data from tables
  Future<List<BookmarkModel>> getAllBookmarks() async {
    final Database dbClient = await db;

    // Ambil semua data dari tabel 'bookmark'
    final List<Map<String, dynamic>> maps = await dbClient.query('bookmark');

    // Konversi List<Map<String, dynamic>> menjadi List<BookmarkModel>
    return List<BookmarkModel>.generate(
        maps.length, (final int index) => BookmarkModel.fromMap(maps[index]));
  }

  void deleteBookmark(final String teksIndonesia) async {
    final Database dbClient = await db;

    // Hapus data berdasarkan nama_latin
    await dbClient.delete(
      'bookmark',
      where: 'teks_indonesia = ?',
      whereArgs: <Object>[teksIndonesia],
    );
  }

  // Close database
  void close() async {
    final Database dbClient = await db;
    await dbClient.close();
  }
}

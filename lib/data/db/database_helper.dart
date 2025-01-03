import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/domain/entity/detail_entity.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, 'surah.db');

    return await openDatabase(dbPath, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
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
  insertOrUpdateBookmark(AyatDetailEntity ayatDetailEntity, DetailEntity detailEntity) async {
    final dbClient = await db;

    // Cek apakah data dengan nama_latin tertentu sudah ada
    List<Map> existingData = await dbClient.query(
      'bookmark',
      where: 'teks_indonesia = ?',
      whereArgs: [ayatDetailEntity.teksIndonesia],
    );

    C.showLog(log: '---> $existingData');

    if (existingData.isEmpty) {
      // Jika tidak ada data, lakukan insert
      await dbClient.insert(
        'bookmark',
        {
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
    final dbClient = await db;

    // Ambil semua data dari tabel 'bookmark'
    final List<Map<String, dynamic>> maps = await dbClient.query('bookmark');

    // Konversi List<Map<String, dynamic>> menjadi List<BookmarkModel>
    return List.generate(maps.length, (index) {
      return BookmarkModel.fromMap(maps[index]);
    });
  }

  deleteBookmark(String teksIndonesia) async {
    final dbClient = await db;

    // Hapus data berdasarkan nama_latin
    return await dbClient.delete(
      'bookmark',
      where: 'teks_indonesia = ?',
      whereArgs: [teksIndonesia],
    );
  }

  // Close database
  Future close() async {
    final dbClient = await db;
    dbClient.close();
  }
}

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Low-level SQLite database helper.
///
/// Provides generic CRUD operations on the bookmark table.
/// Does NOT depend on any feature-layer entities or models — all data
/// is exchanged as raw [Map<String, dynamic>] to keep core decoupled.
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

  /// Inserts a bookmark row if it doesn't already exist.
  ///
  /// Returns `true` if inserted (new), `false` if already exists (duplicate).
  /// The [data] map must contain keys matching the bookmark table columns.
  Future<bool> insertBookmark(Map<String, dynamic> data) async {
    final Database dbClient = await db;

    final List<Map<dynamic, dynamic>> existingData = await dbClient.query(
      'bookmark',
      where: 'teks_indonesia = ?',
      whereArgs: <Object>[data['teks_indonesia'] as Object],
    );

    if (existingData.isEmpty) {
      await dbClient.insert('bookmark', data);
      return true;
    }
    return false;
  }

  /// Returns all bookmark rows as a list of maps.
  Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    final Database dbClient = await db;
    return dbClient.query('bookmark');
  }

  /// Deletes the bookmark row matching [teksIndonesia].
  Future<void> deleteBookmark(final String teksIndonesia) async {
    final Database dbClient = await db;
    await dbClient.delete(
      'bookmark',
      where: 'teks_indonesia = ?',
      whereArgs: <Object>[teksIndonesia],
    );
  }

  /// Closes the database connection.
  void close() async {
    final Database dbClient = await db;
    await dbClient.close();
  }
}

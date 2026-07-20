import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/models/bookmark_input.dart';
import 'package:quran_app/core/storage/database_helper.dart';
import 'package:quran_app/features/bookmark/data/models/bookmark_model.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';

/// [BookmarkRepository] implementation backed by [DatabaseHelper].
///
/// Maps between domain entities and raw database maps, keeping the
/// core storage layer decoupled from feature-specific types.
class BookmarkRepositoryImpl implements BookmarkRepository {
  const BookmarkRepositoryImpl({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  final DatabaseHelper _databaseHelper;

  @override
  Future<Either<Failure, bool>> insertOrUpdateBookmark(
    final BookmarkInput input,
  ) async {
    try {
      final Map<String, dynamic> data = <String, dynamic>{
        'nomor_surah': input.nomorSurah,
        'nama_latin': input.namaLatin,
        'nomor_ayat': input.nomorAyat,
        'teks_arab': input.teksArab,
        'teks_indonesia': input.teksIndonesia,
        'teks_latin': input.teksLatin,
      };
      final bool isNew = await _databaseHelper.insertBookmark(data);
      return Right(isNew);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkEntity>>> getAllBookmarks() async {
    try {
      final List<Map<String, dynamic>> maps =
          await _databaseHelper.getAllBookmarks();
      final List<BookmarkEntity> entities = maps
          .map(
            (final Map<String, dynamic> map) =>
                BookmarkModel.fromMap(map).toEntity(),
          )
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBookmark(
    final String teksIndonesia,
  ) async {
    try {
      await _databaseHelper.deleteBookmark(teksIndonesia);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

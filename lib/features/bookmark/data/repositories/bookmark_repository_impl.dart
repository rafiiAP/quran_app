import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/models/bookmark_input.dart';
import 'package:quran_app/features/bookmark/data/datasources/bookmark_local_datasource.dart';
import 'package:quran_app/features/bookmark/data/models/bookmark_model.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';

/// [BookmarkRepository] implementation backed by [BookmarkLocalDatasource].
///
/// Delegates raw persistence to the datasource layer, keeping the
/// repository focused on error mapping and entity conversion.
class BookmarkRepositoryImpl implements BookmarkRepository {
  const BookmarkRepositoryImpl({required BookmarkLocalDatasource datasource})
      : _datasource = datasource;

  final BookmarkLocalDatasource _datasource;

  @override
  Future<Either<Failure, bool>> insertOrUpdateBookmark(
    final BookmarkInput input,
  ) async {
    try {
      final bool isNew = await _datasource.insertBookmark(input);
      return Right(isNew);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkEntity>>> getAllBookmarks() async {
    try {
      final List<Map<String, dynamic>> maps =
          await _datasource.getAllBookmarks();
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
      await _datasource.deleteBookmark(teksIndonesia);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

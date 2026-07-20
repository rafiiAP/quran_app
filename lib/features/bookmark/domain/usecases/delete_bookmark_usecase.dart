import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/core/usecases/usecase.dart';
import 'package:quran_app/features/bookmark/domain/repositories/bookmark_repository.dart';

/// Use case for deleting a bookmark by its database ID.
class DeleteBookmarkUseCase extends UseCase<void, int> {
  const DeleteBookmarkUseCase(this._repository);
  final BookmarkRepository _repository;

  @override
  Future<Either<Failure, void>> call(int id) {
    return _repository.deleteBookmark(id);
  }
}

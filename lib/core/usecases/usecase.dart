import 'package:fpdart/fpdart.dart';
import 'package:quran_app/core/error/failure.dart';

/// Base class for use cases that require parameters.
///
/// [Result] is the return value type (wrapped in `Either<Failure, Result>`).
/// [Params] is the parameter object passed to [call].
///
/// Example:
/// ```dart
/// class GetDetailSurahUseCase extends UseCase<DetailEntity, int> {
///   Future<Either<Failure, DetailEntity>> call(int nomor) { ... }
/// }
/// ```
abstract class UseCase<Result, Params> {
  const UseCase();
  Future<Either<Failure, Result>> call(Params params);
}

/// Base class for use cases that require no parameters.
///
/// [Result] is the return value type (wrapped in `Either<Failure, Result>`).
///
/// Example:
/// ```dart
/// class GetSurahUseCase extends UseCaseNoParams<List<SurahEntity>> {
///   Future<Either<Failure, List<SurahEntity>>> call() { ... }
/// }
/// ```
abstract class UseCaseNoParams<Result> {
  const UseCaseNoParams();
  Future<Either<Failure, Result>> call();
}

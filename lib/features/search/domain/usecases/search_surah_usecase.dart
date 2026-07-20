import 'package:quran_app/core/utils/input_validator.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';

/// Use case for searching surahs by name.
///
/// Encapsulates the search/filter logic in the domain layer,
/// keeping it testable without widget dependencies and following
/// the single-responsibility principle.
class SearchSurahUseCase {
  const SearchSurahUseCase();

  /// Filters [surahList] by [query], matching against [SurahEntity.namaLatin].
  ///
  /// Returns an empty list if [query] is empty after sanitization.
  List<SurahEntity> call({
    required List<SurahEntity> surahList,
    required String query,
  }) {
    final String sanitized = InputValidator.sanitizeQuery(query);

    if (sanitized.isEmpty) {
      return const [];
    }

    return surahList
        .where(
          (final SurahEntity e) =>
              e.namaLatin.toLowerCase().contains(sanitized.toLowerCase()),
        )
        .toList();
  }
}

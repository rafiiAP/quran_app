/// Utility class for sanitizing and validating user inputs.
///
/// Provides defensive string handling to ensure user-provided data
/// is clean before being processed by business logic.
class InputValidator {
  const InputValidator._();

  /// Sanitizes a search query by trimming whitespace and collapsing
  /// multiple spaces into one.
  ///
  /// Returns an empty string if input is null or only whitespace.
  static String sanitizeQuery(String? input) {
    if (input == null) return '';
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Returns true if the given [query] is non-empty after sanitization.
  static bool isValidQuery(String? query) {
    return sanitizeQuery(query).isNotEmpty;
  }

  /// Validates that a surah number is within the valid range (1–114).
  static bool isValidSurahNumber(int? nomor) {
    if (nomor == null) return false;
    return nomor >= 1 && nomor <= 114;
  }

  /// Validates that an ayat number is positive.
  static bool isValidAyatNumber(int? nomorAyat) {
    if (nomorAyat == null) return false;
    return nomorAyat >= 1;
  }
}

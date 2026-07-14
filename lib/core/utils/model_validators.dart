/// Shared validation helpers for Model.fromMap factories.
///
/// Throws [FormatException] with a descriptive message containing
/// the field name when validation fails.
library;

/// Validates that [json] contains a non-null value for [fieldName]
/// and that the value is of type [T].
///
/// Throws [FormatException] if:
/// - The key is absent from the map
/// - The value is null
/// - The value's runtime type does not match [T]
void requireField<T>(Map<String, dynamic> json, String fieldName) {
  if (!json.containsKey(fieldName) || json[fieldName] == null) {
    throw FormatException('Missing required field: $fieldName');
  }
  if (json[fieldName] is! T) {
    throw FormatException(
      'Field "$fieldName" expected type $T but got ${json[fieldName].runtimeType}',
    );
  }
}

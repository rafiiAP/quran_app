// Typed exceptions thrown by datasources.
//
// Repositories catch these and map them to [Failure] subtypes.
// This keeps Dio isolated at the datasource level.

/// Thrown when a network/connection error occurs (timeout, no internet, etc.)
class ConnectionException implements Exception {
  const ConnectionException(this.message);
  final String message;

  @override
  String toString() => 'ConnectionException: $message';
}

/// Thrown when the server returns an unexpected response or parsing fails.
class ServerException implements Exception {
  const ServerException(this.message);
  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when a local cache operation fails (read, write, or parse error).
class CacheException implements Exception {
  const CacheException(this.message);
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

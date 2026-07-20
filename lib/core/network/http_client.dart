/// Abstract HTTP client — dapat di-mock di unit test.
abstract class AppHttpClient {
  /// Melakukan GET request ke [url] dan mengembalikan response body sebagai String JSON.
  Future<String> get({
    required String url,
    required String requestName,
  });

  /// Melakukan POST request ke [url] dengan [body] dan mengembalikan response body sebagai String JSON.
  Future<String> post({
    required String url,
    required String requestName,
    required Map<String, dynamic> body,
  });
}

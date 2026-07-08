import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/datasources/http_client.dart';

/// Concrete implementation yang mendelegasikan ke [MainFunction.dioGet].
class MainHttpClient implements AppHttpClient {
  @override
  Future<String> get({
    required final String url,
    required final String requestName,
  }) {
    return C.dioGet(url: url, requestName: requestName);
  }
}

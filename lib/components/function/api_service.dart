part of 'main_function.dart';

mixin ApiService {
  Future<String> dioGet({
    required final String url,
    required final String requestName,
  }) async {
    final dio.Dio myDio = dio.Dio();
    dynamic cResponse;
    try {
      C.showLog(log: '$requestName : $url');
      final dio.Response<dynamic> response = await myDio.get(url);
      cResponse = response.data;
      C.showLog(log: '$requestName response : $cResponse');
    } on dio.DioException catch (e) {
      C.showLog(log: '--${e.response}\n-${e.message}');
      switch (e.type) {
        case dio.DioExceptionType.connectionTimeout:
          await W
              .messageInfo(message: 'Koneksi timeout, periksa jaringan Anda')
              .then(
                (value) async =>
                    await dioGet(url: url, requestName: requestName),
              );
          throw Exception('Koneksi timeout, periksa jaringan Anda');
        case dio.DioExceptionType.sendTimeout:
          await W
              .messageInfo(message: 'Koneksi timeout, periksa jaringan Anda')
              .then(
                (value) async =>
                    await dioGet(url: url, requestName: requestName),
              );
          throw Exception('Koneksi timeout, periksa jaringan Anda');
        case dio.DioExceptionType.receiveTimeout:
          await W
              .messageInfo(message: 'Koneksi timeout, periksa jaringan Anda')
              .then(
                (value) async =>
                    await dioGet(url: url, requestName: requestName),
              );
          break;
        case dio.DioExceptionType.badCertificate:
          throw Exception('Koneksi timeout, periksa jaringan Anda');
        case dio.DioExceptionType.badResponse:
          throw Exception(
            'Terjadi kesalahan dari server: ${e.response?.statusCode}',
          );
        case dio.DioExceptionType.cancel:
          await W.messageInfo(message: 'Permintaan dibatalkan');
          break;
        case dio.DioExceptionType.connectionError:
          await W
              .messageInfo(
                message: 'Tidak dapat terhubung ke server, coba lagi',
              )
              .then(
                (value) async =>
                    await dioGet(url: url, requestName: requestName),
              );
          throw Exception('Tidak dapat terhubung ke server');
        case dio.DioExceptionType.unknown:
          throw Exception('Terjadi kesalahan, coba lagi nanti');
      }
    }
    C.showLog(log: '$requestName response : $cResponse');
    return jsonEncode(cResponse);
  }
}

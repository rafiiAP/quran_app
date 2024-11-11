part of 'main_function.dart';

mixin ApiService {
  Future<String> dioGet({required String url, required String requestName}) async {
    http.Dio dio = http.Dio();
    dynamic cResponse;
    try {
      C.showLog(log: '$requestName : $url');
      http.Response response = await dio.get(url!);
      cResponse = response.data;
      C.showLog(log: '$requestName response : $cResponse');
    } on http.DioException catch (e) {
      C.showLog(log: '--${e.response}\n-${e.message}');
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          W.messageInfo(message: 'Koneksi timeout, periksa jaringan Anda').then((_) {
            return dioGet(url: url, requestName: requestName);
          });
        case DioExceptionType.badResponse:
          throw 'Terjadi kesalahan dari server: ${e.response?.statusCode}';
        default:
          throw 'Terjadi kesalahan, coba lagi nanti';
      }
    }
    C.showLog(log: '$requestName response : $cResponse');
    return jsonEncode(cResponse);
  }

  // Future getSholat({required double latitude, required double longitude, required String url}) async {
  //   http.Dio dio = http.Dio();
  //   http.Response response;
  //   Uri.parse('https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2');
  //   try {
  //     response = await dio.get('/timings', queryParameters: {
  //       'latitude': latitude,
  //       'longitude': longitude,
  //       'method': 20,
  //     }).timeout(
  //       Duration(seconds: 30),
  //     );
  //   } on TimeoutException {
  //   } on http.DioException {
  //   } catch (e) {}
  // }

  Future<String> sendHTTPost({
    required String url,
    required String request,
    String requestName = "",
    String deviceID = "",
    String authorization = "",
    // bool useOAuth = true,
    // String versiSertifikatOAuth = "",
    // bool refreshTokenOAuth = true,
    int? timeoutDuration = 30,
  }) async {
    // String enp = await C.getDeviceInfo();
    String cResponse = "";
    if (requestName.isEmpty) requestName = url;
    try {
      // C.showLog(log: '--$enp');
      http.Dio client = http.Dio();
      http.FormData data = http.FormData.fromMap({
        // "cCode": request,
        // "DEVICEID": deviceID,
        // "ENP": enp,
        // "PLATFORM": C.operatingSystem,
        // "VERSIAPLIKASI": versiSertifikatOAuth,
      });
      Map<String, dynamic> headers = <String, dynamic>{
        "Authorization": authorization,
      };
      C.showLog(log: "$requestName Request: $request");
      C.showLog(log: "$requestName URL: $url");
      http.Response response = await client
          .post(
            url,
            data: data,
            options: http.Options(
              headers: headers,
            ),
          )
          .timeout(Duration(
            seconds: timeoutDuration!,
          ));

      // cResponse = C.jsonencode(object: response.data);
      C.showLog(log: "$requestName Response: $response");
    } on TimeoutException {
      C.showLog(log: '--Timeout');
      W.messageInfo(message: 'Timeout, coba lagi').then((value) async {
        return sendHTTPost(
          url: url,
          request: request,
          deviceID: deviceID,
          // versiSertifikatOAuth: versiSertifikatOAuth,
          authorization: authorization,
          // useOAuth: useOAuth,
          timeoutDuration: timeoutDuration,
          requestName: requestName,
          // refreshTokenOAuth: refreshTokenOAuth,
        );
      });
    } on http.DioException catch (e) {
      C.showLog(log: '--DioException ${e.message}');
      // jika tidak mendapat respon
      // cErrorMSG = "";
      // lShowErrorMSG = true;
      // if (e.response != null) {
      //   cErrorMSG = "${e.response?.statusCode} ${e.response?.statusMessage}";
      //   C.showLog(
      //     log: "$requestName responseError: ${e.response?.statusCode} ${e.response?.statusMessage}",
      //   );
      //   C.showLog(
      //     log: "$requestName responseError: ${e.response?.data}",
      //   );
      //   if (useOAuth) {
      //     if (e.response?.statusCode == 401) {

      //       String cRefreshToken = C.getString(cKey: AppConfig.cacheRefreshToken);
      //       String cRespRefreshToken = await getRefreshToken(
      //         url: AppConfig.cURLRefreshTokenOAuth,
      //         deviceID: deviceID,
      //         authorization: "Bearer $cRefreshToken",
      //         versiSertifikatOAuth: versiSertifikatOAuth,
      //       );
      //       Map<String, dynamic> vaRespRefreshToken = jsonDecode(cRespRefreshToken);
      //       if (vaRespRefreshToken["Status"] == 1) {

      //         cErrorMSG = "";
      //         lShowErrorMSG = false;

      //         OAuthModel result = OAuthModel.fromJson(vaRespRefreshToken["Data"]);
      //         String cAccessToken = result.accessToken ?? "";
      //         String cRefreshToken = result.refreshToken ?? "";
      //         C.setString(cKey: AppConfig.cacheAksesToken, cValue: cAccessToken);
      //         C.setString(cKey: AppConfig.cacheRefreshToken, cValue: cRefreshToken);
      //         authorization = "Bearer $cAccessToken";

      //         return sendHTTPost(
      //           url: url,
      //           request: request,
      //           requestName: requestName,
      //           deviceID: deviceID,
      //           authorization: authorization,
      //           useOAuth: useOAuth,
      //           versiSertifikatOAuth: versiSertifikatOAuth,
      //           refreshTokenOAuth: false,
      //           timeoutDuration: timeoutDuration,
      //         );
      //       }
      //       // }
      //     }
      //   }
      // } else {
      //   cErrorMSG = e.message;
      //   C.showLog(
      //     log: "$requestName requestError: $cErrorMSG ${e.response}",
      //   );
      // }
    }
    // if (lShowErrorMSG) {
    //   W.showSnackBar(
    //     title: "Terjadi Kesalahan",
    //     message: cErrorMSG,
    //     backgroundColor: Colors.red[100],
    //     icon: const Icon(Icons.wifi),
    //     margin: const EdgeInsets.all(20.0),
    //   );
    // }
    return cResponse;
  }

  /// fungsi untuk mengirimkan request access token ke switching
  // Future<String> getAccessToken({
  //   required String url,
  //   required String deviceID,
  //   int? timeoutDuration = 60,
  //   String authorization = "",
  //   String versiSertifikatOAuth = "",
  // }) async {
  //   String enp = await C.getDeviceInfo();
  //   String cResponse = "";
  //   String requestName = "getAccessToken";
  //   try {
  //     http.Dio client = http.Dio();
  //     http.FormData data = http.FormData.fromMap({
  //       "DEVICEID": deviceID,
  //       "ENP": enp,
  //       "PLATFORM": C.operatingSystem,
  //       "VERSIAPLIKASI": versiSertifikatOAuth,
  //     });
  //     Map<String, dynamic> headers = <String, dynamic>{
  //       "Authorization": authorization,
  //     };
  //     C.showLog(log: "$requestName URL: $url");
  //     http.Response response = await client
  //         .post(
  //           url,
  //           data: data,
  //           options: http.Options(
  //             headers: headers,
  //           ),
  //         )
  //         .timeout(Duration(
  //           seconds: timeoutDuration!,
  //         ));
  //     cResponse = response.data;
  //     C.showLog(log: "$requestName Response: $response");
  //   }  TimeoutException {
  //     String cData = '{"error":"true", "MSG": "TIMEOUT"}';
  //     cResponse = cData;
  //   } on http.DioError catch (e) {
  //     if (e.response != null) {
  //       C.showLog(
  //         log: "$requestName responseError: ${e.response?.statusCode} ${e.response?.statusMessage}",
  //       );
  //       C.showLog(
  //         log: "$requestName responseError: ${e.response?.data}",
  //       );
  //     } else {
  //       C.showLog(
  //         log: "$requestName requestError: ${e.message}",
  //       );
  //     }
  //   }
  //   return cResponse;
  // }

  // /// fungsi untuk mengirimkan request refresh token ke switching
  // Future<String> getRefreshToken({
  //   required String url,
  //   required String deviceID,
  //   String authorization = "",
  //   String versiSertifikatOAuth = "",
  // }) async {
  //   String enp = await C.getDeviceInfo();
  //   String cResponse = "";
  //   String requestName = "getRefreshToken";
  //   try {
  //     http.Dio client = http.Dio();
  //     http.FormData data = http.FormData.fromMap({
  //       "DEVICEID": deviceID,
  //       "ENP": enp,
  //       "PLATFORM": C.operatingSystem,
  //       "VERSIAPLIKASI": versiSertifikatOAuth,
  //     });
  //     Map<String, dynamic> headers = <String, dynamic>{
  //       "Authorization": authorization,
  //     };
  //     C.showLog(log: "$requestName URL: $url");
  //     http.Response response = await client.post(
  //       url,
  //       data: data,
  //       options: http.Options(
  //         headers: headers,
  //       ),
  //     );
  //     cResponse = response.data;
  //     // C.showLog(log: "$requestName Response: $response");
  //   } on http.DioError catch (e) {
  //     if (e.response != null) {
  //       C.showLog(
  //         log: "$requestName responseError: ${e.response?.statusCode} ${e.response?.statusMessage}",
  //       );
  //       C.showLog(
  //         log: "$requestName responseError: ${e.response?.data}",
  //       );
  //     } else {
  //       C.showLog(
  //         log: "$requestName requestError: ${e.message}",
  //       );
  //     }
  //   }
  //   return cResponse;
  // }
}

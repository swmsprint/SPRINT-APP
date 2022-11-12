import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/screens/login_page.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

Future<Dio> authDio(BuildContext context) async {
  var dio = Dio();
  final storage = new FlutterSecureStorage();

  dio.interceptors.clear();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final accessToken = await storage.read(key: 'accessToken');
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }, onError: (error, handler) async {
    if (error.response?.statusCode == 401) {
      //401:Access Token 만료
      print("Access Token 만료, Refresh 시도");
      final refreshToken = await storage.read(key: 'refreshToken');
      final userID = await storage.read(key: 'userID');

      var refreshDio = Dio();
      refreshDio.interceptors.clear();
      refreshDio.interceptors
          .add(InterceptorsWrapper(onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // 401: Refresh Token 만료
          print("Refresh Token 만료, 로그인 다시 실행");
          await storage.deleteAll();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (route) => false);
          return;
        }
        return handler.next(error);
      }));

      final refreshResponse = await refreshDio.get('$serverurl/oauth2/re-issue',
          queryParameters: {'refreshToken': refreshToken, 'userId': userID});
      final newAccessToken = refreshResponse.data['accessToken'];
      final newRefreshToken = refreshResponse.data['refreshToken'];
      await storage.write(key: 'accessToken', value: newAccessToken);
      await storage.write(key: 'refreshToken', value: newRefreshToken);
      print("Access Token Refresh 완료");
      print("New Access Token: $newAccessToken");
      print("New Refresh Token: $newRefreshToken");
      error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final clonedRequest = await dio.request(error.requestOptions.path,
          options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);
      return handler.resolve(clonedRequest);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('에러가 발생했습니다 (${error.response?.statusCode}). 다시 시도해 주세요.'),
      ));
    }
    return handler.next(error);
  }));
  return dio;
}

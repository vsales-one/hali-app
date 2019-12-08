import 'package:dio/dio.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/di/appModule.dart';

class RestClient {
  static Dio create() {
    final client = Dio()
      ..options = BaseOptions(
          baseUrl: kBaseUrl, connectTimeout: 5000, receiveTimeout: 5000)
      ..interceptors.add(AuthInterceptor())
      ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true))
      ..interceptors.add(InterceptorsWrapper(onError: (DioError e) {
        print(e);
        return e;
      }));
    return client;
  }
}

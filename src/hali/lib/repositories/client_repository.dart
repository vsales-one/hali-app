import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hali/constatns/constants.dart';

class ClientRepository {
  static Future<Dio> create() async {
    var accessToken = await AccessTokenUtils.getMobileToken();
    var token = accessToken.length > 0 ? "Bearer " + accessToken : '';
    final client = Dio(BaseOptions(baseUrl: kBaseUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': token
    }));
    client.interceptors.add(LogInterceptor(
      request: false, 
      requestHeader: false, 
      requestBody: false,
      responseHeader: false, 
      responseBody: false
    ));
    client.options.contentType = "application/x-www-form-urlencoded";

    client.interceptors.add(InterceptorsWrapper(
        onRequest:(RequestOptions options) {
          // Do something before request is sent
          return options; //continue
          // If you want to resolve the request with some custom data，
          // you can return a `Response` object or return `dio.resolve(data)`.
          // If you want to reject the request with a error message,
          // you can return a `DioError` object or return `dio.reject(errMsg)`
        },
        onResponse:(Response response) {
          // Do something with response data
          return response; // continue
        },
        onError: (DioError e) {          
          return e;//continue
        }
    ));
    return client;
  }

  static Future<Dio> createMultipart() async {
    var accessToken = await AccessTokenUtils.getMobileToken();
    var token = accessToken.length > 0 ? "Bearer " + accessToken : '';
    final client = Dio(BaseOptions(baseUrl: kBaseUrl, headers: {
      'Content-Type': 'multipart/form-data',
      'Authorization': token
    }));
    client.interceptors.add(LogInterceptor());
    client.options.contentType = "multipart/form-data";
    return client;
  }

  static Future<Dio> createFile() async {
    var accessToken = await AccessTokenUtils.getMobileToken();
    var token = accessToken.length > 0 ? "Bearer " + accessToken : '';
    final client = Dio(BaseOptions(baseUrl: kBaseUrl, headers: {
      'Content-Type': 'application/json',
      'Authorization': token
    }));
    client.interceptors.add(LogInterceptor());
    client.options.contentType = "application/json";
    client.options.responseType = ResponseType.bytes;
    return client;
  }

}

class AccessTokenUtils {
  
  static Future<String> getMobileToken() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(kAccess_token) ?? '';
  }

  // static Future<LoginResponse> getMobileTokenObject() async {
  //   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   final SharedPreferences prefs = await _prefs;
  //   final tokenJson = prefs.getString(kLoginTokenObject) ?? '';
  //   if(tokenJson.isEmpty) {
  //     return null;
  //   }
  //   return jsonDecode(tokenJson);
  // }

}
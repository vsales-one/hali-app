import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:hali/commons/shared_preferences.dart';
import 'package:hali/config/application.dart';
import 'package:hali/config/routes.dart';
import 'package:hali/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';

/// AuthInterceptor
///
class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    final token = spUtil.getString(KEY_TOKEN);
    options.headers.update("X-Firebase-Auth", (_) => token, ifAbsent: () => token);
    return super.onRequest(options);
  }
}

final dio = Dio()
  ..options = BaseOptions(baseUrl: baseUrl, connectTimeout: 5000, receiveTimeout: 5000)
  ..interceptors.add(AuthInterceptor())
  ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

final FirebaseStorage storage = FirebaseStorage(app: FirebaseApp.instance, 
    storageBucket: kFirebaseStorageBucket);
    
SpUtil spUtil;

final appModule = [];
/// init
///
init() async {
  spUtil = await SpUtil.getInstance();
  // DartIn start

  // init router
  final router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
}

// init logger
var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);



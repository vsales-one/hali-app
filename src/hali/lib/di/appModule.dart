import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:hali/commons/shared_preferences.dart';
import 'package:hali/commons/user_manager.dart';
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
    final token = spUtil.getString(kFirebaseAuthToken);
    options.headers.update("X-Firebase-Auth", (_) => token, ifAbsent: () => token);
    return super.onRequest(options);
  }
}

/// AuthInterceptor
///
class HeaderInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    options.headers["Content-Type"] = "application/json";
    return super.onRequest(options);
  }
}

/// AuthInterceptor
///
class TokeInterceptor extends Interceptor {

  @override
  Future onError(DioError error) async {
    if (error.response != null && error.response.statusCode == 401) {
        dio.lock();
        // get refresh token
        final user = await FirebaseAuth.instance.currentUser();
        IdTokenResult idTokenResult = await user.getIdToken(refresh: true);
        if(idTokenResult != null) {
          logger.e("Refresh token: ", idTokenResult);
          spUtil.putString(kFirebaseAuthToken, idTokenResult.token);
        }
        dio.unlock();
    }
    return super.onError(error);
  }
}

final dio = Dio()
  ..options = BaseOptions(baseUrl: kBaseUrl, connectTimeout: 5000, receiveTimeout: 5000)
  ..interceptors.add(AuthInterceptor())
  ..interceptors.add(HeaderInterceptor())
  ..interceptors.add(TokeInterceptor())
  ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true))
  ..interceptors.add(InterceptorsWrapper(
      onError: (DioError e) {
        print(e);
        return e;
      }
  ));

final FirebaseStorage storage = FirebaseStorage(app: FirebaseApp.instance, 
    storageBucket: kFirebaseStorageBucket);
    
SpUtil spUtil;

UserManager userManager;

final appModule = [];
/// init
///
init() async {
  
  spUtil = await SpUtil.getInstance();

  userManager = await UserManager.getInstance();
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



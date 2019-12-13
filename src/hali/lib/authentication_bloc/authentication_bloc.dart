import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:hali/config/application.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:meta/meta.dart';
import 'package:hali/authentication_bloc/bloc.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => AuthenticationUninitializedState();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      // check for connectivity
      final bool hasInternetAccess = await _checkInternetConnectivity();
      if (!hasInternetAccess) {
        yield AppNeedInternetAccessState(
            'Ứng dụng hiện đang không thể truy cập mạng internet, bạn vui lòng kiểm tra lại kết nối.');
        return;
      }

      // check for location permission
      final hasLocationAccess = await _checkLocationPermissionStatus();
      if (!hasLocationAccess) {
        yield AppNeedLocationAccessState(
            'Ứng dụng cần truy cập vị trí của bạn để có thể tiếp tục hoạt động');
        return;
      }

      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        await _loadUserProfile();
        yield Authenticated(Application.currentUser);
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      logger.e(e);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield PreAuthenticatedState();
    await _loadUserProfile();
    yield Authenticated(Application.currentUser);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  Future<UserProfile> _loadUserProfile() async {
    final userInfo = await _userRepository.getCurrentUserProfileFull();
    assert(userInfo != null);
    Application.currentUser = userInfo;
    await _userRepository.storeFirebaseUserLogged(userInfo);
    await userManager.bind();
    return userInfo;
  }

  /// return true if has internet access
  Future<bool> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult == ConnectivityResult.none) ? false : true;
  }

  /// return true if has location access permission
  Future<bool> _checkLocationPermissionStatus() async {
    var serviceStatus =
        await PermissionHandler().checkServiceStatus(PermissionGroup.location);
    var permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);

    if (serviceStatus == ServiceStatus.unknown ||
        serviceStatus == ServiceStatus.disabled ||
        permissions.values.any((permStat) =>
            permStat == PermissionStatus.denied ||
            permStat == PermissionStatus.disabled ||
            permStat == PermissionStatus.restricted ||
            permStat == PermissionStatus.unknown)) {
      return false;
    }

    return true;
  }
}

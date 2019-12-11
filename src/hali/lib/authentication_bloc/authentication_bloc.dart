import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hali/config/application.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:meta/meta.dart';
import 'package:hali/authentication_bloc/bloc.dart';
import 'package:hali/repositories/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

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
}

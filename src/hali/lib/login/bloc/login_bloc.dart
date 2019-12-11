import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hali/commons/app_error.dart';
import 'package:hali/di/appModule.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hali/login/login.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/utils/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithFacebookPressed) {
      yield* _mapLoginWithFacebookPressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } on AppError catch (e) {
      yield LoginState.failure(e.message);
    } catch (e) {
      logger.d(e);
      yield LoginState.failure("Đăng nhập không thành công");
    }
  }

  Stream<LoginState> _mapLoginWithFacebookPressedToState() async* {
    try {
      await _userRepository.signInWithFacebook();
      yield LoginState.success();
    } on AppError catch (e) {
      yield LoginState.failure(e.message);
    } catch (e) {
      logger.d(e);
      yield LoginState.failure("Đăng nhập không thành công");
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } on AppError catch (e) {
      yield LoginState.failure(e.message);
    } catch (e) {
      logger.d(e);
      yield LoginState.failure("Đăng nhập không thành công");
    }
  }
}

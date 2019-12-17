import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/register/register.dart';
import 'package:hali/utils/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final observableStream = events as Observable<RegisterEvent>;
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
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
          event.email, event.password, event.fullName);
    } else if (event is ResetPasswordSubmitted) {
      yield* _mapFormResetPasswordSubmittedToState(event.email);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
      String email, String password, String fullName) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
          email: email, password: password, fullName: fullName);
      yield RegisterState.success();
    } catch (e) {
      print('>>>>>>> user registration failed');
      print(e);
      yield RegisterState.failure();
    }
  }

  Stream<RegisterState> _mapFormResetPasswordSubmittedToState(
      String email) async* {
    print("begin reset password request for $email");
    yield ResetPasswordState.loading();
    try {
      await _userRepository.sendPasswordResetEmail(email);
      yield ResetPasswordState.success();
    } catch (e) {
      print('>>>>>>> send user reset password failed');
      print(e);
      yield ResetPasswordState.failure();
    }
  }
}

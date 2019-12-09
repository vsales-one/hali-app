import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class FullNameChanged extends RegisterEvent {
  final String fullName;

  const FullNameChanged({@required this.fullName});

  @override
  List<Object> get props => [fullName];

  @override
  String toString() => 'FullNameChanged { email :$fullName }';
}

class EmailChanged extends RegisterEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String fullName;

  const Submitted({
    @required this.email,
    @required this.password,
    @required this.fullName,
  });

  @override
  List<Object> get props => [email, password, fullName];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password, fullName: $fullName }';
  }
}

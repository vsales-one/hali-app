import 'package:equatable/equatable.dart';
import 'package:hali/models/user_profile.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitializedState extends AuthenticationState {}

class PreAuthenticatedState extends AuthenticationState {}

class Authenticated extends AuthenticationState {  
  final UserProfile userInfo;

  const Authenticated(this.userInfo);

  @override
  List<Object> get props => [userInfo];

  @override
  String toString() => 'Authenticated { uid: ${userInfo.id} displayName: ${userInfo.displayName} }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}

class AppNeedInternetAccessState extends AuthenticationState {
  final String message;

  AppNeedInternetAccessState(this.message);

  @override
  String toString() => 'AppNeedInternetAccessState';
}

class AppNeedLocationAccessState extends AuthenticationState {
  final String message;

  AppNeedLocationAccessState(this.message);

  @override
  String toString() => 'AppNeedLocationAccessState';
}

class AppNeedUpdateState extends AuthenticationState {
  @override
  String toString() => 'AppNeedUpdateState';
}

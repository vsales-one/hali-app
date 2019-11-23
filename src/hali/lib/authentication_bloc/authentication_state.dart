import 'package:equatable/equatable.dart';
import 'package:hali/models/user_profile.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {  
  final UserProfile userInfo;

  const Authenticated(this.userInfo);

  @override
  List<Object> get props => [userInfo];

  @override
  String toString() => 'Authenticated { uid: ${userInfo.id} displayName: ${userInfo.displayName} }';
}

class Unauthenticated extends AuthenticationState {}

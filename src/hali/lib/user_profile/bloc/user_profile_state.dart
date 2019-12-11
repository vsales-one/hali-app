
import 'package:equatable/equatable.dart';
import 'package:hali/models/user_profile.dart';
import 'package:meta/meta.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

@immutable
class UserProfileLoadingState extends UserProfileState {}

@immutable
class UserProfileLoadedState extends UserProfileState {
  final UserProfile userProfile;

  UserProfileLoadedState(this.userProfile);

  @override
  List<Object> get props => [userProfile];
}

@immutable
class UserProfileUpdatedState extends UserProfileState {
  final UserProfile userProfile;
  
  UserProfileUpdatedState(this.userProfile) ;

  @override
  List<Object> get props => [userProfile];
}

@immutable
class UserProfileNotLoadedState extends UserProfileState {}

@immutable
class UserProfileNotUpdatedState extends UserProfileState {}
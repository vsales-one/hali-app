import 'package:hali/models/user_profile.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
  @override
  List<Object> get props => [];
}


class UserProfileLoading extends UserProfileEvent { 
}


class UserProfileUpdating extends UserProfileEvent {
  final UserProfile userProfile;

  const UserProfileUpdating({@required this.userProfile});

  @override
  List<Object> get props => [userProfile];

  @override
  String toString() => 'UserProfileUpdating { email :${userProfile.email} }';
}


class UserProfileUpdated extends UserProfileEvent {
  final UserProfile userProfile;

  const UserProfileUpdated({@required this.userProfile});

  @override
  List<Object> get props => [userProfile];

  @override
  String toString() => 'UserProfileUpdated { email :${userProfile.email} }';
}
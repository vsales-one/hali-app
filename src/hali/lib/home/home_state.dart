import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:hali/commons/app_error.dart';
import 'package:hali/user_profile/user_profile_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  @override
  String toString() => 'HomeInitial';
}

class HomeLoading extends HomeState {
  @override
  String toString() => 'HomeLoading';
}

class HomeFailure extends HomeState {  
  final AppError error;

  HomeFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'HomeFailure';
}

class HomeFetchUserSuccess extends HomeState {
  final UserProfileModel userModel;  

  HomeFetchUserSuccess({@required this.userModel})
      : assert(userModel != null);

  @override
  List<Object> get props => [userModel];

  @override
  String toString() => 'HomeFetchUserSuccess';
}

class HomeAvatarUploadInprogressSuccess extends HomeState {
  final String userAvatarUrl;

  HomeAvatarUploadInprogressSuccess({this.userAvatarUrl});

  @override
  List<Object> get props => [userAvatarUrl];

  @override
  String toString() => 'HomeAvatarUploadInprogressSuccess';
}

class HomeAvatarUploadSuccess extends HomeState {
  final String userAvatarUrl;

  HomeAvatarUploadSuccess({this.userAvatarUrl}) ;

  @override
  List<Object> get props => [userAvatarUrl];

  @override
  String toString() => 'HomeAvatarUploadSuccess';
}
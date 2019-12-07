import 'dart:async';
import 'dart:developer' as developer;

import 'package:hali/my_profile/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyProfileEvent {
  Future<MyProfileState> applyAsync(
      {MyProfileState currentState, MyProfileBloc bloc});
}

class UnMyProfileEvent extends MyProfileEvent {
  @override
  Future<MyProfileState> applyAsync({MyProfileState currentState, MyProfileBloc bloc}) async {
    return UnMyProfileState(0);
  }
}

class LoadMyProfileEvent extends MyProfileEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadMyProfileEvent';

  LoadMyProfileEvent(this.isError);

  @override
  Future<MyProfileState> applyAsync(
      {MyProfileState currentState, MyProfileBloc bloc}) async {


  }
}

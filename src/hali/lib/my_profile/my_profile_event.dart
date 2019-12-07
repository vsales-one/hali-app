import 'dart:async';
import 'dart:developer' as developer;

import 'package:new_instagramm/my_profile/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MyProfileEvent {
  Future<MyProfileState> applyAsync(
      {MyProfileState currentState, MyProfileBloc bloc});
  final MyProfileRepository _myProfileRepository = MyProfileRepository();
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
    try {
      if (currentState is InMyProfileState) {
        return currentState.getNewVersion();
      }
      await Future.delayed(Duration(seconds: 2));
      this._myProfileRepository.test(this.isError);
      return InMyProfileState(0, "Hello world");
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadMyProfileEvent', error: _, stackTrace: stackTrace);
      return ErrorMyProfileState(0, _?.toString());
    }
  }
}

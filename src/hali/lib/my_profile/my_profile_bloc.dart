import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:hali/my_profile/index.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  // todo: check singleton for logic in project
  static final MyProfileBloc _myProfileBlocSingleton = MyProfileBloc._internal();
  factory MyProfileBloc() {
    return _myProfileBlocSingleton;
  }
  MyProfileBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    super.close();
  }

  MyProfileState get initialState => UnMyProfileState(0);

  @override
  Stream<MyProfileState> mapEventToState(
    MyProfileEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'MyProfileBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}

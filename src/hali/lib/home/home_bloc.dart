import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:hali/commons/app_error.dart';
import 'package:hali/home/index.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/user_profile/user_profile_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  
  HomeState get initialState => new HomeInitial();

  final UserRepository userRepository;
  final HomeRepository homeRepository;
  
  HomeBloc({ @required this.userRepository, @required this.homeRepository});
  
  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
            
    if (event is LoadHomeEvent){
      yield HomeLoading();
      try {
        final UserProfileModel userProfile = await userRepository.getUserProfile();        
        yield HomeFetchUserSuccess(userModel: userProfile);
      }
      on DioError catch(error) {        
        final vserror = AppError(message: error.message, statusCode: error.response.statusCode);
        yield HomeFailure(error: vserror);
      }
      catch(error) {
        final e = AppError(message: error.response.data["Message"], statusCode: error.response.statusCode);
        yield HomeFailure(error: e);
      }
    }
  }
}

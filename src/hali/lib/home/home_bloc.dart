import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hali/home/index.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeState get initialState => new HomeUninitialized();

  final UserRepository userRepository;
  final HomeRepository homeRepository;

  HomeBloc({@required this.userRepository, @required this.homeRepository});
  
  @override
Stream<HomeState> transformEvents(
  Stream<HomeEvent> events,
  Stream<HomeState> Function(HomeEvent event) next,
) {
  return super.transformEvents(
    (events as Observable<HomeEvent>).debounceTime(
      Duration(milliseconds: 500),
    ),
    next,
  );
}

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    final currentState = state;
    if (event is HomeFetchEvent && !_hasReachedMax(currentState)) {
      try {
        if (currentState is HomeUninitialized) {
          var currentPage = 0;
          final responsePost =
              await homeRepository.fetchPosts(currentPage, 10);
          if (responsePost.data != null) {
            yield HomeLoaded(posts: responsePost.data, hasReachedMax: false, currentPage: currentPage + 1);
          } else {
            yield HomeError(responsePost.error);
          }
          return;
        }
        if (currentState is HomeLoaded) {
          final res =
              await homeRepository.fetchPosts(currentState.currentPage, 10);
          final posts = res.data;
          if (posts != null) {
            yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : HomeLoaded(
                  posts: currentState.posts + posts,
                  hasReachedMax: false,
                  currentPage: currentState.currentPage + 1
                );
          } else {
             yield HomeError(res.error);
          }
          
        }
      } catch (e) {
        yield HomeError(e);
      }
    }
  }

  bool _hasReachedMax(HomeState state) =>
      state is HomeLoaded && state.hasReachedMax;
}

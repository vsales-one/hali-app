import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hali/home/index.dart';
import 'package:hali/repositories/user_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeState get initialState => new HomeUninitialized();

  final UserRepository userRepository;
  final HomeRepository homeRepository;

  HomeBloc({@required this.userRepository, @required this.homeRepository});

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    final currentState = state;
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is HomeUninitialized) {
          final responsePost =
              await homeRepository.fetchPosts(event.currentPage, 10);
          yield HomeLoaded(posts: responsePost.data, hasReachedMax: false);
          return;
        }
        if (currentState is HomeLoaded) {
          final res =
              await homeRepository.fetchPosts(event.currentPage + 1, 10);
          final posts = res.data;
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : HomeLoaded(
                  posts: currentState.posts + posts,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield HomeError();
      }
    }
  }

  bool _hasReachedMax(HomeState state) =>
      state is HomeLoaded && state.hasReachedMax;
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/home/index.dart';
import 'package:hali/models/item_listing_message.dart';
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
      final queryParams = {
        "categoryId.equals": event.categoryId,
        "status.equals": ItemRequestMessageStatus.Open.toString()
      };
      try {
        if (currentState is HomeUninitialized) {
          var currentPage = 0;
          final responsePost = await homeRepository.fetchPosts(
            queryParams,
            currentPage,
            kPageSize,
          );
          if (responsePost.data != null) {
            final bHasReachedMax =
                currentPage <= 1 && (responsePost.data.length <= kPageSize);
            yield HomeLoaded(
              posts: responsePost.data,
              hasReachedMax: bHasReachedMax ? true : false,
              currentPage: currentPage + 1,
            );
          } else {
            yield HomeError(responsePost.error);
          }
          return;
        }
        if (currentState is HomeLoaded) {
          final res = await homeRepository.fetchPosts(
            queryParams,
            currentState.currentPage,
            kPageSize,
          );
          final posts = res.data;
          final bHasReachedMax =
              currentState.currentPage == 1 && (posts.length <= kPageSize);
          if (posts != null) {
            yield posts.isEmpty
                ? currentState.copyWith(hasReachedMax: true)
                : HomeLoaded(
                    posts: currentState.posts + posts,
                    hasReachedMax: bHasReachedMax,
                    currentPage: currentState.currentPage + 1);
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

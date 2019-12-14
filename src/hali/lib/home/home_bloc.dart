import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/di/appModule.dart';
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
  Future<void> close() {
    print(">>>>>>> closing the HomeBloc...");
    return super.close();
  }

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
        // "categoryId.equals": event.categoryId,
        "status.equals": EnumToString.parse(ItemRequestMessageStatus.Open)
      };
      try {
        if (currentState is HomeUninitialized) {
          var currentPage = 0;
          final responsePost = await homeRepository.fetchPosts(
            queryParams,
            currentPage,
            kPageSize,
            event.lastDocumentOrderFieldRef
          );
          if (responsePost.data != null) {            
            logger.d(
                ">>>>>>> HomeUninitialized -> yield HomeLoaded - posts: ${responsePost.data.length}");
            final posts = responsePost.data;
            final lastDocRef = posts.length > 0 ? posts[posts.length - 1].id : "";
            yield HomeLoaded(
              posts: posts,
              hasReachedMax: false,
              currentPage: currentPage + 1,
              lastDocumentOrderFieldRef: lastDocRef,
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
            event.lastDocumentOrderFieldRef,
          );
          final posts = res.data;
          logger.d(
              ">>>>>>> HomeLoaded -> yield HomeLoaded - posts: ${posts.length}");
          final lastDocRef = posts.length > 0 ? posts[posts.length - 1].id : "";
          if (posts != null) {
            yield posts.isEmpty
                ? currentState.copyWith(hasReachedMax: true)
                : HomeLoaded(
                    posts: currentState.posts + posts,
                    hasReachedMax: false,
                    currentPage: currentState.currentPage + 1,
                    lastDocumentOrderFieldRef: lastDocRef,
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

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/models/user_profile.dart';
import 'package:meta/meta.dart';
import 'package:hali/commons/app_error.dart';

abstract class HomeState extends Equatable {

  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeUninitialized extends HomeState {
  @override
  String toString() => 'HomeUninitialized';
}

class HomeError extends HomeState {
  final DioError error;

  HomeError(this.error);

  @override
  String toString() => 'HomeError';
}
class HomeLoaded extends HomeState { 

  final List<PostModel> posts;
  final bool hasReachedMax;
  final int currentPage;

  const HomeLoaded({
    this.posts,
    this.hasReachedMax,
    this.currentPage
  });

  HomeLoaded copyWith({
    List<PostModel> posts,
    bool hasReachedMax,
    int currentPage,
  }) {
    return HomeLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? 0
    );
  }
  @override
  List<Object> get props => [posts, hasReachedMax, currentPage];
  
  @override
  String toString() =>
      'HomeLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax , currentPage: $currentPage }';
}
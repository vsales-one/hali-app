import 'package:equatable/equatable.dart';
import 'package:hali/models/post_model.dart';

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
  final dynamic error;  

  HomeError(this.error);

  @override
  String toString() => 'HomeError';
}

class HomeLoaded extends HomeState { 
  final List<PostModel> posts;
  final bool hasReachedMax;
  final int currentPage;
  final String lastDocumentOrderFieldRef;

  const HomeLoaded({
    this.posts,
    this.hasReachedMax,
    this.currentPage,
    this.lastDocumentOrderFieldRef,
  });

  HomeLoaded copyWith({
    List<PostModel> posts,
    bool hasReachedMax,
    int currentPage,
    String lastDocumentOrderFieldRef,
  }) {
    return HomeLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? 0,
      lastDocumentOrderFieldRef: lastDocumentOrderFieldRef,
    );
  }
  @override
  List<Object> get props => [posts, hasReachedMax, currentPage, lastDocumentOrderFieldRef];
  
  @override
  String toString() =>
      '''HomeLoaded { 
          posts: ${posts.length}, 
          hasReachedMax: $hasReachedMax , 
          currentPage: $currentPage, 
          lastDocumentOrderFieldRef: $lastDocumentOrderFieldRef 
        }''';
}
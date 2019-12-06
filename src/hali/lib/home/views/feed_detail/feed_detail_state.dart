import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hali/models/post_model.dart';

abstract class FeedDetailState extends Equatable {

  const FeedDetailState();

  @override
  List<Object> get props => [];
}

class FeedDetailUninitialized extends FeedDetailState {
  final int postId;
  FeedDetailUninitialized({ this.postId });
  @override
  String toString() => 'FeedDetailUninitialized';
  
}

class FeedDetailError extends FeedDetailState {
  final DioError error;

  FeedDetailError({ this.error });

  @override
  String toString() => 'HomeError';
}

class FeedDetailLoaded extends FeedDetailState {

  final PostModel postModel;

  FeedDetailLoaded({this.postModel});

  FeedDetailLoaded copyWith({
    final PostModel postModel
  }) {
    return FeedDetailLoaded(postModel: postModel);
  }
  
  @override
  String toString() => 'FeedDetailLoaded';
}

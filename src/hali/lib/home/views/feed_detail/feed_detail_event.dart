import 'package:equatable/equatable.dart';


abstract class FeedDetailEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class FeedEventFetch extends FeedDetailEvent {

  final int postId;

  FeedEventFetch({ this.postId });

   @override
  List<Object> get props => [postId];

  String toString() => 'FeedEventFetch: $postId';
}
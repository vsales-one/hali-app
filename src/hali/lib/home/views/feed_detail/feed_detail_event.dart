import 'package:equatable/equatable.dart';
import 'package:hali/models/post_model.dart';


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

class RequestListingConfirmationEvent extends FeedDetailEvent {
  final PostModel post;

  RequestListingConfirmationEvent({this.post});

  @override
  List<Object> get props => [post];

  String toString() => 'RequestListingConfirmationEvent: ${post.id}';
}
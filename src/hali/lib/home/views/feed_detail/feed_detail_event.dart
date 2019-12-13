import 'package:equatable/equatable.dart';
import 'package:hali/models/post_model.dart';
import 'package:meta/meta.dart';


abstract class FeedDetailEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class FeedEventFetch extends FeedDetailEvent {

  final String postId;

  FeedEventFetch({ this.postId });

  @override
  List<Object> get props => [postId];

  String toString() => 'FeedEventFetch: $postId';
}

class RequestListingConfirmationEvent extends FeedDetailEvent {
  final String postId;
  final PostModel post;

  RequestListingConfirmationEvent({@required this.postId, @required this.post});

  @override
  List<Object> get props => [postId, post];

  String toString() => 'RequestListingConfirmationEvent: ${post.id}';
}
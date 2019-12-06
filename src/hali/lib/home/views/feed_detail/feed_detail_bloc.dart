import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hali/home/views/feed_detail/index.dart';
import 'package:hali/repositories/post_repository.dart';

class FeedDetailBloc extends Bloc<FeedDetailEvent, FeedDetailState> {
  
  final PostRepository postRepository;

  FeedDetailBloc({ this.postRepository });

  FeedDetailState get initialState => FeedDetailUninitialized();

  @override
  Stream<FeedDetailState> mapEventToState(
    FeedDetailEvent event,
  ) async* {
    final currentState = state;
    if(event is FeedEventFetch) {
      if(currentState is FeedDetailUninitialized) {
        final response = await postRepository.getPostById(event.postId);
        if(response.error == null) {
          yield FeedDetailLoaded(postModel: response.data);
        } else {
          yield FeedDetailError(error: response.error);
        }
      }
    }
  }
}

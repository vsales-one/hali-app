import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hali/config/application.dart';
import 'package:hali/home/views/feed_detail/index.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/repositories/user_repository.dart';

class FeedDetailBloc extends Bloc<FeedDetailEvent, FeedDetailState> {
  
  final PostRepository postRepository;
  final UserRepository userRepository;

  FeedDetailBloc({ this.postRepository, this.userRepository });

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
    } else if(event is RequestListingConfirmationEvent) {
      final post = event.post;
      final requestor = Application.currentUser;
      final toUser = await userRepository.getUserProfileByEmail(post.lastModifiedBy);
      final requestItem = ItemListingMessage.fromNamed(
        itemType: post.categoryCategoryName,
        itemId: post.id.toString(),
        itemTitle: post.title,
        itemImageUrl: post.imageUrl,
        from: requestor,
        to: toUser,
        isSeen: false,
        publishedAt: DateTime.now(),
        status: ItemRequestMessageStatus.Open
      );
      yield RequestListingConfirmationState(message: requestItem);
    }
  }
}
